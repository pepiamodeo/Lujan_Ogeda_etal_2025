# Data and R scripts for the article Lujan Ogeda *et al* 2025 entitled *Home is where the crevices are: Use and selection of microhabitat by a critically endangered lizard in the Ventania Mountains, Argentina*. 

Authors: 

* Luján Ogeda, Daniela B.
* Amodeo, Martín R. 
* Leynaud, Gerardo C. 
* Areco, Aníbal L. 
* Zalba, Sergio M.

This repository will preserved by Zenodo at publication 

### Project description

This R project consists in the datasets and scripts used for the analyses and plots exposed in the article. 

We examined the microhabitat use and selection of *Pristidactylus casuhatiensis*, a critically endangered rock-dwelling lizard 
endemic to the Ventania Mountain System in the temperate highland grasslands of Argentina. 
Structural variables were quantified in plots with and without lizard presence in order to identify.

R Project Structure:

* Folder */data*. Datasets in CSV format: 
    
* Folder */R*. R scripts for conducting the main analyses in the article. They are supposed to be run within the Rproject environment (relative path indicated):

  * 00_load_data.R. For data loading and cleaning.

  * 01_use.R. Descriptive statistics

  * 02_PCA.R. Performs Principal Components Analisis on vegetation data

  * 03_GLMM.R. Performs GLMM and model selection process.
   
* Folder */fig*. Figures.

For a full description of the study, data, experimental design, analyses and conclusions please see [DOI].
