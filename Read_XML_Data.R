
# Preamble ----------------------------------------------------------------

        rm(list=ls())
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

        names(Data)

# useless <- names(Data) %in% c("id", "Password", "Screen", "NoReload", "Answers", "boxdata", "browse")
# Data <- Data[!useless]
        usefull <- c("Session", "Username", "Group", "Role", "Completed", "IT", "screenChoice", "Payment1", "Payment2", "Payment",
                     "PaymentA")
        Data <- Data[usefull]
        

# Tidy Up -----------------------------------------------------------------
        
        head(Data)
        
        for(j in Data$Session){
                for(i in Data$Group){
                        Data$IT[Data$Role==1] <- Data$IT[Data$Role==2]
                        Data$PaymentA[Data$Role==1] <- Data$PaymentA[Data$Role==2]
                        #Data$Ypahat[Data$role==1] <- Data$Yaphat[Data$role==2]
                }
        }
        
        Data <- Data[Data$Role==1,]
        drop <- names(Data) %in% c("Role") 
        Data <- Data[!drop]


# View, Save and Reload Data ----------------------------------------------

#write a new .csv file
        setwd("/Users/howquez/Documents/002_UNI/UCPH/016_Master Thesis/05_Data")
        write.csv(Data, file = "02_ProcessedData/experimentData.csv")
        
# load it
        experimentData <- read.csv("02_ProcessedData/experimentData.csv", header=T)
        experimentData <- experimentData[,2:(ncol(experimentData))]
        
# and delete everything else
        rm(list=setdiff(ls(), "experimentData"))
        
#before viewing it
        View(experimentData)
        