# Load Data ---------------------------------------------------------------

setwd("/Users/howquez/Documents/002_UNI/UCPH/016_Master Thesis/05_Data")

# load it
experimentData <- read.csv("02_ProcessedData/experimentData.csv", header=T)
experimentData <- experimentData[,2:(ncol(experimentData))]

# and delete everything else
rm(list=setdiff(ls(), "experimentData"))

# Data manipulation -------------------------------------------------------

names(experimentData)

# Restrict sample to complete observations
experimentData <- na.omit(experimentData)

# Rename key variables
names(experimentData)[names(experimentData)=="score2"]          <- "Productivity"
names(experimentData)[names(experimentData)=="score"]           <- "Performance"
names(experimentData)[names(experimentData)=="PersonAProb"]     <- "IT"

names(experimentData)[names(experimentData)=="Reciprocity1"]    <- "RB1"
names(experimentData)[names(experimentData)=="Reciprocity2"]    <- "RB2"
names(experimentData)[names(experimentData)=="Reciprocity3"]    <- "RB3"
names(experimentData)[names(experimentData)=="Reciprocity4"]    <- "RB4"

# change how IT as well a Productivity and Performance are encoded
experimentData$IT <- as.integer(experimentData$IT)
# experimentData$IT[experimentData$IT <= 50] <- 2 # low  IT or "Likelihood" is coded as zero
# experimentData$IT[experimentData$IT >  50] <- 1 # high IT or "Likelihood" is coded as one
experimentData$IT <- -(experimentData$IT -2) # we changed the variable's encoding

experimentData$Productivity <- experimentData$Productivity / 100
experimentData$Performance <- experimentData$Performance / 100

# Generate variables
sampleSize  <- NROW(experimentData)
maxScreens  <- 25 # Need to adjust this!
q           <- 0.5

experimentData$relProductivity <- experimentData$Productivity - q
experimentData$Productive   <- 9999
        experimentData$Productive[experimentData$relProductivity >= 0] <- 1
        experimentData$Productive[experimentData$relProductivity <  0] <- 0

experimentData$perfDifference  <- experimentData$Performance  - experimentData$Productivity

experimentData$eDiff[experimentData$IT == 1] <- experimentData$Performance[experimentData$IT == 1] -
        0.75 * experimentData$Productivity[experimentData$IT == 1]
experimentData$eDiff[experimentData$IT == 0] <- experimentData$Performance[experimentData$IT == 0] -
        0.25 * experimentData$Productivity[experimentData$IT == 0]


# Generate variable to estimate the player's sensitivity to rec --------

# Change how variables are encoded
# We cannot do something like this experimentData$RA1 <- as.integer(experimentData$RA1)
# since it might be the case that one/some of the options are not used as answers in the whole sample
# Start with the Principal 

experimentData$RA1 <- as.character(experimentData$RA1)
experimentData$RA1[experimentData$RA1 == "300 DKK worth"]                       <- 6
experimentData$RA1[experimentData$RA1 == "250 DKK worth"]                       <- 5
experimentData$RA1[experimentData$RA1 == "200 DKK worth"]                       <- 4
experimentData$RA1[experimentData$RA1 == "150 DKK worth"]                       <- 3
experimentData$RA1[experimentData$RA1 == "100 DKK worth"]                       <- 2
experimentData$RA1[experimentData$RA1 == "50 DKK worth"]                        <- 1
experimentData$RA1 <- as.numeric(experimentData$RA1)

experimentData$RA2 <- as.character(experimentData$RA2)
experimentData$RA2[experimentData$RA2 == "Describes me perfectly"]              <- 6
experimentData$RA2[experimentData$RA2 == "Mostly true of me"]                   <- 5
experimentData$RA2[experimentData$RA2 == "Slightly more true than untrue"]      <- 4
experimentData$RA2[experimentData$RA2 == "Slightly more untrue than true"]      <- 3
experimentData$RA2[experimentData$RA2 == "Mostly untrue of me"]                 <- 2
experimentData$RA2[experimentData$RA2 == "Completely untrue of me"]             <- 1
experimentData$RA2 <- as.numeric(experimentData$RA2)

experimentData$RA3 <- as.character(experimentData$RA3)
experimentData$RA3[experimentData$RA3 == "Describes me perfectly"]              <- 6
experimentData$RA3[experimentData$RA3 == "Mostly true of me"]                   <- 5
experimentData$RA3[experimentData$RA3 == "Slightly more true than untrue"]      <- 4
experimentData$RA3[experimentData$RA3 == "Slightly more untrue than true"]      <- 3
experimentData$RA3[experimentData$RA3 == "Mostly untrue of me"]                 <- 2
experimentData$RA3[experimentData$RA3 == "Completely untrue of me"]             <- 1
experimentData$RA3 <- as.numeric(experimentData$RA3)

