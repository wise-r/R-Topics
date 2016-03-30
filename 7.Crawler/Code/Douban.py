#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: zengphil
# @Date:   2016-03-24 22:13:13
# @Last Modified by:   zengphil
# @Last Modified time: 2016-03-29 14:07:44

import urllib
import urllib2
import re
import time
import random
import json
import requests

from lxml.html import parse
from agents import AGENTS
from bs4 import BeautifulSoup


# 爬取豆瓣电影TOP250的数据
# 获取豆瓣电影首页URL
DoubanUrl = "https://movie.douban.com/top250"
response = urllib2.urlopen(DoubanUrl)
parsed = parse(response)

# 从首页中获取所有页面的URL
PageUrl = [DoubanUrl+Page for Page in parsed.xpath("//div[@class='paginator']/a/@href")]

# 从每个PageUrl中提取出每部电影的链接
MovieUrl = []
for url in PageUrl:
    MovieUrl.append(parse(urllib2.urlopen(url)).xpath("//div[@class='hd']/a/@href"))

# 从每个MovieUrl中提取出最终的数据
## 定义函数GetImdbScore，用于获取Imdb网页中的评分数据
def GetImdbScore(url):
    return parse(urllib2.urlopen(url)).xpath("//span[@itemprop='ratingValue']/text()")

## 定义函数GetData, 用于解析网页并获取数据\
## 定义函数GetOpener, 用于构建爬虫处理器
def GetIPList(IPUrl):
    """haodaliip website"""
    soup = BeautifulSoup(requests.get(IPUrl).text, 'lxml')
    IPList = []
    for IPItem in soup.select('tr[style*="font-size"]'):
        IPAddress = re.findall(r'\d+.\d+.\d+.\d+',IPItem.select('td')[0].text)
        IPPort = re.findall(r'\d+', IPItem.select('td')[1].text)
        IPList.append({
            "IPAddress": IPAddress,
            "IPPort": IPPort
            })
    return IPList

IPUrl = 'http://www.haodailiip.com/guonei'
IPSet = GetIPList(IPUrl)

def GetParsedData(url):
    user_agent = random.choice(AGENTS)
    Headers = {
        'Host':'movie.douban.com',
        'User-Agent': user_agent
    }
    # Proxy = random.choice(IPSet)
    # ProxyAddress = "http://" + Proxy['IPAddress'][0] + ":" + Proxy['IPPort'][0]
    # proxy_handler = urllib2.ProxyHandler({"http": ProxyAddress})
    # opener = urllib2.build_opener(proxy_handler)
    # urllib2.install_opener(opener)
    # crawl data
    request = urllib2.Request(url, headers=Headers)
    try:
        response = urllib2.urlopen(request)
        parsed = parse(response)
    except urllib2.URLError, e:
        print e.reason
        parsed = []
    return parsed

def GetData(url):
    parsed = GetParsedData(url)
    if parsed != []:
        Rank = parsed.xpath("//span[@class='top250-no']/text()")
        MovieName = parsed.xpath("//span[@property='v:itemreviewed']/text()")
        Director = parsed.xpath("//a[@rel='v:directedBy']/text()")
        Type = parsed.xpath("//span[@property='v:genre']/text()")
        Score = parsed.xpath("//strong[@property='v:average']/text()")
        #ImdbUrl = parsed.xpath("//a[contains(@href,'imdb')]/@href")
        #ImdbScore = GetImdbScore(ImdbUrl[0])
        Description = parsed.xpath("//span[@property='v:summary']/text()")
        Douban250 = {
            'Rank': Rank,
            'MovieUrl': url,
            'MovieName': MovieName,
            'Director': Director,
            'Type': Type,
            'Score': Score,
            #'ImdbScore': ImdbScore,
            'Description': Description
        }
        return Douban250

## 循环获取每部电影的数据，并导出json格式的数据
Douban250 = []
print("Start to crawl the MovieData...")
for i in range(0,len(MovieUrl)):
    for url in MovieUrl[i]:
        print "Target==>", url
        print "Please wait..."
        Douban250.append(GetData(url))
        print "DONE! Next Movie..."
        print "Wait 5 seconds"
        time.sleep(5)
print "Congratulation!!!"
with open('Douban250.json','w') as f:
    f.write(json.dumps(Douban250))



