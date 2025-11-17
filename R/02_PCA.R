
library(ggplot2)
library(ggfortify)

# load data
source("./R/00_load_data.R")

# ========================================
# PCA VEGETATION STRATA
# ========================================
estratos <- data[, c("veg_0_15", "veg_15_30", "veg_30_45", "veg_45")]

# PCA con escalado (importante porque todas están en % pero puede haber varianza distinta)
pca_estratos <- prcomp(estratos, scale. = TRUE)

# Resultados
summary(pca_estratos)   # % de varianza explicada por cada PC
pca_estratos$rotation   # carga de cada estrato en cada PC

# Scores de cada observación (valores de PC1, PC2...)
pca_scores <- as.data.frame(pca_estratos$x)

# Agrego PC1 y PC2 al data frame original
data$PC1 <- pca_scores$PC1
data$PC2 <- pca_scores$PC2

# PC1 distingue parcelas con alta cobertura de vegetación baja (0–15 cm)
# de parcelas con vegetación media-alta (30–45 y >45 cm)

# PC2 refleja un contraste entre vegetacion intermedia (15-30 cm) y los 
# extremos (muy baja y muy alta)

# Biplot 

autoplot(pca_estratos, data = data, colour = 'plot_type',
         loadings = TRUE, loadings.colour = 'red',
         loadings.label = TRUE, loadings.label.size = 3)
# cuántos PCs usar
pca_estratos$rotation

