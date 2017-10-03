
# Preamble etc. -----------------------------------------------------------

        rm(list=ls())
# I need to update this path when finishing the testing
        setwd("/Users/howquez/Documents/002_UNI/UCPH/016_Master Thesis/05_Data/01_RawData")
        library(XML)
        library(methods)
        library(plyr)
        
        list.files()
        
        filenames <- list.files(path = , full.names=TRUE)
        filenames <- gsub("./", "", filenames)


# Merge XML Files Into Data Frame -----------------------------------------

        parse_xml <-function(FileName) {
                step1 <- xmlParse(FileName) 
                step2 <- cbind(xmlToDataFrame(step1), xmlToDataFrame(nodes=getNodeSet(step1,"//User/Answers")))
        } 
        Data <- ldply(filenames, parse_xml)



# Add Session ID ----------------------------------------------------------

# find the number of participants for each session (sessionLength). We can use this to subset the final data set
        sessionLength <- 0
        for(i in 1:length(filenames)){
                sessionLength[i] <- length(getNodeSet(xmlParse(file = filenames[i]),"//User/Answers"))
        }

# add a session cloumn and replace its pseudo-values using sessionLength and a subset strategy
        Data$Session <- 9999
        for(j in 1:length(filenames)){
                if(j==1){
                        Data$Session[1:(sessionLength[1])] <- 1
                }
                else if(j==length(filenames)){
                        Data$Session[(length(Data$Session)-sessionLength[j]+1):length(Data$Session)] <- j
                }
                else
                        Data$Session[(sum(sessionLength[1:(j-1)])+1):(sum(sessionLength[1:j]))] <- j
        }

# Drop Useless Variables --------------------------------------------------

# the vector has to be updated as soon as the eventual variables (/names of them) are programmed
        usefull <- c("Session", "Username", "Group", "Role", "Completed", "score2", "score", "PersonAProb", "screenChoice",
                     "Reciprocity1", "Reciprocity2", "Reciprocity3", "Reciprocity4",
                     "PayA2", "PayB2", "PayA1", "PayB1", "PaymentA", "PaymentB")
        Data <- Data[usefull]
        

# Tidy Up -----------------------------------------------------------------
        
# Drop incomplete observations
        Data <- Data[Data$Completed == "true",] 
        
# tidy data such that, eventually,  one row contains one observation
        for(j in Data$Session){
                for(i in Data$Group){
                        Data$PrinProd[Data$Role==1]    <- Data$score2[Data$Role==2]
                        Data$PersonAProb[Data$Role==1] <- Data$PersonAProb[Data$Role==2]
                        Data$PaymentA[Data$Role==1] <- Data$PaymentA[Data$Role==2]
                        Data$PayA1[Data$Role==1] <- Data$PayA1[Data$Role==2]
                        Data$PayA2[Data$Role==1] <- Data$PayA2[Data$Role==2]
                        Data$RA1[Data$Role==1] <- Data$Reciprocity1[Data$Role==2]
                        Data$RA2[Data$Role==1] <- Data$Reciprocity2[Data$Role==2]
                        Data$RA3[Data$Role==1] <- Data$Reciprocity3[Data$Role==2]
                        Data$RA4[Data$Role==1] <- Data$Reciprocity4[Data$Role==2]
                }
        }
        
        Data <- Data[Data$Role==1,]
        drop <- names(Data) %in% c("Role") 
        Data <- Data[!drop]


# View, Save and Reload Data ----------------------------------------------

# write a new .csv file
        setwd("/Users/howquez/Documents/002_UNI/UCPH/016_Master Thesis/05_Data")
        write.csv(Data, file = "02_ProcessedData/experimentData.csv")
        
# load it
        experimentData <- read.csv("02_ProcessedData/experimentData.csv", header=T)
        experimentData <- experimentData[,2:(ncol(experimentData))]
        
# and delete everything else
        rm(list=setdiff(ls(), "experimentData"))
        
# before viewing it
        View(experimentData)
        