rm(list = ls())

library(ggplot2)
library(wesanderson)
library(scales)

TommyTheme <-theme_bw()+
  theme(
    axis.title.x = element_text(size=14,angle=0),
    axis.title.y = element_text(size=14,angle=90,vjust=0.5),
    axis.text.x = element_text(size=12,angle=0, color = 'black'),
    axis.text.y = element_text(size=12,angle=0, color = 'black'),
    strip.text.y = element_text(size=12, color = 'black')
  )


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


eSFS <- rbind( s1000p0001,s500p0001,s100p0001,s50p0001,s10p0001,s0p0001,s1000p001,s500p001,s100p001,s50p001,s10p001,s0p001,s1000p01,s500p01,s100p01,s50p01,s10p01, s0p01)
eSFS$prod <- eSFS$pA*eSFS$S


#s1000<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS1000.csv')
#s500<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS500.csv')
#s100<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS100.csv')
#s10<-read.csv('~/UBC/uSFS_study/expected_uSFS/SFS10.csv')

o1000 <-read.csv('~/UBC/uSFS_study/expected_uSFS/Nes1000.SFS.csv')
o1000 <-o1000[o1000$class == 'advantageus',]
o1000$S<- 1000
o1000$pA<- 0.0001

o100 <-read.csv('~/UBC/uSFS_study/expected_uSFS/Nes100.SFS.csv')
o100 <-o100[o100$class == 'advantageus',]
o100$S<- 100
o100$pA<- 0.001

o10 <-read.csv('~/UBC/uSFS_study/expected_uSFS/Nes10.SFS.csv')
o10 <-o10[o10$class == 'advantageus',]
o10$S<- 10
o10$pA<- 0.01


#e_sfs<- rbind(s1000,s100,s10)
o_sfs<- rbind(o1000,o100,o10)
o_sfs$S <-as.integer(o_sfs$S)

e_sfs$S <- factor(e_sfs$S, levels = levels(as.factor(e_sfs$S)), labels = c(expression(italic(gamma[a])*' = 10 '*italic(p[a])*' = 0.01'),expression(italic(gamma[a])*' = 100 '*italic(p[a])*' = 0.001'),expression(italic(gamma[a])*' = 1000 '*italic(p[a])*' = 0.0001')) )
o_sfs$S <- factor(o_sfs$S, levels = c("10","50","100","500","1000"))
#o_sfs$S <- factor(o_sfs$S, levels = levels(as.factor(o_sfs$S)), labels = c(expression(italic(gamma[a])*' = 10 '*italic(p[a])*' = 0.01'),expression(italic(gamma[a])*' = 100 '*italic(p[a])*' = 0.001'),expression(italic(gamma[a])*' = 1000 '*italic(p[a])*' = 0.0001')) )
#e_sfs$S <- factor(e_sfs$S, levels = levels(as.factor(e_sfs$S)), labels = c(expression(italic(gamma[a])*' = 10 '*italic(p[a])*' = 0.01'),expression(italic(gamma[a])*' = 100 '*italic(p[a])*' = 0.001'),expression(italic(gamma[a])*' = 1000 '*italic(p[a])*' = 0.0001')) )


eSFS$pA<- factor(eSFS$pA, levels =  levels(as.factor(eSFS$pA)), labels =  c(expression(italic(p[a])*' = 0.0001'), expression(italic(p[a])*' = 0.001'),expression(italic(p[a])*' = 0.01')))
o_sfs$pA<- factor(o_sfs$pA, levels =  levels(as.factor(o_sfs$pA)), labels =  c(expression(italic(p[a])*' = 0.0001'), expression(italic(p[a])*' = 0.001'),expression(italic(p[a])*' = 0.01')))

eSFS <- eSFS[order(eSFS$S),]
o_sfs <- o_sfs[order(o_sfs$S),]
as.factor(eSFS$S)

sfsPlotExp <- ggplot(data = o_sfs, aes(x = alleles, y = count, fill = as.factor(S), col = as.factor(S)))+
  geom_blank(data =eSFS, aes(x = i, y = SFS_i*14000000, col = as.factor(S), fill = as.factor(S)))+
  geom_bar(stat = 'identity', width = 0.75, alpha = 0.4)+
  geom_line(data =eSFS, aes(x = i, y = SFS_i*14000000, col = as.factor(S)), lwd = 1.4)+
  scale_x_continuous('Derived Allele Count', breaks = c(1, 10, 20, 30, 39))+
  scale_y_continuous('Number of Segregating Sites') + 
  #scale_y_log10('Number of Segregating Sites')+
  facet_grid(pA~., scales = 'free_y',labeller = label_parsed)+
  scale_color_colorblind(expression(gamma[a]))+
  scale_fill_colorblind(expression(gamma[a]))+
  TommyTheme+
  theme(legend.title = element_text(size =16),
        legend.text = element_text(size =13),
        legend.position="right")


  


# ggplot(data = o_sfs, aes(x = alleles, y = count, fill = S))+
#   geom_bar(stat = 'identity', width = 0.75)+
#   geom_line(data =e_sfs, aes(x = i, y = SFS_i*14000000, col = as.factor(S)),lwd = 2, alpha = 0.75)+
#   scale_y_log10('Number of Segregating Sites')+
#   scale_x_continuous('Derived Allele Count', breaks = seq(1, 39, 2))+
# #  scale_color_manual(values = pal, labels = parse_format())+
# #  scale_fill_manual(values = pal, labels = parse_format())+
#   facet_grid(S~., scales = 'free_y')+
#   guides(color = F)+
#   TommyTheme+
#   theme(legend.text = element_text(size =13),
#   strip.text.y = element_blank(),
#   strip.background.y =  element_blank(),
#   legend.position="bottom")



