# Load Data ---------------------------------------------------------------

setwd("/Users/howquez/Documents/002_UNI/UCPH/016_Master Thesis/05_Data")

# load it
experimentData <- read.csv("02_ProcessedData/experimentData.csv", header=T)
experimentData <- experimentData[,2:(ncol(experimentData))]

# and delete everything else
rm(list=setdiff(ls(), "experimentData"))

# before viewing it
# View(experimentData)

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
experimentData$IT[experimentData$IT <= 50] <- 0 # low  IT or "Likelihood" is coded as zero
experimentData$IT[experimentData$IT >  50] <- 1 # high IT or "Likelihood" is coded as one

experimentData$Productivity <- experimentData$Productivity / 100
experimentData$Performance <- experimentData$Performance / 100

# Generate variables
sampleSize  <- NROW(experimentData)
maxScreens  <- 10
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
fewScreens <- NROW(experimentData$screenChoice[experimentData$screenChoice<maxScreens]) 
fewScreensHiBad <- NROW(experimentData$screenChoice[experimentData$screenChoice < maxScreens 
                                                 & experimentData$IT == 1 & experimentData$Productivity <= 1/2]) 
fewScreensLOBad <- NROW(experimentData$screenChoice[experimentData$screenChoice < maxScreens 
                                                 & experimentData$IT == 0 & experimentData$Productivity <= 1/2]) 

fewScreensHiGood <- NROW(experimentData$screenChoice[experimentData$screenChoice < maxScreens 
                                                 & experimentData$IT == 1 & experimentData$Productivity > 1/2]) 
fewScreensLOGood <- NROW(experimentData$screenChoice[experimentData$screenChoice < maxScreens 
                                                 & experimentData$IT == 0 & experimentData$Productivity > 1/2])

fishersData <- matrix(c(fewScreensHiBad, fewScreensLOBad, fewScreensHiGood, fewScreensLOGood), nrow = 2)
fishersData <- as.data.frame(fishersData)
fishersData[3,]   <- c(sum(fishersData$V1), sum(fishersData$V2))
fishersData$Total <- c(sum(fishersData[1,]), sum(fishersData[2,]), sum(fishersData[3,]))
row.names(fishersData) <- c("Semi-Strong Incentives", "Weak Incentives", "Total")
names(fishersData)[1]  <- "Unproductive"
names(fishersData)[2]  <- "Productive"

# Generate trimmed experimentData df containing the most important variables for summary statistics
usefull <- c("Performance", "Productivity", "IT", "screenChoice")
summaryData <- experimentData[usefull]




