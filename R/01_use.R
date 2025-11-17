
rm(list=ls()) # limpio area de trabajo

# ========================================
# 1. Descripción del microhábitat
# ========================================

library(dplyr)
library(tidyverse)
library(ggplot2)

# load data
source("./R/00_load_data.R")

# Filtrar solo parcelas con presencia
presence <- data %>% filter(plot_type == 1)

# Variables de interés
vars <- c("rock", "rock_crevices", "veg_cov", "bare_soil_cov",
          "veg_0_15", "veg_15_30", "veg_30_45", "veg_45")

# Tabla descriptiva completa
desc_stats <- presence %>%
  select(all_of(vars)) %>%
  summarise(across(
    everything(),
    list(
      mean   = ~mean(., na.rm = TRUE),
      median = ~median(., na.rm = TRUE),
      sd     = ~sd(., na.rm = TRUE),
      se     = ~sd(., na.rm = TRUE) / sqrt(sum(!is.na(.))),
      min    = ~min(., na.rm = TRUE),
      max    = ~max(., na.rm = TRUE)
    ),
    .names = "{.col}_{.fn}"
  ))

desc_stats

# Boxplots descriptivos
presence %>%
  pivot_longer(cols = c(rock, rock_crevices, veg_cov, bare_soil_cov, 
                        veg_0_15, veg_15_30, veg_30_45, veg_45),
               names_to = "variable", values_to = "valor") %>%
  ggplot(aes(x = variable, y = valor, fill = variable)) +
  geom_boxplot(alpha = 0.7) +
  theme_minimal() +
  labs(y = "Cover (%)", x = "Variable") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none")


# Filtrar solo parcelas aleatorias
random <- data %>% filter(plot_type == 0)

# Tabla descriptiva completa
stats <- random %>%
  select(all_of(vars)) %>%
  summarise(across(
    everything(),
    list(
      mean   = ~mean(., na.rm = TRUE),
      median = ~median(., na.rm = TRUE),
      sd     = ~sd(., na.rm = TRUE),
      se     = ~sd(., na.rm = TRUE) / sqrt(sum(!is.na(.))),
      min    = ~min(., na.rm = TRUE),
      max    = ~max(., na.rm = TRUE)
    ),
    .names = "{.col}_{.fn}"
  ))

stats

