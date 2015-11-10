library(shiny)
library(dplyr)
library(reshape2)
library(ggplot2)
#source("helper.R")

shinyServer(function(input,output){
  #

  set.seed(1234)
  df5<-round(rnorm(200, mean = 60, sd = 15))
  
 
  #get the coresponding data
  mydata<-reactive({
    #选择需要展示的变量对应的数据集
    return(my_data_fun(plot_type = input$plot_class))
    
  })


  output$myplot1<-renderPlot({
    print(my_plot_fun(mydata = mydata(), plot_type = input$plot_class))
    })
  
})