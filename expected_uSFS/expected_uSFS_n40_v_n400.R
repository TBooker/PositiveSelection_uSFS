rm(list = ls())

## Plot the expected uSFS for 400 haploid copies
options(scipen=999)
library(ggplot2)
library(wesanderson)
library(scales)
library(ggthemes)

TommyTheme <-theme_bw()+
  theme(
    axis.title.x = element_text(size=14,angle=0),
    axis.title.y = element_text(size=14,angle=90,vjust=0.5),
    axis.text.x = element_text(size=12,angle=0, color = 'black'),
    axis.text.y = element_text(size=12,angle=0, color = 'black'),
    strip.text.y = element_text(size=12, color = 'black')
  )


n400_s1000p0001<-read.csv('~/UBC/uSFS_study/expected_uSFS/n400_SFS1000pA0001.csv')
n400_s500p0001<-read.csv('~/UBC/uSFS_study/expected_uSFS/n400_SFS500pA0001.csv')
n400_s100p0001<-read.csv('~/UBC/uSFS_study/expected_uSFS/n400_SFS100pA0001.csv')
n400_s50p0001<-read.csv('~/UBC/uSFS_study/expected_uSFS/n400_SFS50pA0001.csv')
n400_s10p0001<-read.csv('~/UBC/uSFS_study/expected_uSFS/n400_SFS10pA0001.csv')
n400_s0p0001<-read.csv('~/UBC/uSFS_study/expected_uSFS/n400_SFS0pA0001.csv')

n400_s1000p001<-read.csv('~/UBC/uSFS_study/expected_uSFS/n400_SFS1000pA001.csv')
n400_s500p001<-read.csv('~/UBC/uSFS_study/expected_uSFS/n400_SFS500pA001.csv')
n400_s100p001<-read.csv('~/UBC/uSFS_study/expected_uSFS/n400_SFS100pA001.csv')
n400_s50p001<-read.csv('~/UBC/uSFS_study/expected_uSFS/n400_SFS50pA001.csv')
n400_s10p001<-read.csv('~/UBC/uSFS_study/expected_uSFS/n400_SFS10pA001.csv')
n400_s0p001<-read.csv('~/UBC/uSFS_study/expected_uSFS/n400_SFS0pA001.csv')

n400_s1000p01<-read.csv('~/UBC/uSFS_study/expected_uSFS/n400_SFS1000pA01.csv')
n400_s500p01<-read.csv('~/UBC/uSFS_study/expected_uSFS/n400_SFS500pA01.csv')
n400_s100p01<-read.csv('~/UBC/uSFS_study/expected_uSFS/n400_SFS100pA01.csv')
n400_s50p01<-read.csv('~/UBC/uSFS_study/expected_uSFS/n400_SFS50pA01.csv')
n400_s10p01<-read.csv('~/UBC/uSFS_study/expected_uSFS/n400_SFS10pA01.csv')
n400_s0p01<-read.csv('~/UBC/uSFS_study/expected_uSFS/n400_SFS0pA01.csv')


n400_eSFS <- rbind( n400_s1000p0001, n400_s500p0001, n400_s100p0001, n400_s50p0001, n400_s10p0001, n400_s0p0001, n400_s1000p001, n400_s500p001, n400_s100p001, n400_s50p001, n400_s10p001,n400_s0p001,n400_s1000p01,n400_s500p01,n400_s100p01,n400_s50p01,n400_s10p01, n400_s0p01)
n400_eSFS$pA<- factor(n400_eSFS$pA, levels =  levels(as.factor(n400_eSFS$pA)), labels =  c(expression(italic(p[a])*' = 0.0001'), expression(italic(p[a])*' = 0.001'),expression(italic(p[a])*' = 0.01')))

n400_e_SFS_plot = ggplot(data = n400_eSFS, aes(x = i, y = SFS_i*14000000, col = as.factor(S)))+
  geom_line()+
  facet_grid(as.factor(pA)~., scales = 'free_y', labeller = label_parsed)+
  scale_y_log10('Expected Number of Segregating Sites')+
  scale_x_continuous('Derived Allele Count', breaks = c(1, 100, 200, 300, 399))+
  scale_color_colorblind(expression(gamma[a]))+
  TommyTheme+
  theme(legend.text = element_text(size =13),
        axis.title.y = element_blank(),
                strip.text.y = element_text(size =13, face = 'bold'),
        legend.title = element_text(size =17, face = 'bold'),
        strip.background.y =  element_blank(),
        legend.position="bottom")


s1000p0001<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS1000pA0001.csv')
s500p0001<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS500pA0001.csv')
s100p0001<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS100pA0001.csv')
s50p0001<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS50pA0001.csv')
s10p0001<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS10pA0001.csv')
s0p0001<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS0pA0001.csv')

s1000p001<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS1000pA001.csv')
s500p001<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS500pA001.csv')
s100p001<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS100pA001.csv')
s50p001<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS50pA001.csv')
s10p001<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS10pA001.csv')
s0p001<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS0pA001.csv')

s1000p01<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS1000pA01.csv')
s500p01<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS500pA01.csv')
s100p01<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS100pA01.csv')
s50p01<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS50pA01.csv')
s10p01<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS10pA01.csv')
s0p01<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS0pA01.csv')

n40_eSFS <- rbind( s1000p0001,s500p0001,s100p0001,s50p0001,s10p0001,s0p0001,s1000p001,s500p001,s100p001,s50p001,s10p001,s0p001,s1000p01,s500p01,s100p01,s50p01,s10p01, s0p01)
n40_eSFS$pA<- factor(n40_eSFS$pA, levels =  levels(as.factor(n40_eSFS$pA)), labels =  c(expression(italic(p[a])*' = 0.0001'), expression(italic(p[a])*' = 0.001'),expression(italic(p[a])*' = 0.01')))

n40_e_SFS_plot = ggplot(data = n40_eSFS, aes(x = i, y = SFS_i*14000000, col = as.factor(S)))+
  geom_line()+
  facet_grid(as.factor(pA)~., scales = 'free_y', labeller = label_parsed)+
  scale_y_log10('Expected Number of Segregating Sites')+
  scale_x_continuous('Derived Allele Count', breaks = c(1, 10, 20, 30, 39))+
  scale_color_colorblind(expression(gamma[a]))+
  TommyTheme+
  theme(legend.text = element_text(size =13),
        strip.text.y = element_text(size =13, face = 'bold'),
        legend.title = element_text(size =17, face = 'bold'),
        strip.background.y =  element_blank(),
        legend.position="bottom")

#e_SFS_plot
library(ggpubr)
combined_Figure<- ggarrange(n40_e_SFS_plot, n400_e_SFS_plot, ncol = 2, nrow = 1, labels = 'AUTO', common.legend = T , legend = 'bottom') 

pdf('~/UBC/uSFS_study/expected_uSFS/suppSfsPlot_n40_n400.pdf')
print( combined_Figure )
dev.off()

## TIFF for upload to the G3 website
tiff('~/UBC/uSFS_study/Plots/FigureS3.tiff', res = 300, units = "in", width = 10, height = 12)
print( combined_Figure )
dev.off()
