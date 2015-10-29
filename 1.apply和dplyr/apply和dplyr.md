高效数据处理工具（一）：for loop functionals & plyr
========================================================
author: Milton Deng
date: 2015-10-28

避免for循环
========================================================

在R语言中你可能最常听到的告诫就是“不要写for语句”。的确，当你写Matlab之类的程序时，你可能很习惯于“建立一个向量=>遍历向量的每一个元素=>分步计算”的方式，但是在R语言中我们几乎不会这样去做。

- Bullet 1
- Bullet 2
- Bullet 3

Slide With Code
========================================================


```r
summary(cars)
```

```
     speed           dist       
 Min.   : 4.0   Min.   :  2.00  
 1st Qu.:12.0   1st Qu.: 26.00  
 Median :15.0   Median : 36.00  
 Mean   :15.4   Mean   : 42.98  
 3rd Qu.:19.0   3rd Qu.: 56.00  
 Max.   :25.0   Max.   :120.00  
```

Slide With Plot
========================================================

![plot of chunk unnamed-chunk-2](Advanced-Tools-figure/unnamed-chunk-2-1.png) 
