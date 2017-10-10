# The-hidden-Benefits-of-Monitoring

Together with [Alexander Sebald](http://www.econ.ku.dk/sebald/) and [Georg Kirchsteiger](http://gkirchst.ulb.ac.be), I ran an experiment investigating agents' reactions to monitoring decisions of their supervisors (principals) in a real-effort task. We hypothesize that the agents' productivity is crucial to understand whether agents like or dislike to be monitored and that some agents act reciprocal. That is, agents pass back kindness if they perceive the principals' decisions as kind. Likewise, we expect them to be unkind towards the principals if they feel treated unjustly. The experiment we designed allows the agents to form second-order beliefs (*i.e. what the agents believe the principals believe the agent would do*) and to punish or reward the principal as a response to her monitoring decision by exerting less or more effort in the working task. We do *not* hypothesize that agents like or dislike to be monitored *per se*. Instead, we expect productive agents to prefer to be monitored while unproductive agents dislike to be monitored.

### Overview

You'll find several R scripts to replicate the analyses I ran for the experiment which was designed by Alexander Sebald, Georg Kirchsteiger and myself. Even though the analysis of the experiment is in this repository's focus, I'll also provide some information about its design, the key variables, how they are encoded and so on such that the reader can comprehend the R scripts and interpret the results more easily. If you want to run the experiment yourself, you can follow [this link](https://applications.econ.ku.dk/ceevirtuallaboratory/experiment_7/). Note that the experiment includes a two player game such that you'll have to run it on two browsers (or one incognito browser) or on different machines. I uploaded an [R script](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/R_Scripts/Write_DataBase.R) that writes the log in data (i.e. usernames and passwords). Contact me for the necessary information to reproduce the log in data.

Importantly, most - if not all - of the analyses are pre-specified prior to looking into the data. As a consequence, I did not know how clean the data would turn out to be when I designed the empirical strategy, chose the specifications, encoded the variables and so on. That is, I knew how the data should look like, since I programmed the experiment, but I did not know whether there would be any missing values, crashes etc. This might explain why some of the scripts lack elegance.

In addition to the R scripts, I'll provide a simulated data set (in the raw [xml](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/Simulated_Data/database.xml) as well as a [csv](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/Simulated_Data/simulatedExperimentData.csv) format) to illustrate the analysis in advance. You can use these data together with the scripts provided to replicate the most important figures, which I'll also upload in advance.

The [codebook](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/Codebook.pdf) lists all of the variables from the experiment (for data the raw as well as processed data) and has two sections. In the first section, variable name, label, and some additional information are given. It does not provide any summary statistics or information about the data types, however. Where applicable, the second part of the codebook provides text of the survey questions.

Since I splitted the analysis in several parts/ scripts, it is important to follow the designated order. More precisely, you'll have to start by installing a working directory which resembles mine. Subsequently, you'll have to store the data into the "01_Raw Data" folder and run the second script to read the raw (.xml) data. You'll end up having a .csv file stored in your "02_Processed Data" folder, which will be used in the subsequent scripts. The analysis will proceed with the data manipulation before the actual analysis can be performed. Afterwards, you'll have to run the "graphs and tables" script to visualize the data. In short, you should run the R scripts in the following order to replicate my analysis:

### How to replicate the analysis:
*The following hyperlinks will lead you to the corresponding R scripts. Run them step by step in the order they are listed here.*
1. [Create your working directory](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/R_Scripts/00_YourWorkingDirectory.R)
    1. Run the script first
    2. Download the data and scripts
    3. Store the data in the "01_Raw_Data" folder
    4. Store the R scripts in the "03_RCodes" folder
    5. Take a look into the scripts and adjust the wd path wherever necessary
2. [Read the raw data](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/R_Scripts/01_Read_XML_Data.R)
3. [Manipulate the data](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/R_Scripts/02_Data_Manipulation.R)
4. [Run the analysis](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/R_Scripts/03_Data_Analysis.R)
5. [Visualize the data](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/R_Scripts/04_Graphs&Tables.R)
    * You can find plots stemming from this file (using simulated data) [here](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/Figures)
    
 - - - -

#### Acknowledgments
A special thanks goes to Andreas Gotfredsen, who not only shared his software with me but also spent a lot of time adjusting it to our needs.

