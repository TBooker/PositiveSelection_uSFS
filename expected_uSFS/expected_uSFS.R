rm(list = ls())

library(ggplot2)
library(wesanderson)
library(scales)

pal <-wes_palette("GrandBudapest1", 3)

TommyTheme <-theme_bw()+
  theme(
    axis.title.x = element_text(size=14,angle=0),
    axis.title.y = element_text(size=14,angle=90,vjust=0.5),
    axis.text.x = element_text(size=12,angle=0, color = 'black'),
    axis.text.y = element_text(size=12,angle=0, color = 'black'),
    legend.title = element_blank(),
    legend.text = element_text(size =13),
    strip.text.x = element_text(size = 15),
    strip.text.y = element_text(size = 20)
  )

s1000<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS1000.csv')
s100<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS100.csv')
s10<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS10.csv')

sfs<- rbind(s1000,s100,s10)

tapply(sfs$SFS_i*6000000, as.factor(sfs$S),sum)

sfs$S <- factor(sfs$S, levels = levels(as.factor(sfs$S)), labels = c(expression(italic(gamma[a])*' = 10; '*italic(p[a])*' = 0.01'),expression(gamma[a]*' = 100; '*p[a]*' = 0.001'),expression(gamma[a]*' = 1000; '*p[a]*' = 0.0001')) )

ggplot(data = sfs, aes(x = i, y = SFS_i*14000000, col = as.factor(S)))+
  geom_line()+
  scale_y_log10('Expected number of segregating sites')+
  scale_x_continuous('Derived Allele count', limits = c(1,39))+
  scale_color_manual(values = pal, labels = parse_format())+
  TommyTheme
