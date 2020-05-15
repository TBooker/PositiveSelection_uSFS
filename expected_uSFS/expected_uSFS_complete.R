rm(list = ls())

library(ggplot2)
library(ggthemes)
library(wesanderson)
library(scales)


pal <-wes_palette("GrandBudapest1", 3)

TommyTheme <-theme_bw()+
  theme(
    axis.title.x = element_text(size=14,angle=0),
    axis.title.y = element_text(size=14,angle=90,vjust=0.5),
    axis.text.x = element_text(size=12,angle=0, color = 'black'),
    axis.text.y = element_text(size=12,angle=0, color = 'black')
  )


s1000p0001<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS1000pA0001.csv')
s500p0001<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS500pA0001.csv')
s100p0001<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS100pA0001.csv')
s50p0001<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS50pA0001.csv')
s10p0001<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS10pA0001.csv')

s1000p001<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS1000pA001.csv')
s500p001<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS500pA001.csv')
s100p001<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS100pA001.csv')
s50p001<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS50pA001.csv')
s10p001<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS10pA001.csv')

s1000p01<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS1000pA01.csv')
s500p01<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS500pA01.csv')
s100p01<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS100pA01.csv')
s50p01<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS50pA01.csv')
s10p01<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS10pA01.csv')




eSFS <- rbind( s1000p0001,s500p0001,s100p0001,s50p0001,s10p0001,s1000p001,s500p001,s100p001,s50p001,s10p001,s1000p01,s500p01,s100p01,s50p01,s10p01)
eSFS$prod <- eSFS$pA*eSFS$S

eSFS$pA<- factor(eSFS$pA, levels =  levels(as.factor(eSFS$pA)), labels =  c(expression(italic(p[a])*' = 0.0001'), expression(italic(p[a])*' = 0.001'),expression(italic(p[a])*' = 0.01')))
#eSFS$pA<- factor(eSFS$pA, levels =  levels(as.factor(eSFS$pA)), labels =  c('p_a = 0.0001','p_a = 0.001','p_a = 0.01'))

library(ggplot2)

ggplot(data = eSFS, aes(x = i, y = SFS_i*14000000, col = as.factor(S)))+
  geom_line()+
  facet_grid(as.factor(pA)~., scales = 'free_y', labeller = label_parsed)+
  scale_y_log10('Expected Number of Segregating Sites')+
  scale_x_continuous('Derived Allele Count', breaks = seq(1, 39, 2))+
  scale_color_colorblind(expression(gamma[a]))+
  TommyTheme+
  theme(legend.text = element_text(size =13),
        strip.text.y = element_text(size =13, face = 'bold'),
        legend.title = element_text(size =17, face = 'bold'))
