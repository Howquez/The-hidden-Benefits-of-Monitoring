# The-hidden-Benefits-of-Monitoring

You'll find several R scripts to replicate the analyses I ran for an experiment which was designed by Alexander Sebald, Georg Kirchsteiger and myself for my master thesis. Even though the analysis of the experiment is in this repository's focus, I'll also provide some information about its design, the key variables, how they are encoded and so on such that the reader can comprehend the R scripts and interpret the results more easily. If you want to run the experiment yourself, you can follow [this link](https://applications.econ.ku.dk/ceevirtuallaboratory/experiment_7/). Note that you'll have to run it on two browsers (or one incognito browser) or on different machines. I uploaded an [R script](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/Write_DataBase.R) that writes the log in data (i.e. usernames and passwords). Contact me for the necessary information to reproduce the log in data.

Importantly, most - if not all - of the analyses are pre-specified prior to looking into the data. As a consequence, I did not exactly know how the data looks like, when I designed the empirical strategy, chose the specifications, encoded the variables and so on. This might explain why some of the scripts lack elegance.

In addition to the R scripts, I'll provide a simulated data set to illustrate the analysis in advance. You can use these data together with the scripts provided to replicate the most important figures, which I'll also upload in advance.

Since I splitted the analysis in several parts/ scripts, it is important to follow the designated order. More precisely, you'll have to start by installing a working directory which resembles mine. Subsequently, you'll have to store the data into the "01_Raw Data" folder and run the second script to read the raw (.xml) data. You'll end up having a .csv file stored in your "02_Processed Data" folder, which will be used in the subsequent scripts. The analysis will proceed with the data manipulation before the actual analysis can be performed. Afterwards, you'll have to run the "graphs and tables" script to visualize the data. In short, you should run the R scripts in the following order to replicate my analysis:

### How to reproduce the analysis:
1. [00_YourWorkingDirectory.R](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/00_YourWorkingDirectory.R)
    1. Run the script first
    2. Download the data and scripts
    3. Store the data in the "01_Raw_Data" folder
    4. Store the R scripts in the "03_RCodes" folder
    5. Take a look into the scripts and adjust the wp path wherever necessary
2. [01_Read_XML_Data.R](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/01_Read_XML_Data.R)
3. [02_Data_Manipulation.R](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/02_Data_Manipulation.R)
4. [03_Data_Analysis.R](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/03_Data_Analysis.R)
5. [04_Graphs&Tables.R](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/04_Graphs%26Tables.R)
