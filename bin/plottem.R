rm(list = ls())

### Let's ake some plots of the results from the uSFS analysis
library(ggplot2)

dfe <- read.csv('work/uSFS_positiveSelection/simulations/fixedEffect_polyDFE_output_n20/n20_polyDFE.summary.csv')
dfe$product = dfe$Nes*dfe$pA

levels( dfe$stat )

ggplot(data = dfe[dfe$stat =='propSig',] , aes(x = as.factor(abs(Nes)), y = abs(median), col = as.factor(pA), group = as.factor(pA)))+
  geom_point(position = 'dodge')+
  geom_line()+
  scale_y_log10()+
  facet_grid(~taxa)

ggplot(data = dfe[dfe$stat == 'S_d',] , aes(x = as.factor(abs(Nes)), y = abs(median), col = as.factor(pA)))+
  geom_point(position = 'dodge')+
  geom_errorbar(aes(ymax = abs(upper), ymin = abs(lower)))+
  scale_y_log10()+
  facet_grid(~taxa)+
  geom_hline(aes(yintercept = 2000), lty = 2, alpha = 0.5)


ggplot(data = dfe[dfe$stat == 'b',] , aes(x = as.factor(abs(Nes)), y = abs(median), col = as.factor(pA)))+
  geom_point(position = 'dodge')+
  geom_errorbar(aes(ymax = abs(upper), ymin = abs(lower)))+
  scale_y_log10()+
  facet_grid(~taxa)+
  geom_hline(aes(yintercept = 0.3), lty = 2, alpha = 0.5)

ggplot(data = dfe[dfe$stat == 'product',] , aes(x = as.factor(abs(product)), y = abs(median), col = as.factor(pA)))+
  geom_point(position = 'dodge')+
  geom_errorbar(aes(ymax = abs(upper), ymin = abs(lower)))+
  scale_y_log10()+
  facet_grid(~taxa)+
  geom_hline(aes(yintercept = 0.3), lty = 2, alpha = 0.5)

ggplot(data = dfe[dfe$stat == 'pa_est',] , aes(x = as.factor(abs(pA)), y = abs(median), col = as.factor(Nes)))+
  geom_point(position = 'dodge')+
  geom_errorbar(aes(ymax = abs(upper), ymin = abs(lower)))+
  scale_y_log10()+
  facet_grid(~taxa)+
  geom_hline(aes(yintercept = 0.3), lty = 2, alpha = 0.5)

ggplot(data = dfe[dfe$stat == 'Sb_est',] , aes(x = as.factor(abs(Nes)), y = abs(median), col = as.factor(pA)))+
  geom_point(position = 'dodge')+
  geom_errorbar(aes(ymax = abs(upper), ymin = abs(lower)))+
  scale_y_log10()+
  facet_grid(~taxa)+
  geom_hline(aes(yintercept = 0.3), lty = 2, alpha = 0.5)


ggplot(data = dfe[dfe$stat == 'alpha_div',] , aes(x = as.factor(abs(Nes)), y = abs(median), col = as.factor(pA)))+
  geom_point(position = 'dodge')+
  geom_errorbar(aes(ymax = abs(upper), ymin = abs(lower)))+
  scale_y_log10()+
  facet_grid(~taxa)+
  geom_hline(aes(yintercept = 0.3), lty = 2, alpha = 0.5)



van <- read.csv('~/work/uSFS_positiveSelection/simulations/fixedEffect/all.vanilla.summary.csv')

van1 <- van[van$Time == 'T1',]
van2 <- van[van$Time == 'T2',]

ggplot(data = van1 , aes(x = as.factor(abs(Nes)), y = segSites_nonsyn, col = as.factor(pA)))+
  geom_line()+
  geom_point()+
  scale_y_log10()

ggplot(data = van1 , aes(x = as.factor(abs(Nes)), y = segSites_syn, col = as.factor(pA)))+
  geom_line()+
  geom_point()+
  scale_y_log10()

ggplot(data = van1 , aes(x = as.factor(abs(Nes)), y = alpha, col = as.factor(pA)))+
  geom_line()+
  geom_point()+
  scale_y_log10()

ggplot(data = van2 , aes(x = as.factor(abs(Nes)), y = alpha, col = as.factor(pA)))+
  geom_line()+
  geom_point()+
  scale_y_log10()


ggplot(data = van2 , aes(x = as.factor(abs(Nes)), y = pi_nonsyn/pi_syn, col = as.factor(pA)))+
  geom_line()+
  geom_point()+
  scale_y_log10()


ggplot(data = van1 , aes(x = as.factor(abs(Nes)), y = dN, col = as.factor(pA)))+
  geom_point()+
  scale_y_log10()

ggplot(data = van2 , aes(x = as.factor(abs(Nes)), y = dN, col = as.factor(pA)))+
  geom_point()+
  scale_y_log10()
