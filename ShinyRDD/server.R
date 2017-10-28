# Packages ----------------------------------------------------------------
library(curl)
library(shiny)
library(ggplot2)
library(ggthemes)

# Read & Manipulate Data --------------------------------------------------

# load Data
experimentData <- read.csv( curl("https://raw.githubusercontent.com/Howquez/The-hidden-Benefits-of-Monitoring/master/Simulated_Data/simulatedExperimentData.csv") )

# experimentData <- read.csv("/Users/howquez/Documents/002_UNI/UCPH/016_Master Thesis/05_Data/02_ProcessedData/experimentData.csv", header=T)
experimentData <- experimentData[,2:(ncol(experimentData))]

# Restrict sample to complete observations
experimentData <- na.omit(experimentData)

# Rename key variables
names(experimentData)[names(experimentData)=="score2"]          <- "Productivity"
names(experimentData)[names(experimentData)=="score"]           <- "Performance"
names(experimentData)[names(experimentData)=="PersonAProb"]     <- "IT"

# change how IT as well a Productivity and Performance are encoded
experimentData$IT <- as.integer(experimentData$IT)
experimentData$IT[experimentData$IT <= 50] <- 0 # low  IT or "Likelihood" is coded as zero
experimentData$IT[experimentData$IT >  50] <- 1 # high IT or "Likelihood" is coded as one

experimentData$Productivity <- experimentData$Productivity / 100
experimentData$Performance <- experimentData$Performance / 100

# Generate variables
sampleSize  <- NROW(experimentData)
maxScreens  <- 10 # Need to adjust this!
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


# rearrange columns
experimentData <- experimentData[c("Session", "Username", "Group", "Completed",
                                   "Productivity", "PrinProd", "IT", "screenChoice", 
                                   "Performance", "relProductivity", "Productive", "perfDifference", "eDiff"
)]

experimentData$IT         <- as.factor(experimentData$IT)
experimentData$Group      <- as.factor(experimentData$Group)
experimentData$Session    <- as.factor(experimentData$Session)
experimentData$Completed  <- as.logical(experimentData$Completed)
experimentData$Productive <- as.factor(experimentData$Productive)

# ggplot style ------------------------------------------------------------
ggplotStyle <- style <-theme_minimal() +
        theme(panel.grid.minor = element_line(colour = F)) +
        theme(text=element_text(size=8, family="Courier")) +
        theme(
                axis.title.x = element_text(margin = unit(c(7, 0, 0, 0), "mm")),
                axis.title.y = element_text(margin = unit(c(0, 7, 0, 0), "mm"))
        )
colHi  <- "#BE253E" 
colMe  <- "#F25D60" 
colLo  <- "#FECA95"

# server ------------------------------------------------------------------


function(input,output){
        
        output$RDD1<-renderPlot({
                if(input$IT== "High IT")
                        ggplot(subset(experimentData, IT == 1 & Productivity >= input$range[1] & Productivity <= input$range[2]),
                               aes(x = Productivity, y = Performance, colour = colMe)) +
                        geom_point(alpha = 1/3) +
                        ggplotStyle +
                        geom_smooth(data = subset(experimentData, 
                                                  Productivity >= input$threshold & Productivity <= input$range[2] & IT == 1),
                                    method=lm, alpha = 1/5, fill = colMe) +
                        geom_smooth(data = subset(experimentData, 
                                                  Productivity <  input$threshold & Productivity >= input$range[1] & IT == 1), 
                                    method=lm, alpha = 1/5, fill = colMe) +
                        labs(title = "High IT", x = "Productivity in Stage 1", y = "Performance in Stage 2", col="Incentives") +
                        geom_hline(yintercept = 0, alpha= 1/2) +
                        geom_vline(xintercept = input$threshold, alpha= 1/2, lty = 2) +
                        scale_x_continuous(limits=c(0, 1)) +
                        scale_y_continuous(limits=c(0, 1)) +
                        scale_alpha_manual(values=c(1/3, 1/3)) +
                        scale_colour_manual(labels = c("Weak", "Semi-Strong"), values = c(colMe, colMe)) + 
                        scale_fill_manual(labels = c("Weak", "Semi-Strong"), values = c(colMe, colMe)) + 
                        guides(fill=FALSE, shape= FALSE, alpha= FALSE, col = FALSE)
                else
                        ggplot(subset(experimentData, IT == 0 & Productivity >= input$range[1] & Productivity <= input$range[2]),
                               aes(x = Productivity, y = Performance, colour = colLo)) +
                        geom_point(alpha = 1/3) +
                        ggplotStyle +
                        geom_smooth(data = subset(experimentData, 
                                                  Productivity >= input$threshold & Productivity <= input$range[2] & IT == 0),
                                    method=lm, alpha = 1/5, fill = colLo) +
                        geom_smooth(data = subset(experimentData, 
                                                  Productivity <  input$threshold & Productivity >= input$range[1] & IT == 0), 
                                    method=lm, alpha = 1/5, fill = colLo) +
                        labs(title = "Low IT", x = "Productivity in Stage 1", y = "Performance in Stage 2", col="Incentives") +
                        geom_hline(yintercept = 0, alpha= 1/2) +
                        geom_vline(xintercept = input$threshold, alpha= 1/2, lty = 2) +
                        scale_x_continuous(limits=c(0, 1)) +
                        scale_y_continuous(limits=c(0, 1)) +
                        scale_alpha_manual(values=c(1/3, 1/3)) +
                        scale_colour_manual(labels = c("Weak", "Semi-Strong"), values = c(colLo, colLo)) + 
                        scale_fill_manual(labels = c("Weak", "Semi-Strong"), values = c(colLo, colLo)) + 
                        guides(fill=FALSE, shape= FALSE, alpha= FALSE, col = FALSE)
                
        })
        
        output$RDD2<-renderPlot({ggplot(subset(experimentData, IT == 0 & Productivity >= input$range[1] & Productivity <= input$range[2]), aes(x = Productivity, y = Performance, colour = colLo)) +
                        geom_point(alpha = 1/3) +
                        ggplotStyle +
                        geom_smooth(data = subset(experimentData, 
                                                  Productivity >= input$threshold & Productivity <= input$range[2] & IT == 0),
                                    method=lm, alpha = 1/5, fill = colLo) +
                        geom_smooth(data = subset(experimentData, 
                                                  Productivity <  input$threshold & Productivity >= input$range[1] & IT == 0), 
                                    method=lm, alpha = 1/5, fill = colLo) +
                        labs(x = "Semi-Strong Incentives", y = "", col="Incentives") +
                        geom_hline(yintercept = 0, alpha= 1/2) +
                        geom_vline(xintercept = input$threshold, alpha= 1/2, lty = 2) +
                        scale_x_continuous(limits=c(0, 1)) +
                        scale_y_continuous(limits=c(0, 1)) +
                        scale_alpha_manual(values=c(1/3, 1/3)) +
                        scale_colour_manual(labels = c("Weak", "Semi-Strong"), values = c(colLo, colLo)) + 
                        scale_fill_manual(labels = c("Weak", "Semi-Strong"), values = c(colLo, colLo)) + 
                        guides(fill=FALSE, shape= FALSE, alpha= FALSE, col = FALSE)
        })
        
}