experimentData$RA4 <- as.character(experimentData$RA4)
experimentData$RA4[experimentData$RA4 == "Describes me perfectly"]              <- 6
experimentData$RA4[experimentData$RA4 == "Mostly true of me"]                   <- 5
experimentData$RA4[experimentData$RA4 == "Slightly more true than untrue"]      <- 4
experimentData$RA4[experimentData$RA4 == "Slightly more untrue than true"]      <- 3
experimentData$RA4[experimentData$RA4 == "Mostly untrue of me"]                 <- 2
experimentData$RA4[experimentData$RA4 == "Completely untrue of me"]             <- 1
experimentData$RA4 <- as.numeric(experimentData$RA4)

# Proceed with the Agent 

experimentData$RB1 <- as.character(experimentData$RB1)
experimentData$RB1[experimentData$RB1 == "300 DKK worth"]                       <- 6
experimentData$RB1[experimentData$RB1 == "250 DKK worth"]                       <- 5
experimentData$RB1[experimentData$RB1 == "200 DKK worth"]                       <- 4
experimentData$RB1[experimentData$RB1 == "150 DKK worth"]                       <- 3
experimentData$RB1[experimentData$RB1 == "100 DKK worth"]                       <- 2
experimentData$RB1[experimentData$RB1 == "50 DKK worth"]                        <- 1
experimentData$RB1 <- as.numeric(experimentData$RB1)

experimentData$RB2 <- as.character(experimentData$RB2)
experimentData$RB2[experimentData$RB2 == "Describes me perfectly"]              <- 6
experimentData$RB2[experimentData$RB2 == "Mostly true of me"]                   <- 5
experimentData$RB2[experimentData$RB2 == "Slightly more true than untrue"]      <- 4
experimentData$RB2[experimentData$RB2 == "Slightly more untrue than true"]      <- 3
experimentData$RB2[experimentData$RB2 == "Mostly untrue of me"]                 <- 2
experimentData$RB2[experimentData$RB2 == "Completely untrue of me"]             <- 1
experimentData$RB2 <- as.numeric(experimentData$RB2)

experimentData$RB3 <- as.character(experimentData$RB3)
experimentData$RB3[experimentData$RB3 == "Describes me perfectly"]              <- 6
experimentData$RB3[experimentData$RB3 == "Mostly true of me"]                   <- 5
experimentData$RB3[experimentData$RB3 == "Slightly more true than untrue"]      <- 4
experimentData$RB3[experimentData$RB3 == "Slightly more untrue than true"]      <- 3
experimentData$RB3[experimentData$RB3 == "Mostly untrue of me"]                 <- 2
experimentData$RB3[experimentData$RB3 == "Completely untrue of me"]             <- 1
experimentData$RB3 <- as.numeric(experimentData$RB3)

experimentData$RB4 <- as.character(experimentData$RB4)
experimentData$RB4[experimentData$RB4 == "Describes me perfectly"]              <- 6
experimentData$RB4[experimentData$RB4 == "Mostly true of me"]                   <- 5
experimentData$RB4[experimentData$RB4 == "Slightly more true than untrue"]      <- 4
experimentData$RB4[experimentData$RB4 == "Slightly more untrue than true"]      <- 3
experimentData$RB4[experimentData$RB4 == "Mostly untrue of me"]                 <- 2
experimentData$RB4[experimentData$RB4 == "Completely untrue of me"]             <- 1
experimentData$RB4 <- as.numeric(experimentData$RB4)

# Generate reciprocity parameters for both players
# run factor analysis when the data is available
# for now, simply add variables and divide by number of variables added

experimentData$YAgent     <- (experimentData$RB1 + experimentData$RB2 + experimentData$RB3)/3
experimentData$YPrincipal <- (experimentData$RA1 + experimentData$RA2 + experimentData$RA3)/3

# rearrange columns
experimentData <- experimentData[c("Session", "Username", "Group", "Completed",
                                   "YAgent", "YPrincipal", "Productivity", "PrinProd", "IT", "screenChoice", 
                                   "Performance", "relProductivity", "Productive", "perfDifference", "eDiff",
                                   "PaymentB", "PaymentA", "PayB1", "PayA1", "PayB2", "PayA2", 
                                   "RB1", "RB2", "RB3", "RB4", "RA1", "RA2", "RA3", "RA4")]

