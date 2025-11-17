
rm(list=ls()) # limpio area de trabajo

library(lme4)
library(ggplot2)
library(GGally)
library(ggeffects)


library(stringr)
library(Matrix)
library(lubridate)
library(dplyr)
library(ggfortify)


library(MuMIn)
library(sjPlot)
library(knitr)

# load data
source("./R/00_load_data.R")
source("./R/02_PCA.R")

# Exploration
names(data)
ggpairs(data,columns=11:20)

ggsave("./fig_exp/fig_exploracion_predictoras.png",width = 3000,height = 2000,units = "px")

# SELECTION OF VARIABLES 
data$rock_cov
data$rock_crevices_cov
data$veg_0_15
data$veg_15_30 
data$veg_30_45
data$veg_45
data$PC1
data$PC2

# ========================================
# GLMM
# ========================================

# MODELO 1 >>>>>>>>>>>>> AIC 402.8, 
glm.fit1 <- glmer(data = data,
                 plot_type ~ rock_cov +
                   rock_crevices_cov +
                   veg_cov +
                   (1|id_lizard), 
                 family = binomial(link = "logit"))

anova(glm.fit1)
summary(glm.fit1)

# MODELO 2 >>>>>>>>>>>>> AIC 
glm.fit2 <- glmer(plot_type ~ rock_cov + 
                    rock_crevices_cov + 
                    veg_0_15 +
                    veg_45 +
                    (1|id_lizard), 
                  data = data, 
                  family = binomial(link="logit"))

anova(glm.fit2)
summary(glm.fit2)

# MODELO 3 >>>>>>>>>>>>> AIC 392.4
glm.fit3 <- glmer(plot_type ~ rock_cov + 
                  rock_crevices_cov + 
                  PC1 +
                  PC2 +
                  (1|id_lizard), 
                  data = data, 
                  family = binomial(link="logit"))

anova(glm.fit3)
summary(glm.fit3)

# MODELO 4 >>>>>>>>>>>>> AIC 392.4
glm.fit4 <- glmer(plot_type ~ rock_cov + 
                    rock_crevices_cov * 
                    PC2 +
                    PC1 +
                    (1|id_lizard), 
                  data = data, 
                  family = binomial(link="logit"))

anova(glm.fit4)
summary(glm.fit4)

# 2) Comparar modelos alternativos 

model_list <- list(glm.fit1, glm.fit2, glm.fit3, glm.fit4)

# 1. Tabla de selección de modelos (AICc)
tab_model_sel <- model.sel(model_list)

# data frame
df_model_sel <- as.data.frame(tab_model_sel)

# tabla tipo sjPlot
tab_df(df_model_sel,
       title = "Table X. Model selection results ranked by AICc",
       file = "model_selection.doc")  # Word

# 2. Tabla de parámetros del mejor modelo >>>>>> glm.fit4 

# Extraer coeficientes
coefs <- summary(glm.fit4)$coefficients

# Odds Ratios e IC95%
OR <- exp(coefs[,1])
lowerCI <- exp(coefs[,1] - 1.96*coefs[,2])
upperCI <- exp(coefs[,1] + 1.96*coefs[,2])

# Tabla lista 
results_table <- data.frame(
  Predictor = rownames(coefs),
  `Estimate (SE)` = paste0(round(coefs[,1], 3), " (", round(coefs[,2], 3), ")"),
  `z value` = round(coefs[,3], 2),
  `p value` = format.pval(coefs[,4], digits = 3, eps = 0.001), # sin notación científica
  `Odds Ratio (95% CI)` = paste0(round(OR, 2), " (", round(lowerCI, 2), "–", round(upperCI, 2), ")")
)

kable(results_table, align = "lcccc")

# data frame
df_mod4 <- as.data.frame(results_table)

# tabla tipo sjPlot
tab_df(df_mod4,
       title = "Table 4. Model selection results ranked by AICc",
       file = "model4.doc")  # Word


# marginal effects

plot(predict_response(glm.fit4,terms="rock_crevices_cov",bias_correction = TRUE))
plot(predict_response(glm.fit4,terms=c("rock_cov"),bias_correction = TRUE))
plot(predict_response(glm.fit4,terms=c("rock_crevices_cov","rock_cov"),bias_correction = TRUE))
plot(predict_response(glm.fit4,terms=c("PC1"),bias_correction = TRUE))
plot(predict_response(glm.fit4,terms=c("PC2"),bias_correction = TRUE))
plot(predict_response(glm.fit4,terms=c("PC2","rock_crevices_cov")))
plot(predict_response(glm.fit4,terms=c("PC2 [all]","rock_crevices_cov")))

# Figures

# Fig Rock slabs with crevices
predichos1<-predict_response(glm.fit4,terms="rock_crevices_cov [all]")

plot(predichos1)+
  labs(y="Probability of Ocurrence",x="Rock Crevices Coverage (%)")+
  theme(title = element_blank(),
        legend.position = "bottom")

ggsave("./fig/fig_rockcrevices.png",
       units = c("mm"), 
       height = 160, width = 200, 
       dpi = 300)

# Fig Rock * PC2
predichos2<-predict_response(glm.fit4,terms=list(PC2 = "all",rock_crevices_cov=c(0,5,15,25)))
plot(predichos2)+
  labs(y="Probability of Ocurrence",x="PC2 (Vegetation)", colour="Rock Crevices Coverage (%)")+
  theme(title = element_blank(),
        legend.position = "bottom")

ggsave("./fig/fig_rockcrevicesPC2.png",
       units = c("mm"), 
       height = 160, width = 200, 
       dpi = 300)
