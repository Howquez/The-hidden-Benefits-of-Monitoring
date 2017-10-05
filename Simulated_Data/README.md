# Simulated Data

Since the analysis is pre-specified, I wrote the R scripts without any actual data at hand. Because I found it a lot easier to write and test the scripts, I simulated some raw data which resembles the experimental data with regards to its format and the variables. 

I furthermore generated patterns that match our hypotheses. That is, unproductive agents who face a high likelihood (IT==75) of being paid performance based in stage 2 will, on average behave as if they were treated unjustly. That is, their performance will be lower than it should be given the high monetary incentives. If the face a low likelihhod however (IT==25), they will put more effort into the task than they did in the first stage. The complete opposite holds for productive agents.

The [xml](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/Simulated_Data/database.xml) file shares the format of the raw data the experiment will yield. The [csv](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/Simulated_Data/simulatedExperimentData.csv) file contains the same observations but fewer variables. It is processed using the script I provide [here](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/R_Scripts/01_Read_XML_Data.R). The csv file is easier to read and to process in your favorite statistics program.
