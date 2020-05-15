## An R script for getting the model averaged estiamtes of p_a and Nesa from polyDFE runs
rm(list = ls())
## You need to stop R from using scientific notation
options("scipen"=100, "digits"= 4)

## Read in Paula Tataru's R package for PolyDFE processing
source("~/bin/polyDFE-master/postprocessing.R")
rep = seq(1, 100)
Nes = c("10", "50", "100", "500", "1000")
pA = c("0.01", "0.001", "0.0001")
combinations <- expand.grid( list( rep, Nes, pA ) )
names(combinations) <- c("rep", "Nes", "pA")

constantPath = "~/work/uSFS_positiveSelection/simulations/fixedEffect_N10000/polyDFE_runs_n20/"

output <- combinations
output$nDiv_alpha_div <- 0 # 4
output$nDiv_alpha_dfe <- 0 # 5
output$nDiv_p_b <- 0 # 6
output$nDiv_S_b <- 0 # 7

output$wDiv_alpha_div <-0 # 8
output$wDiv_alpha_dfe <- 0 # 9
output$wDiv_p_b <- 0 # 10
output$wDiv_S_b <- 0 # 11

for (i in seq(1, nrow(combinations))){
  row =combinations[i, ] 
  nDiv_est = c( 
    parseOutput(paste(constantPath, "Nes", row$Nes, "_pA", row$pA,"_n20_polyDFE/", row$rep,".polyDFE_T1.nDiv.Be.output", sep = '')),
    parseOutput(paste(constantPath, "Nes", row$Nes, "_pA", row$pA,"_n20_polyDFE/", row$rep,".polyDFE_T1.nDiv.dDFE.B.output", sep = ''))
  )
  wDiv_est = c( 
    parseOutput(paste(constantPath, "Nes", row$Nes, "_pA", row$pA,"_n20_polyDFE/", row$rep,".polyDFE_T1.wDiv.Be.output", sep = '')),
    parseOutput(paste(constantPath, "Nes", row$Nes, "_pA", row$pA,"_n20_polyDFE/", row$rep,".polyDFE_T1.wDiv.dDFE.B.output", sep = ''))
  )
  
  nDiv_aic = getAICweights( nDiv_est )
  
  nDiv_alpha_div = sum( sapply(1:length(nDiv_est), function(i) nDiv_aic[i, "weight"] * nDiv_est[[i]]$alpha[[1]]["alpha_div"]))
  output$nDiv_alpha_div[i] =   nDiv_alpha_div

  nDiv_alpha_dfe = sum( sapply(1:length(nDiv_est), function(i) nDiv_aic[i, "weight"] * nDiv_est[[i]]$alpha[[1]]["alpha_dfe"]))
  output$nDiv_alpha_dfe[i] =   nDiv_alpha_dfe

  nDiv_p_b = sum( sapply(1:length(nDiv_est), function(i) nDiv_aic[i, "weight"] * nDiv_est[[i]]$values[[1]]["p_b"]))
  output$nDiv_p_b[i] =   nDiv_p_b
  
  nDiv_S_b = sum( sapply(1:length(nDiv_est), function(i) nDiv_aic[i, "weight"] * nDiv_est[[i]]$values[[1]]["S_b"]))
  output$nDiv_S_b[i] =   nDiv_S_b
  
  
  
  wDiv_aic = getAICweights( wDiv_est )
  
  wDiv_alpha_div = sum( sapply(1:length(wDiv_est), function(i) wDiv_aic[i, "weight"] * wDiv_est[[i]]$alpha[[1]]["alpha_div"]))
  output$wDiv_alpha_div[i] =   wDiv_alpha_div

  wDiv_alpha_dfe = sum( sapply(1:length(wDiv_est), function(i) wDiv_aic[i, "weight"] * wDiv_est[[i]]$alpha[[1]]["alpha_dfe"]))
  output$wDiv_alpha_dfe[i] =   wDiv_alpha_dfe

  wDiv_p_b = sum( sapply(1:length(wDiv_est), function(i) wDiv_aic[i, "weight"] * wDiv_est[[i]]$values[[1]]["p_b"]))
  output$wDiv_p_b[i] =   wDiv_p_b
    
  wDiv_S_b = sum( sapply(1:length(wDiv_est), function(i) wDiv_aic[i, "weight"] * wDiv_est[[i]]$values[[1]]["S_b"]))
  output$wDiv_S_b[i] =   wDiv_S_b
  
  }

write.csv(output, '~/work/uSFS_positiveSelection/simulations/fixedEffect_N10000/modelAverages_polyDFE_runs_n20.csv')

rm(list = ls())

options(scipen=999)

library(ggplot2)
library(wesanderson)
library(ggpubr)
library(reshape2)

pal <-wes_palette("Cavalcanti1", 3)