# Get the data types right ------------------------------------------------

experimentData$IT         <- as.factor(experimentData$IT)
experimentData$Group      <- as.factor(experimentData$Group)
experimentData$Session    <- as.factor(experimentData$Session)
experimentData$Completed  <- as.logical(experimentData$Completed)
experimentData$Productive <- as.factor(experimentData$Productive)


# Generate re-formated Data Sets ------------------------------------------

# It is more meaningful if we have three instead of two histograms: one for Productivity and two for Performance since 
# the marterial incentives differ in the IT choice. 
# In order to generate the graph we would like to see, we need to modify the data frame a little and store it as 
# ggjoydata

# Count observations where IT==0 and IT==1
as.data.frame(table(experimentData$IT))[1,2]
as.data.frame(table(experimentData$IT))[2,2]

ggjoydata <- data.frame(c(rep("Stage 1: High", nrow(experimentData)), 
                          rep("Stage 2: Low", as.data.frame(table(experimentData$IT))[1,2]), 
                          rep("Stage 2: Medium", as.data.frame(table(experimentData$IT))[2,2])))
names(ggjoydata)[1] <- "Variable"

ggjoydata$screenSample  <- c(rep("Complete Sample", nrow(experimentData)),
                             rep("Low Subsample", as.data.frame(table(experimentData$IT))[1,2]),
                             rep("Medium Subsample", as.data.frame(table(experimentData$IT))[2,2]))

ggjoydata$Effort[ggjoydata$Variable=="Stage 1: High"]   <- experimentData$Productivity
ggjoydata$Effort[ggjoydata$Variable=="Stage 2: Low"]    <- experimentData$Performance[experimentData$IT==0]
ggjoydata$Effort[ggjoydata$Variable=="Stage 2: Medium"] <- experimentData$Performance[experimentData$IT==1]

ggjoydata$Productivity[ggjoydata$Variable=="Stage 2: Low"]    <- experimentData$Productivity[experimentData$IT==0] - .5
ggjoydata$Productivity[ggjoydata$Variable=="Stage 2: Medium"] <- experimentData$Productivity[experimentData$IT==1] - .5
ggjoydata$Productivity[ggjoydata$Productivity <= 0] <- 0
ggjoydata$Productivity[ggjoydata$Productivity > 0]  <- 1

ggjoydata$Productivity <- as.factor(ggjoydata$Productivity)


ggjoydata$screenChoice[ggjoydata$screenSample=="Complete Sample"] <- experimentData$screenChoice
ggjoydata$screenChoice[ggjoydata$screenSample=="Low Subsample"]   <- experimentData$screenChoice[experimentData$IT==0]
ggjoydata$screenChoice[ggjoydata$screenSample=="Medium Subsample"]  <- experimentData$screenChoice[experimentData$IT==1]

# Find and store medians if they should be included in some of the graphs
xm1  <- median(ggjoydata$Effort[ggjoydata$Variable == "Stage 1: High"])
xm2h <- median(ggjoydata$Effort[ggjoydata$Variable == "Stage 2: Medium"])
xm2l <- median(ggjoydata$Effort[ggjoydata$Variable == "Stage 2: Low"])



# Generate another ggjoydataset for the visualization of screenChoices
ggjoydata1 <- ggjoydata[ggjoydata$screenSample!="Complete Sample",]




# Count cases where screenChoice < maxScreens to create fisher test matrix
# the variable names are as follows: Hi/Lo indicates the principal's IT choice
# Bad/Good indicates whether the agent was productive (productivity higher than 0.5)

fewScreens <- NROW(experimentData$screenChoice[experimentData$screenChoice<maxScreens]) 
fewScreensHiBad <- NROW(experimentData$screenChoice[experimentData$screenChoice < maxScreens 
                                                 & experimentData$IT == 1 & experimentData$Productivity <= 1/2]) 
fewScreensLOBad <- NROW(experimentData$screenChoice[experimentData$screenChoice < maxScreens 
                                                 & experimentData$IT == 0 & experimentData$Productivity <= 1/2]) 

fewScreensHiGood <- NROW(experimentData$screenChoice[experimentData$screenChoice < maxScreens 
                                                 & experimentData$IT == 1 & experimentData$Productivity > 1/2]) 
fewScreensLOGood <- NROW(experimentData$screenChoice[experimentData$screenChoice < maxScreens 
                                                 & experimentData$IT == 0 & experimentData$Productivity > 1/2])

