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
    strip.text.y = element_text(size = 20)
  )

stripper <- theme(
  strip.background = element_blank(),
  strip.text.x = element_blank(),
  strip.text.y = element_blank()
)
### Let's make some plots of the results from the uSFS analysis

### First read in the raw data...

dfe <- read.csv('~/work/uSFS_positiveSelection/simulations/fixedEffect_N10000/polyDFE_runs_n20/n20_polyDFE.summary.csv')
dfe$product = dfe$Nes*dfe$pA

propSig <- dfe[dfe$stat == 'propSig',]
write.csv(propSig, '~/work/uSFS_positiveSelection/Plots/propSig.csv')
gradient_l1 <- dfe[dfe$stat == 'gradient_l1',]
write.csv(gradient_l1, '~/work/uSFS_positiveSelection/Plots/gradient_l1.csv')
gradient_l0.1 <- dfe[dfe$stat == 'gradient_l0.1',]
write.csv(gradient_l0.1, '~/work/uSFS_positiveSelection/Plots/gradient_l0.1.csv')

van <- read.csv('~/work/uSFS_positiveSelection/simulations/fixedEffect_N10000/all.vanilla.summary.csv')

van1 <- van[van$Time == 'T1',]
van2 <- van[van$Time == 'T2',]

dfe$taxa <- factor(dfe$taxa, levels = c('withD','noD'), labels = c('With Divergence', 'Without Divergence'))

pd = position_dodge(0.5)

S_d<-ggplot(data = dfe[dfe$stat == 'S_d',] , aes(x = as.factor(abs(Nes)), y = abs(median), col = as.factor(pA), group = as.factor(pA)))+
  geom_point(position = pd)+
  geom_line(position = pd)+
  geom_errorbar(aes(ymax = abs(upper), ymin = abs(lower)), position = pd, width = 0.3)+
  scale_y_log10(expression(hat(italic('2'*N[e]*s[d]))))+
  scale_color_manual(expression(italic(p[a])), values = pal)+
  scale_x_discrete(expression(italic(gamma[a])))+
  facet_grid(~taxa)+
  geom_hline(aes(yintercept = 2000), lty = 2, alpha = 0.5)+
  TommyTheme


beta<- ggplot(data = dfe[dfe$stat == 'b',] , aes(x = as.factor(abs(Nes)), y = abs(median), col = as.factor(pA), group = as.factor(pA)))+
  geom_point(position = pd)+
  geom_line(position = pd)+
  geom_errorbar(aes(ymax = abs(upper), ymin = abs(lower)), position = pd, width = 0.3)+
  scale_x_discrete(expression(italic(gamma[a])))+
  scale_y_log10(expression(beta))+
  facet_grid(~taxa)+
  geom_hline(aes(yintercept = 0.3), lty = 2, alpha = 0.5)+
  scale_color_manual(expression(italic(p[a])), values = pal)+
  TommyTheme

prod<- ggplot(data = dfe[dfe$stat == 'product',] , aes(x = as.factor(Nes), y = abs(median), col = as.factor(pA), group = as.factor(pA)))+
  geom_point(position = pd)+
  geom_line(position = pd)+
  geom_errorbar(aes(ymax = abs(upper), ymin = abs(lower)), position = pd, width = 0.3)+
  scale_x_discrete(expression(italic(gamma[a])))+
  scale_y_log10()+
  facet_grid(taxa~.)+
  geom_hline(aes(yintercept = 0.3), lty = 2, alpha = 0.5)+
  scale_color_manual(expression(italic(p[a])), values = pal)+
  TommyTheme


pA<-ggplot(data = dfe[dfe$stat == 'pa_est',] , aes(x = as.factor(abs(pA)), y = abs(median)/pA, col = as.factor(Nes), group = as.factor(pA)))+
  geom_point(position = pd)+
  geom_line(position = pd)+
  geom_errorbar(aes(ymax = abs(upper/pA), ymin = abs(lower/pA)), position = pd, width = 0.3)+
  scale_y_log10(expression(hat(italic(p[a]))))+
 scale_x_discrete(expression(italic(gamma[a])))+
  facet_grid(taxa~.)+
  #scale_color_manual(expression(italic(p[a])), values = pal)+
  TommyTheme


doge <- position_dodge(1)
cBpal <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

