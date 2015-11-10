library(shiny)
library(dplyr)
library(reshape2)
library(ggplot2)
#source("helper.R")

shinyUI(fluidPage(

  # Application title
  headerPanel(h3("ggplot2绘图 Demo")),
  sidebarLayout(
    sidebarPanel(
      selectInput("plot_class", label = h4("选择一种绘图类型:"),
                  choices = list("boxplot","violinplot","dotplot",
                                 "strip","densityplot", "histogram",
                                 "scatter","barplot","bp","ecdf"),
                  selected = "boxplot"),
      
     br() 
    ),
    mainPanel(h4("绘图示例"),
     plotOutput("myplot1")
      )
  )
  
))