# Save data in a data frame such that one can print it later on
fishersData <- matrix(c(fewScreensHiBad, fewScreensLOBad, fewScreensHiGood, fewScreensLOGood), nrow = 2)
fishersData <- as.data.frame(fishersData)
fishersData[3,]   <- c(sum(fishersData$V1), sum(fishersData$V2))
fishersData$Total <- c(sum(fishersData[1,]), sum(fishersData[2,]), sum(fishersData[3,]))
row.names(fishersData) <- c("Semi-Strong Incentives", "Weak Incentives", "Total")
names(fishersData)[1]  <- "Unproductive"
names(fishersData)[2]  <- "Productive"



# Lets see how much the principals would have earned, if the second stage determined their earnings
# unproductive agent, high IT (wrong choice from agent's perspective)
PayHiBad <- mean(experimentData$PayA2[experimentData$IT == 1 & experimentData$Productive  == 0])
# unproductive agent, low IT (good choice from agent's perspective)
PayLoBad <- mean(experimentData$PayA2[experimentData$IT == 0 & experimentData$Productive  == 0])
# productive agent, high IT (good choice from agent's perspective)
PayHiGood <- mean(experimentData$PayA2[experimentData$IT == 1 & experimentData$Productive  == 1])
# productive agent, low IT (wrong choice from agent's perspective)
PayLoGood <- mean(experimentData$PayA2[experimentData$IT == 0 & experimentData$Productive  == 1])

# Save data in a data frame such that one can print it later on
PayData <- matrix(c(PayHiBad, PayLoBad, PayHiGood, PayLoGood), nrow = 2)
PayData <- as.data.frame(PayData)
row.names(PayData) <- c("Semi-Strong Incentives", "Weak Incentives")
names(PayData)[1]  <- "Unproductive"
names(PayData)[2]  <- "Productive"



# Generate trimmed experimentData df containing the most important variables for summary statistics
usefull <- c("Performance", "Productivity", "IT", "screenChoice")
summaryData <- experimentData[usefull]



# Label Data --------------------------------------------------------------

library(labelled)

var_label(experimentData$Session)       <- "Session identifier"
var_label(experimentData$Username)      <- "Agent's identifier"
var_label(experimentData$Group)         <- "Group identifier"
var_label(experimentData$Completed)     <- "Indicates whether group completed the experiment"
var_label(experimentData$Productivity)  <- "Agent's effort provision in Stage 1"
var_label(experimentData$PrinProd)      <- "Principal's effort provision in Stage 1"
var_label(experimentData$Performance)   <- "Agent's effort provision in Stage 2"
var_label(experimentData$relProductivity)<- "Agent's Productivity - 0.5"
var_label(experimentData$Productive)    <- "Indicates wheter Productivity >= 0.5"
var_label(experimentData$perfDifference)<- "Agent's Performance in Stage 2 - Agent's Productivity in Stage 1"
var_label(experimentData$eDiff)         <- "Difference between actual performance and rational prediction"
var_label(experimentData$IT)            <- "Indicates high likelihood with which agent's earnings are performance based"
var_label(experimentData$screenChoice)  <- "Agent's chosen workload"
var_label(experimentData$RB1)           <- "Agent's answer to first reciprocity question"
var_label(experimentData$RB2)           <- "Agent's answer to second reciprocity question"
var_label(experimentData$RB3)           <- "Agent's answer to third reciprocity question"
var_label(experimentData$RB4)           <- "Agent's answer to last reciprocity question"
var_label(experimentData$RA1)           <- "Principal's answer to first reciprocity question"
var_label(experimentData$RA2)           <- "Principal's answer to second reciprocity question"
var_label(experimentData$RA3)           <- "Principal's answer to third reciprocity question"
var_label(experimentData$RA4)           <- "Principal's answer to last reciprocity question"
var_label(experimentData$YPrincipal)    <- "Index of RA1-4"
var_label(experimentData$YAgent)        <- "Index of RB1-4"
var_label(experimentData$PayA1)         <- "Principals's potential earnings in in Stage 1"
var_label(experimentData$PayB1)         <- "Agent's potential earnings in in Stage 1"
var_label(experimentData$PayA2)         <- "Principals's potential earnings in in Stage 2"
var_label(experimentData$PayB2)         <- "Agent's potential earnings in in Stage 2"
var_label(experimentData$PaymentA)      <- "Principals's actual earnings"
var_label(experimentData$PaymentB)      <- "Agent's actual earnings"


# Write processed data file -----------------------------------------------
write.csv(experimentData, file = "02_ProcessedData/labeledExperimentData.csv")

