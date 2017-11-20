# This script generates the directory that is used to access data and store processed data, figures and tables

rm(list=ls())
# You have to costumize the path to the working directory you intend to use
setwd("/Users/howquez/Documents/002_UNI/UCPH/016_Master Thesis/05_Data") 

folders <- c("01_RawData", "02_ProcessedData", "03_RCodes", "04_Figures", "05_Tables")
for (i in 1:length(folders))  { 
        dir.create(paste(folders[i], sep="/"), showWarnings = FALSE) 
} 
 