TommyTheme <-theme_bw()+
  theme(
    axis.title.x = element_text(size=20,angle=0),
    axis.title.y = element_text(size=20,angle=90,vjust=0.5),
    axis.text.x = element_text(size=12,angle=0, color = 'black'),
    axis.text.y = element_text(size=12,angle=0, color = 'black'),
    legend.title = element_text(size =15),
    legend.text = element_text(size =13),
    strip.text.x = element_text(size = 15),
    strip.text.y = element_text(size = 20),
    plot.title = element_text(size=20,hjust=0.5)
  )

stripper <- theme(
  strip.background = element_blank(),
  strip.text.x = element_blank(),
  strip.text.y = element_blank()
)
### Let's make some plots of the results from the uSFS analysis
options("scipen"=10, "digits"= 2)

### First read in the raw data...

van <- read.csv('~/work/uSFS_positiveSelection/simulations/fixedEffect_N10000/all.vanilla.summary.csv')

van1 <- van[van$Time == 'T1',]
van2 <- van[van$Time == 'T2',]

modelAverages <- read.csv("~/work/uSFS_positiveSelection/simulations/fixedEffect_N10000/modelAverages_polyDFE_runs_n20.csv")
modelAverages$params <- paste(modelAverages$Nes,modelAverages$pA , sep = ' ')
pd = position_dodge(0.5)

nDiv_S_b_median <- tapply(modelAverages$nDiv_S_b, modelAverages$params, median)
wDiv_S_b_median <- tapply(modelAverages$wDiv_S_b, modelAverages$params, median)

nDiv_p_b_median <- tapply(modelAverages$nDiv_p_b, modelAverages$params, median)
wDiv_p_b_median <- tapply(modelAverages$wDiv_p_b, modelAverages$params, median)

nDiv_alpha_div_median <- tapply(modelAverages$nDiv_alpha_div, modelAverages$params, median)
wDiv_alpha_div_median <- tapply(modelAverages$wDiv_alpha_div, modelAverages$params, median)

nDiv_alpha_dfe_median <- tapply(modelAverages$nDiv_alpha_dfe, modelAverages$params, median)
wDiv_alpha_dfe_median <- tapply(modelAverages$wDiv_alpha_dfe, modelAverages$params, median)

params =  data.frame( do.call( rbind, strsplit( names( wDiv_alpha_dfe_median ), ' ' )) )
names( params ) = c("Nes","pA")

summaryTable <-data.frame( nDiv_S_b = nDiv_S_b_median,
                           wDiv_S_b = wDiv_S_b_median,
                           nDiv_p_b = nDiv_p_b_median,
                           wDiv_p_b = wDiv_p_b_median,
                           nDiv_S_b = nDiv_alpha_div_median,
                           wDiv_S_b = wDiv_alpha_div_median,
                           nDiv_alpha_dfe = nDiv_alpha_dfe_median,
                           wDiv_alpha_dfe = wDiv_alpha_dfe_median,
                           Nes = params$Nes,
                           pA = params$pA,
                           params = names(wDiv_alpha_dfe_median))


nDiv_S_b <- ggplot()+
  geom_violin( data = modelAverages , aes(x = as.factor(abs(Nes)), y = nDiv_S_b, col = as.factor(pA), fill = as.factor(pA)), position = pd, alpha = 0.5)+
  geom_line(data = summaryTable, aes( x = Nes, y = nDiv_S_b, col = as.factor(pA), group = pA), position = pd)+
  geom_point(data = summaryTable, aes( x = Nes, y = nDiv_S_b, col = as.factor(pA), group = pA), position = pd)+
  scale_y_log10(expression(hat(italic(gamma[a]))))+
  scale_color_manual(expression(italic(p[a])), values = pal)+
  scale_fill_manual(expression(italic(p[a])), values = pal)+
  scale_x_discrete(expression(italic(gamma[a])))+
  ggtitle('Without Divergence')+
  TommyTheme

wDiv_S_b <- ggplot()+
  geom_violin( data = modelAverages , aes(x = as.factor(abs(Nes)), y = wDiv_S_b, col = as.factor(pA), fill = as.factor(pA)), position = pd, alpha = 0.5)+
  geom_line(data = summaryTable, aes( x = Nes, y = wDiv_S_b, col = as.factor(pA), group = pA), position = pd)+
  geom_point(data = summaryTable, aes( x = Nes, y = wDiv_S_b, col = as.factor(pA), group = pA), position = pd)+
  scale_y_log10(expression(hat(italic(gamma[a]))), limits = c(0.001,100))+
  scale_color_manual(expression(italic(p[a])), values = pal)+
  scale_fill_manual(expression(italic(p[a])), values = pal)+
  scale_x_discrete(expression(italic(gamma[a])))+
  ggtitle('With Divergence')+
  TommyTheme


doge <- position_dodge(1)
cBpal <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