pA<- ggplot(data = dfe[dfe$stat == 'pa_est',] , aes(x = as.factor(abs(pA)), y = median, col = as.factor(Nes), group = as.factor(Nes)))+
  geom_point(position = position_dodge(0.5),stat ='identity')+
  geom_errorbar(aes(ymax = upper, ymin = lower), position = position_dodge(0.5),stat ='identity', width = 0)+
  scale_y_log10(expression(hat(italic(p[a]))))+
  scale_color_manual(expression(italic(gamma[a])), values = cBpal)+
  geom_errorbar(aes(ymin = pA, ymax = pA), col = 'grey', lty = 2) + 
  scale_x_discrete(expression(italic(p[a])))+
  facet_grid(~taxa)+
  #scale_color_manual(expression(italic(p[a])), values = pal)+
  TommyTheme


  
  
  
  


S_b<-ggplot(data = dfe[dfe$stat == 'Sb_est',] , aes(x = as.factor(abs(Nes)), y = abs(median), col = as.factor(pA), group = as.factor(pA)))+
  geom_point(position = pd)+
  geom_line(position = pd)+
  geom_errorbar(aes(ymax = abs(upper), ymin = abs(lower)), position = pd, width = 0.3)+
  scale_y_log10(expression(hat(italic(gamma[a]))))+
  scale_x_discrete(expression(italic(gamma[a])))+
  facet_grid(~taxa)+
  scale_color_manual(expression(italic(p[a])), values = pal)+
  TommyTheme
library(ggthemes)

A_div<-ggplot(data = dfe[dfe$stat == 'alpha_div',] , aes(x = as.factor(abs(Nes)), y = abs(median), col = as.factor(pA), group = as.factor(pA)))+
  geom_point(position = pd)+
  geom_line(position = pd)+
  geom_errorbar(aes(ymax = abs(upper), ymin = abs(lower)), position = pd, width = 0.3)+
  scale_x_discrete(expression(italic(gamma[a])))+
  scale_y_continuous(expression(italic(hat(alpha)[Divergence])))+
  facet_grid(~taxa)+
  scale_color_manual(expression(italic(p[a])), values = pal)+
  TommyTheme

A_dfe<-ggplot(data = dfe[dfe$stat == 'alpha_dfe',] , aes(x = as.factor(abs(Nes)), y = abs(median), col = as.factor(pA), group = as.factor(pA)))+
  geom_point(position = pd)+
  geom_line(position = pd)+
  geom_line(data = van1 , aes(x = as.factor(abs(Nes)), y = alpha, col = as.factor(pA), group = as.factor(pA)), lty = 2,position = pd)+
  geom_errorbar(aes(ymax = abs(upper), ymin = abs(lower)), position = pd, width = 0.3)+
  facet_grid(~taxa)+
  scale_x_discrete(expression(italic(gamma[a])))+
  scale_y_continuous(expression(italic(hat(alpha)[DFE])))+
  scale_color_manual(expression(italic(p[a])), values = pal)+
  TommyTheme



str(van1)
van1$product <- van1$Nes * van1$pA
vanHighlight <- van1[van1$product == 0.1, ]

S_adv<- ggplot(data = van1 , aes(x = as.factor(abs(Nes)), y = segSites_nonsyn_adv, col = as.factor(pA), group = as.factor(pA)))+
  geom_point(size = 4)+
  geom_point(data = vanHighlight , aes(x = as.factor(abs(Nes)), y = segSites_nonsyn_adv), col = 'black', shape = 1, size = 8)+
  geom_line(alpha = 0.75)+
  scale_color_manual(expression(italic(p[a])), values = pal)+
  scale_y_log10(expression(italic(S[Adv.])))+
  scale_x_discrete(expression(italic(gamma[a])))+
  TommyTheme

S_syn<-ggplot(data = van1 , aes(x = as.factor(abs(Nes)), y = segSites_syn, col = as.factor(pA)))+
  geom_point(size = 4)+
  geom_point(data = vanHighlight , aes(x = as.factor(abs(Nes)), y = segSites_syn), col = 'black', shape = 1, size = 8)+
  
  scale_color_manual(expression(italic(p[a])), values = pal)+
  scale_y_log10(expression(pi[N]/pi[S]))+
  scale_x_discrete(expression(italic(gamma[a])))+
  TommyTheme

