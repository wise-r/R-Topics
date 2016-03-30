# 载入packages
library(RCurl)
library(rvest)
library(stringr)
library(plyr)
library(dplyr)

# 爬取豆瓣电影TOP250的数据
# 获取豆瓣电影首页URL
DoubanUrl <- 'http://movie.douban.com/top250'

# 从首页中获取所有页面的URL
PageUrlList <- read_html(DoubanUrl) %>% 
    html_nodes(xpath = "//div[@class='paginator']/a") %>% 
    html_attr("href") %>% 
    str_c(DoubanUrl, ., sep="") %>% c(DoubanUrl,.)

# 从每个PageUrl中提取出每部电影的链接
MovieUrl <-  NULL
for (url in PageUrlList) {
    item = read_html(url) %>% 
        html_nodes(xpath="//div[@class='hd']/a/@href") %>% 
        str_extract('https[\\S]+[\\d]{7}')
    MovieUrl = c(MovieUrl, item)
}

# 从每个MovieUrl中提取出最终的数据
## 定义函数getdata，用于获取数据并输出dataframe格式
GetImdbScore <- function(url){
    ImdbScore = read_html(url) %>% 
        html_nodes(xpath = "//span[@itemprop='ratingValue']/text()") %>% 
        html_text()
    return(ImdbScore)
}
getdata <- function(url){
    Movie = url
    if(url.exists(url)){
        MovieHTML = read_html(url, encoding = 'UTF-8')
        Rank = html_nodes(MovieHTML, xpath = "//span[@class='top250-no']/text()") %>% html_text()
        MovieName = html_nodes(MovieHTML, xpath = "//span[@property='v:itemreviewed']/text()") %>% html_text()
        Director = html_nodes(MovieHTML, xpath = "//a[@rel='v:directedBy']/text()") %>% 
            html_text() %>% paste(collapse = ";")
        Type = html_nodes(MovieHTML, xpath = "//span[@property='v:genre']/text()") %>% 
            html_text() %>% paste(collapse = ";")
        Score = html_nodes(MovieHTML, xpath = "//strong[@property='v:average']/text()") %>% html_text()
        ImdbUrl = html_nodes(MovieHTML, xpath = "//a[contains(@href,'imdb')]/@href") %>% html_text()
        ImdbScore = GetImdbScore(ImdbUrl) 
        Description = html_nodes(MovieHTML, xpath = "//span[@property='v:summary']/text()") %>% 
            html_text() %>% str_replace("\n[\\s]+", "") %>% paste(collapse = ";")
        data.frame(Rank, Movie, MovieName, Director, Type, Score, ImdbScore, Description)
    }
}

## 抓取数据

Douban250 <- data.frame()
for (i in 1:length(MovieUrl)) {
    Douban250 = rbind(Douban250, getdata(MovieUrl[i]))
    print(paste("Movie",i,sep = "-"))
    Sys.sleep(round(runif(1,1,3)))
}

# 豆瓣API
url <- "https://api.douban.com/v2/movie/1292052"
library(rvest)
result <- read_html(url)
result <- html_nodes(result, "p") %>% html_text()
class(result)
library(rjson)
a = rjson::fromJSON(result)