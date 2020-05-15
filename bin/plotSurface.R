rm(list=ls())

######################################################################

library(ggplot2)
library(ggpubr)
library(grid)

TommyTheme<-  theme_bw()+
  theme(
    axis.text.y =  element_text(size = 10, color = 'black'),
    axis.text.x =  element_text(size = 10, color = 'black'),
    legend.text = element_text(size = 10, color = 'black'),
    axis.title.x = element_text(size = 15, color = 'black'),
    axis.title.y = element_text(size = 15,  vjust = 0.8, hjust = 0.5, color = 'black'),
    strip.text = element_text(size = 15, color = 'black'),
    panel.grid = element_blank(),         # All grid lines
    panel.grid.major = element_blank(),   # Major grid lines
    panel.grid.minor = element_blank(),  # Minor grid lines
    plot.margin=grid::unit(c(0,0,0,0), "mm"),
    panel.spacing = unit(2, "lines"),
    plot.title = element_text(hjust = 0.5))
    
stripper <- theme(
  strip.background = element_blank(),
  strip.text.y = element_blank(),
  strip.text.x = element_blank()
)

######################################################################

Sb <- seq(0.1,10000)
prod <- rep(0.1, length(Sb))
pA<- prod/Sb
line<-data.frame(Sb = Sb, pA = pA)

######################################################################

gridWith<-na.omit(read.csv('work/uSFS_positiveSelection/simulations/surface/analysis/Nes1000_pA0.0001.surface.B.csv'))
truth1000 <- gridWith[1,]
hitsWith <- gridWith[log10(gridWith$delt_lnL) == -Inf ,]
gridWith$divergence <- 'With Divergence'
hitsWith$divergence <- 'With Divergence'

gridWithout<-na.omit(read.csv('work/uSFS_positiveSelection/simulations/surface/analysis/Nes1000_pA0.0001.surface.B.wOut.csv'))
hitsWithout <- gridWithout[log10(gridWithout$delt_lnL) == -Inf ,]
gridWithout$divergence <- 'Without Divergence'
hitsWithout$divergence <- 'Without Divergence'

grid_Nes1000 <- rbind(gridWith, gridWithout)
grid_Nes1000 <- grid_Nes1000[log10(grid_Nes1000$delt_lnL)!=-Inf,]
hits_Nes1000 <- rbind(hitsWith, hitsWithout)

grid_Nes1000$params <- 'Nes1000'
hits_Nes1000$params <- 'Nes1000'


                           
Nes1000 <- ggplot(data = grid_Nes1000, aes(x = pa_est, y = Sb_est, col = log10(delt_lnL)))+
  geom_point(shape = 15,size=3)+
  geom_line(data = line, aes(x = pA, y = Sb), col = '#46ACC8', lwd = 1, lty = 2)+
  geom_point(data = truth1000, aes( x = pA, y = Nes), shape = 3,size=5, col= 'white')+
  geom_point(data = hits_Nes1000, aes( x = pa_est, y = Sb_est), shape = 15,size=3, col= 'red')+
  scale_x_continuous('', expand = c(0, 0), limits = c(0, max(grid_Nes1000$pa_est)))+
  scale_y_continuous(expression(italic(gamma[a])), expand = c(0, 0), limits = c(0, 5000) )+
  scale_colour_gradient(expression(log[10]*'('*Delta*italic(lnL)*')'),  low = "black", high = "white")+
  ggtitle(expression(italic(gamma[a])*'= 1000 ; '*italic(p[a])*' = 0.0001'))+
  facet_grid(divergence~ ., scales = 'free')+
  TommyTheme+
  stripper

Nes1000

######################################################################
######################################################################


gridWith<-na.omit(read.csv('work/uSFS_positiveSelection/simulations/surface/analysis/Nes100_pA0.001.surface.B.csv'))
truth100 <- gridWith[1,]
hitsWith <- gridWith[log10(gridWith$delt_lnL) == -Inf ,]
gridWith$divergence <- 'With Divergence'
hitsWith$divergence <- 'With Divergence'

gridWithout<-na.omit(read.csv('work/uSFS_positiveSelection/simulations/surface/analysis/Nes100_pA0.001.surface.B.wOut.csv'))
hitsWithout <- gridWithout[log10(gridWithout$delt_lnL) == -Inf ,]
gridWithout$divergence <- 'Without Divergence'
hitsWithout$divergence <- 'Without Divergence'