nDiv_pA<- ggplot(data = modelAverages , aes(x = as.factor(abs(pA)), y = nDiv_p_b, col = as.factor(Nes), fill = as.factor(Nes), group = as.factor(params)))+
  geom_violin(position = pd, alpha = 0.5)+
  geom_point(data = summaryTable, aes( x = pA, y = nDiv_p_b, col = as.factor(Nes)), position = pd)+
  #  geom_errorbar(aes(ymax = upper, ymin = lower), position = position_dodge(0.5),stat ='identity', width = 0)+
  scale_y_log10(expression(hat(italic(p[a]))), limits = c(0.00001,.5), breaks = c(0.00001,0.0001,0.001,0.01,0.1))+
  scale_color_manual(expression(italic(gamma[a])), values = cBpal)+
  scale_fill_manual(expression(italic(gamma[a])), values = cBpal)+
  geom_errorbar(aes(ymin = pA, ymax = pA), col = 'grey', lty = 2) + 
  ggtitle('Without Divergence')+
  scale_x_discrete(expression(italic(p[a])))+
  TommyTheme

wDiv_pA<- ggplot(data = modelAverages , aes(x = as.factor(abs(pA)), y = wDiv_p_b, col = as.factor(Nes), fill = as.factor(Nes), group = as.factor(params)))+
  geom_violin(position = pd, alpha = 0.5)+
  geom_point(data = summaryTable, aes( x = pA, y = wDiv_p_b, col = Nes), position = pd)+
  #  geom_errorbar(aes(ymax = upper, ymin = lower), position = position_dodge(0.5),stat ='identity', width = 0)+
  scale_y_log10(expression(hat(italic(p[a]))), limits = c(0.00001,.5), breaks = c(0.00001,0.0001,0.001,0.01,0.1))+
  scale_color_manual(expression(italic(gamma[a])), values = cBpal)+
  scale_fill_manual(expression(italic(gamma[a])), values = cBpal)+
  ggtitle('With Divergence')+
  geom_errorbar(aes(ymin = pA, ymax = pA), col = 'grey', lty = 2) + 
  scale_x_discrete(expression(italic(p[a])))+
  TommyTheme


nDiv_A_div<-ggplot(data = modelAverages , aes(x = as.factor(abs(Nes)), y = nDiv_alpha_dfe, col = as.factor(pA), fill = as.factor(pA), group = params))+
  geom_violin(position = pd, alpha = 0.5)+
  geom_line(position = pd)+
  geom_point(data = summaryTable, aes( x = Nes, y = nDiv_alpha_dfe), position = pd)+
  geom_line(data = van1 , aes(x = as.factor(abs(Nes)), y = alpha, col = as.factor(pA), group = as.factor(pA)), lty = 2,position = pd)+
  scale_x_discrete(expression(italic(gamma[a])))+
  scale_y_continuous(expression(italic(hat(alpha)[DFE])))+
  scale_color_manual(expression(italic(p[a])), values = pal)+
  scale_fill_manual(expression(italic(p[a])), values = pal)+
  ggtitle('Without Divergence')+
  TommyTheme

wDiv_A_div<-ggplot(data = modelAverages , aes(x = as.factor(abs(Nes)), y = wDiv_alpha_dfe, col = as.factor(pA), fill = as.factor(pA), group = params))+
  geom_violin(position = pd, alpha = 0.5)+
  geom_line(position = pd)+
  geom_point(data = summaryTable, aes( x = Nes, y = wDiv_alpha_dfe), position = pd)+
  geom_line(data = van1 , aes(x = as.factor(abs(Nes)), y = alpha, col = as.factor(pA), group = as.factor(pA)), lty = 2,position = pd)+
  scale_x_discrete(expression(italic(gamma[a])))+
  scale_y_continuous(expression(italic(hat(alpha)[DFE])))+
  scale_color_manual(expression(italic(p[a])), values = pal)+
  scale_fill_manual(expression(italic(p[a])), values = pal)+
  ggtitle('With Divergence')+
  TommyTheme


Sb_plot <- ggarrange(wDiv_S_b, nDiv_S_b, ncol = 2, nrow = 1, labels = '', align = 'h', common.legend = T, legend = 'right')
pA_plot <- ggarrange(wDiv_pA, nDiv_pA, ncol = 2, nrow = 1, labels = '', align = 'h', common.legend = T, legend = 'right')
Alpha_plot <- ggarrange(wDiv_A_div, nDiv_A_div, ncol = 2, nrow = 1, labels = '', align = 'h', common.legend = T, legend = 'right')

FigureS4<- ggarrange(Sb_plot, pA_plot, Alpha_plot, ncol = 1, nrow = 3, labels = 'AUTO', align = 'v', common.legend = T, legend = 'right')

pdf("~/work/uSFS_positiveSelection/Plots/FigureS4.pdf", height = 10, width = 8)
print(FigureS4)
dev.off()

tiff("~/work/uSFS_positiveSelection/Plots/FigureS4.tiff", height = 10, width = 8, units = "in", res = 300)
print(FigureS4)
dev.off()
