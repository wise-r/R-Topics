my_data_fun<-function(plot_type){
  df1<-mutate(ToothGrowth, dose = as.factor(dose))
  set.seed(1234)
  df2<-data.frame(sex = factor(rep(c("F","M"), each = 200)),
                  weight = round(c(rnorm(200, mean = 55, sd = 5), rnorm(200, mean = 65, sd = 5))))
  
  df2_mu<-group_by(df2, sex) %>%
    summarise(grp.mean = mean(weight))
  
  df3<-group_by(ToothGrowth, supp, dose) %>%
    summarise(sd = sd(len, na.rm = TRUE),
              len = mean(len, na.rm = TRUE))
  
  
  df4<-data.frame(
    group = c("Male","Female", "Child"),
    value = c(25,25,50)
  )
  
  set.seed(1234)
  df5<-round(rnorm(200, mean = 60, sd = 15))
  
  
  switch(plot_type,
         boxplot = df1,
         
         violinplot = df1,
         
         dotplot = df1,
         
         strip = df1,
         
         #
         
         densityplot = list(data1 = df2,data2 = df2_mu),
         
         histogram = list(data1 = df2,data2 = df2_mu),
         
         scatter = NULL,
   
         barplot = df3,
         
         bp = df4,
         
         
         ecdf = df5
         
  )
  
}


my_plot_fun<-function(mydata, plot_type){
  require(scales)        
  
  blank_theme<- theme_minimal()+
    theme(
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      panel.border = element_blank(),
      panel.grid = element_blank(),
      axis.ticks = element_blank(),
      plot.title = element_text(size = 14, face = "bold")
    )
  
  switch(plot_type,
          boxplot = ggplot(mydata, aes(x = dose, y = len, fill = dose))+
            geom_boxplot()+
            labs(title = "Plot of length per dose", x = " Dose(mg)", y = "length")+
            scale_fill_brewer(palette = "RdBu")+
            theme_classic(),
          
          violinplot = ggplot(mydata, aes(x = dose, y = len, fill = dose))+
            geom_violin(trim = FALSE)+
            geom_boxplot(width = 0.1, fill = "white")+
            labs(title = "Plot of length per dose", x = " Dose(mg)", y = "length")+
            scale_fill_brewer(palette = "Blues")+
            theme_classic(),
          
          dotplot = ggplot(mydata, aes(x = dose, y = len, fill = dose))+
            geom_dotplot(binaxis = "y", stackdir = "center")+
            labs(title = "Plot of length per dose", x = " Dose(mg)", y = "length")+
            scale_fill_brewer(palette = "Dark2")+
            theme_classic(),
          
          strip = ggplot(mydata, aes(x = dose, y = len, color = dose, shape = dose))+
            geom_jitter(position = position_jitter(0.2))+
            labs(title = "Plot of length per dose", x = " Dose(mg)", y = "length")+
            scale_fill_brewer(palette = "Dark2")+
            theme_classic(),
          
          #

          densityplot = ggplot(data.frame(mydata[[1]]), aes(x = weight, color = sex, fill = sex))+
            geom_density()+
            geom_vline(data = data.frame(mydata[[2]]), aes(xintercept = grp.mean, color = sex), linetype = 'dashed')+
            labs(title="Weight density curve",x="Weight(kg)", y = "Density")+
            scale_color_manual(values = c("#999999", "#E69F00","#56B4E9")),
          
          histogram = ggplot(data.frame(mydata[[1]]), aes(x = weight, color = sex))+
            geom_histogram(fill = "white", position = "dodge")+
            geom_vline(data = data.frame(mydata[[2]]), aes(xintercept = grp.mean, color = sex), linetype = "dashed")+
            scale_color_brewer(palette = "Dark2")+
            theme_minimal()+
            theme_classic()+
            theme(legend.position = "top"),
          
          scatter = ggplot(mtcars, aes(x = wt, y = mpg, color = as.factor(cyl), shape = as.factor(cyl)))+
            geom_point()+
            geom_smooth(method = lm, se = FALSE, fullrange = TRUE)+
            labs(title="Miles per gallon \n according to the weight",
                 x="Weight (lb/1000)", y = "Miles/(US) gallon")+
            theme_classic()+
            scale_color_brewer(palette = "Accent")+
            theme_minimal(),
    
           

          barplot = ggplot(mydata, aes(x = dose, y = len, fill = supp))+
            geom_bar(stat = "identity", position = position_dodge())+
            geom_errorbar(aes(ymin = len - sd, ymax = len + sd), width = .2, position = position_dodge(0.9))+
            labs(title="Plot of length per dose",
                 x="Dose (mg)", y = "Length")+
            scale_fill_brewer(palette = "Greens")+
            theme_minimal(),
          
          bp = ggplot(mydata, aes(x = "", y = value, fill = group))+
            geom_bar(width =1, stat = "identity")+
            coord_polar("y", start = 0)+scale_fill_brewer("Blues")+blank_theme+
            theme(axis.text.x = element_blank())+
            geom_text(aes(y = value/3 + c(0, cumsum(value)[-length(value)]),
                          label = percent(value/100)), size =5),
          

          ecdf = qplot(mydata, stat = "ecdf", geom = "step")+
            labs(title="Empirical Cumulative \n Density Function",
                 y = "F(height)", x="Height in inch")+
            theme_classic()
          
        )
        
  
}