prop_S<- ggplot(data = van1 , aes(x = as.factor(abs(Nes)), y = segSites_nonsyn_adv/ (segSites_nonsyn_adv + segSites_syn), col = as.factor(pA), group = as.factor(pA)))+
  geom_point(size = 4)+
  geom_point(data = vanHighlight , aes(x = as.factor(abs(Nes)), y = segSites_nonsyn_adv/ (segSites_nonsyn_adv + segSites_syn)), col = 'black', shape = 1, size = 8)+
  geom_line(alpha = 0.75)+
  scale_color_manual(expression(italic(p[a])), values = pal)+
  scale_y_log10(expression(italic(S[Adv.]/S)))+
  scale_x_discrete(expression(italic(gamma[a])))+
  TommyTheme

ALPHA<- ggplot(data = van1 , aes(x = as.factor(abs(Nes)), y = alpha, col = as.factor(pA), group = as.factor(pA)))+
  geom_point(size = 4)+
  geom_point(data = vanHighlight , aes(x = as.factor(abs(Nes)), y = alpha), col = 'black', shape = 1, size = 8)+
  geom_line(alpha = 0.75)+
  scale_color_manual(expression(italic(p[a])), values = pal)+
  scale_y_continuous(expression(italic(alpha[Obs])), limits = c(0,1))+
  scale_x_discrete(expression(italic(gamma[a])))+
  TommyTheme


piN_piS <- ggplot(data = van2 , aes(x = as.factor(abs(Nes)), y = pi_nonsyn/pi_syn, col = as.factor(pA), group = as.factor(pA)))+
  geom_point(size = 4)+
  geom_point(data = vanHighlight , aes(x = as.factor(abs(Nes)), y = pi_nonsyn/pi_syn), col = 'black', shape = 1, size = 8)+
  geom_line(alpha = 0.75)+
  scale_color_manual(expression(italic(p[a])), values = pal)+
  scale_y_log10(expression(pi[N]/pi[S]))+
  scale_x_discrete(expression(italic(gamma[a])))+
  TommyTheme

pi_pi0<- ggplot(data = van2 , aes(x = as.factor(abs(Nes)), y = pi_syn/0.01, col = as.factor(pA), group = as.factor(pA)))+
  geom_point(size = 4)+
  geom_point(data = vanHighlight , aes(x = as.factor(abs(Nes)), y = pi_syn/0.01), col = 'black', shape = 1, size = 8)+
  geom_line(alpha = 0.75)+
  scale_color_manual(expression(italic(p[a])), values = pal)+
  scale_y_continuous(expression(pi[S]/pi[0]), limits = c(0,1))+
  scale_x_discrete(expression(italic(gamma[a])))+
  TommyTheme

dN_dS<- ggplot(data = van1 , aes(x = as.factor(abs(Nes)), y = dN/dS, col = as.factor(pA)))+
  geom_point(size = 4)+
  geom_point(data = vanHighlight , aes(x = as.factor(abs(Nes)), y = dN/dS), col = 'black', shape = 1, size = 8)+
  scale_color_manual(expression(italic(p[a])), values = pal)+
  scale_y_log10(expression(italic(d[N]/d[S])))+
  scale_x_discrete(expression(italic(gamma[a])))+
  TommyTheme

Figure1<- ggarrange(ALPHA, pi_pi0, prop_S, ncol = 3, nrow = 1, labels = 'AUTO', common.legend = T, legend = 'bottom')

pdf("~/work/uSFS_positiveSelection/Plots/Figure1.pdf", width = 12, height = 4)
print(Figure1)
dev.off()
tiff("~/work/uSFS_positiveSelection/Plots/Figure1.tiff", width = 12, height = 4, res = 300, units = "in")
print(Figure1)
dev.off()



Figure3<- ggarrange(S_b, pA, A_dfe, ncol = 1, nrow = 3, labels = "AUTO", common.legend = F, legend = 'right', widths = c(1, 2), align = 'v')

pdf("~/work/uSFS_positiveSelection/Plots/Figure3.pdf", height = 10, width = 8)
print(Figure3)
dev.off()
tiff("~/work/uSFS_positiveSelection/Plots/Figure3.tiff", height = 10, width = 8, res = 300, units = "in")
print(Figure3)
dev.off()

FigureS1<- ggarrange(S_d, beta, ncol = 1, nrow = 2, labels = 'AUTO', align = 'v', common.legend = T, legend = 'right')

pdf("~/work/uSFS_positiveSelection/Plots/FigureS1.pdf", width = 12, height = 8)
print(FigureS1)
dev.off()

tiff("~/work/uSFS_positiveSelection/Plots/FigureS1.tiff", width = 12, height = 8, units = "in", res = 300)
print(FigureS1)
dev.off()

