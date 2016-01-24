
#############################
##### 1.讲座数据获取   #####

#############################
######登陆选讲座系统########
##selenium
library(Rwebdriver)
library(XML)

#
quit_session()
start_session(root = "http://localhost:4444/wd/hub/",browser = "firefox")
#

#
#post.url(url = 'http://event.wisesoe.com/Logon.aspx?from=auth&returnUrl=Default.aspx&err=noauthentication')
post.url(url = 'http://event.wisesoe.com/Logon.aspx')

for(i in 1:3){
  page_refresh()
  Sys.sleep(1)
}
# urlIn<-'http://event.wisesoe.com/LectureOrder.aspx'
# while(get.url()!=urlIn){
#   page_refresh()
# }


get.url()

page_title()

StudentID<-element_xpath_find(value = '//*[@name="UserName"]')
code<-element_xpath_find(value = '//*[@name="Password"]')

element_click(StudentID)
keys("15420141151979")

element_click(code)
keys("253311")

submitID<-element_xpath_find(value = '//*[@id="default-main"]//div/input')
element_click(submitID)
get.url()
page_title()

#my reservation
MakeReversation<-element_xpath_find(value = '//*[@id="default-menu-control"]/ul/li[1]/a')
MyReservation<-element_xpath_find(value = '//*[@id="default-menu-control"]/ul/li[2]/a')
myAccount<-element_xpath_find(value = '//*[@id="default-menu-control"]/ul/li[3]/a')
element_click(MyReservation)

element_click(MakeReversation)

#上学习
ChooseSemester<-element_xpath_find(value = '//*[@id="ctl00_MainContent_termddl"]')
LastSemester<-element_xpath_find(value = '//*[@id="ctl00_MainContent_termddl"]/option[2]')
FirstSemester<-element_xpath_find(value = '//*[@id="ctl00_MainContent_termddl"]/option[1]')

element_click(ChooseSemester)
element_click(LastSemester)
#
pageSource<-page_source()
pageParsed<-htmlParse(pageSource,encoding = "UTF-8")
myTable1<-readHTMLTable(pageParsed,header = TRUE)
View(myTable1)


page_refresh()
element_click(ChooseSemester)
element_click(FirstSemester)
#
pageSource<-page_source()
pageParsed2<-htmlParse(pageSource,encoding = "UTF-8")
myTable12<-readHTMLTable(pageParsed2,header = TRUE)
str(myTable12)

FirstLecture<-myTable12
SecondLecture<-myTable1

save(FirstLecture,file = "Homework2_for_R_Topics/data/FirstLecture.rda")
save(SecondLecture,file = "Homework2_for_R_Topics/data/SecondLecture.rda")