grid_Nes100 <- rbind(gridWith, gridWithout)
summary(as.factor(grid_Nes100$pa_est))

grid_Nes100 <- grid_Nes100[log10(grid_Nes100$delt_lnL)!=-Inf,]
hits_Nes100 <- rbind(hitsWith, hitsWithout)

grid_Nes100$params <- 'Nes100'
hits_Nes100$params <- 'Nes100'
max(grid_Nes100$Sb_est)

Nes100 <- ggplot(data = grid_Nes100, aes(x = pa_est, y = Sb_est, col = log10(delt_lnL)))+
  geom_point(shape = 15,size=3)+
  geom_line(data = line, aes(x = pA, y = Sb), col = '#46ACC8', lwd = 1, lty = 2)+
  geom_point(data = truth100, aes( x = pA, y = Nes), shape = 3,size=5, col= 'white')+
  geom_point(data = hits_Nes100, aes( x = pa_est, y = Sb_est), shape = 15,size=3, col= 'red')+
  scale_x_continuous(expression(italic(p[a])), expand = c(0, 0), limits = c(0, max(grid_Nes100$pa_est)))+
  scale_y_continuous('', expand = c(0, 0), limits = c(0, 500) )+
  scale_colour_gradient(expression(log[10]*'('*Delta*italic(lnL)*')'),  low = "black", high = "white")+
  ggtitle(expression(italic(gamma[a])*'= 100 ; '*italic(p[a])*' = 0.001'))+
  facet_grid(divergence~ ., scales = 'free')+
  TommyTheme+
  stripper
Nes100

######################################################################
######################################################################




gridWith<-na.omit(read.csv('work/uSFS_positiveSelection/simulations/surface/analysis/Nes10_pA0.01.surface.B.csv'))
truth10 <- gridWith[1,]
hitsWith <- gridWith[log10(gridWith$delt_lnL) == -Inf ,]
gridWith$divergence <- 'With Divergence'
hitsWith$divergence <- 'With Divergence'

gridWithout<-na.omit(read.csv('work/uSFS_positiveSelection/simulations/surface/analysis/Nes10_pA0.01.surface.B.wOut.csv'))
hitsWithout <- gridWithout[log10(gridWithout$delt_lnL) == -Inf ,]
gridWithout$divergence <- 'Without Divergence'
hitsWithout$divergence <- 'Without Divergence'



grid_Nes10 <- rbind(gridWith, gridWithout)
grid_Nes10 <- grid_Nes10[log10(grid_Nes10$delt_lnL)!=-Inf,]
hits_Nes10 <- rbind(hitsWith, hitsWithout)
grid_Nes10$params <- 'Nes10'
hits_Nes10$params <- 'Nes10'


Nes10 <- ggplot(data = grid_Nes10, aes(x = pa_est, y = Sb_est, col = log10(delt_lnL)))+
  geom_point(shape = 15,size=3)+
  geom_line(data = line, aes(x = pA, y = Sb), col = '#46ACC8', lwd = 1, lty = 2)+
  geom_point(data = truth10, aes( x = pA, y = Nes), shape = 3,size=5, col= 'white')+
  geom_point(data = hits_Nes10, aes( x = pa_est, y = Sb_est), shape = 15,size=3, col= 'red')+  scale_x_continuous('', expand = c(0, 0), limits = c(0, max(grid_Nes10$pa_est)))+
  scale_y_continuous('', expand = c(0, 0), limits = c(0, 50) )+
  scale_colour_gradient(expression(log[10]*'('*Delta*italic(lnL)*')'),  low = "black", high = "white")+
  ggtitle(expression(italic(gamma[a])*'= 10 ; '*italic(p[a])*' = 0.01'))+
  facet_grid(divergence~ ., scales = 'free')+
  TommyTheme

######################################################################
######################################################################


surface <-ggarrange(Nes1000,Nes100, Nes10, common.legend = TRUE, labels = 'AUTO', legend = 'bottom', ncol = 3, nrow = 1)
surface

pdf('~/work/uSFS_positiveSelection/Plots/surfacePlot.pdf', width = 11, height =6)
print(surface)
dev.off()

tiff('~/work/uSFS_positiveSelection/Plots/surfacePlot.tiff', width = 11, height =6, res = 300, units = "in")
print(surface)
dev.off()