# pdf('~/UBC/uSFS_study/expected_uSFS/sfsPlot.pdf', width = 10, height = 12)
# print(sfsPlot)
# dev.off()

pdf('~/UBC/uSFS_study/Plots/Figure2.pdf', width = 10, height = 10)
print(sfsPlotExp)
dev.off()

tiff('~/UBC/uSFS_study/Plots/Figure2.tiff', units = "in", width = 10, height = 10, res = 300)
print(sfsPlotExp)
dev.off()

dsfs <-read.csv('~/UBC/uSFS_study/expected_uSFS/Nes1000_pA0.0001_vanilla_uSFS.csv')
dsfs <-dsfs[dsfs$class == 'deleterious',]


dsfsPlot<- ggplot(data = dsfs, aes(x = alleles, y = count))+
  geom_bar(stat = 'identity', width = 0.75)+
  scale_y_log10('Expected number of segregating sites')+
  scale_x_continuous('Derived Allele Count', limits = c(1,39))+
#  scale_color_manual(values = pal, labels = parse_format())+
#  scale_fill_manual(values = pal, labels = parse_format())+
#  facet_grid(S~., scales = 'free_y')+
  guides(color = F)+
  TommyTheme


b10 <-read.csv('~/UBC/uSFS_study/expected_uSFS/Nes10_pA0.01_vanilla_uSFS.csv')
b10 <-b10[b10$class != 'neutral',]
b10$S<- "10"


b1000 <-read.csv('~/UBC/uSFS_study/expected_uSFS/Nes1000.SFS.csv')
b1000 <-b1000[b1000$class != 'neutral',]
b1000$S<- "1000"

b100 <-read.csv('~/UBC/uSFS_study/expected_uSFS/Nes100.SFS.csv')
b100 <-b100[b100$class != 'neutral',]
b100$S<- "100"

b10 <-read.csv('~/UBC/uSFS_study/expected_uSFS/Nes10.SFS.csv')
b10 <-b10[b10$class != 'neutral',]
b10$S<- "10"

sfs = rbind(b10, b100, b1000)
sfs$S <- factor(sfs$S, levels = levels(as.factor(sfs$S)), labels = c(expression(italic(gamma[a])*' = 10; '*italic(p[a])*' = 0.01'),expression(italic(gamma[a])*' = 100; '*italic(p[a])*' = 0.001'),expression(italic(gamma[a])*' = 1000; '*italic(p[a])*' = 0.0001')) )
sfs$class <- factor(sfs$class, levels = levels(as.factor(sfs$class)), labels = c(expression('Advantageous'), expression('Deleterious'),expression('Neutral'))) 

pal = c("#0072B2", "#D55E00")

fullSFS <- ggplot(data = sfs, aes(x = as.factor(alleles), y = count+1, fill = class))+
  geom_bar(stat = 'identity', width = 0.75, position = 'dodge')+
  scale_y_log10('Number of Segregating Sites +1')+
  scale_x_discrete('Derived Allele Count')+
  scale_color_manual('',values = pal, labels = parse_format())+
  scale_fill_manual('',values = pal, labels = parse_format())+
  facet_grid(S~., scales = 'free_y', labeller = label_parsed)+
  guides(color = F)+
  TommyTheme+
  theme(legend.text = element_text(size =13, hjust = 0),
        strip.text.y = element_text(size =13, face = 'bold'))

pdf('~/UBC/uSFS_study/Plots/suppSfsPlot.pdf', width = 15, height = 12)
print(fullSFS)
dev.off()

## TIFF for upload to the G3 website
tiff('~/UBC/uSFS_study/Plots/FigureS1.tiff', res = 300, units = "in", width = 12, height = 12)
print( fullSFS )
dev.off()


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




eSFS <- rbind( s1000p0001,s500p0001,s100p0001,s50p0001,s10p0001,s0p0001,s1000p001,s500p001,s100p001,s50p001,s10p001,s0p001,s1000p01,s500p01,s100p01,s50p01,s10p01,s0p01)
eSFS$prod <- eSFS$pA*eSFS$S

eSFS$pA<- factor(eSFS$pA, levels =  levels(as.factor(eSFS$pA)), labels =  c(expression(italic(p[a])*' = 0.0001'), expression(italic(p[a])*' = 0.001'),expression(italic(p[a])*' = 0.01')))
#eSFS$pA<- factor(eSFS$pA, levels =  levels(as.factor(eSFS$pA)), labels =  c('p_a = 0.0001','p_a = 0.001','p_a = 0.01'))

library(ggplot2)

e_SFS_plot = ggplot(data = eSFS, aes(x = i, y = SFS_i*14000000, col = as.factor(S)))+
  geom_line()+
  facet_grid(as.factor(pA)~., scales = 'free_y', labeller = label_parsed)+
  scale_y_log10('Expected Number of Segregating Sites')+
  scale_x_continuous('Derived Allele Count', breaks = seq(1, 39, 2))+
  scale_color_colorblind(expression(gamma[a]))+
  TommyTheme+
  theme(legend.text = element_text(size =13),
        strip.text.y = element_text(size =13, face = 'bold'),
        legend.title = element_text(size =17, face = 'bold'),
              strip.background.y =  element_blank(),
              legend.position="bottom")
        

library(ggpubr)

ggarrange(sfsPlot,e_SFS_plot, ncol = 2, nrow = 1, labels = 'AUTO' )
