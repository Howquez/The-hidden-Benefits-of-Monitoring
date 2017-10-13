# This Script repeats parts of the manipulation, the whole Analysis and Visualization of the other Scripts
# but uses a different sample. In particular, the data only considers the observations where the agent's
# sensitivity to reciprocity (YAgent) is above median.

# Globals -----------------------------------------------------------------

rm(list = ls())
setwd("/Users/howquez/Documents/002_UNI/UCPH/016_Master Thesis/05_Data")
maxScreens <- 25 # need to adjust this!

# Load Packages -----------------------------------------------------------
library(foreign)
library(VGAM)
library(censReg)
library(ggplot2)
library(ggthemes)
library(grid)
library(gridExtra)
# library(devtools)
# install_github("clauswilke/ggjoy")
library(ggjoy)
library(reshape2)
library(stargazer)



# Load Data ---------------------------------------------------------------

experimentData <- read.csv("02_ProcessedData/labeledExperimentData.csv", header=T)
experimentData <- experimentData[,2:(ncol(experimentData))]

# Sample Data -------------------------------------------------------------
experimentSub <- experimentData[experimentData$YAgent > median(experimentData$YAgent),]
rm(list=setdiff(ls(), c("experimentSub", "maxScreens")))

# Get the data types right ------------------------------------------------

experimentSub$IT         <- as.factor(experimentSub$IT)
experimentSub$Group      <- as.factor(experimentSub$Group)
experimentSub$Session    <- as.factor(experimentSub$Session)
experimentSub$Completed  <- as.logical(experimentSub$Completed)
experimentSub$Productive <- as.factor(experimentSub$Productive)

# Generate re-formated Data Sets --------------------------------------------

# It is more meaningful if we have three instead of two histograms: one for Productivity and two for Performance since 
# the marterial incentives differ in the IT choice. 
# In order to generate the graph we would like to see, we need to modify the data frame a little and store it as 
# ggjoydata

# Count observations where IT==0 and IT==1
as.data.frame(table(experimentSub$IT))[1,2]
as.data.frame(table(experimentSub$IT))[2,2]

ggjoydata <- data.frame(c(rep("Stage 1: High", nrow(experimentSub)), 
                          rep("Stage 2: Low", as.data.frame(table(experimentSub$IT))[1,2]), 
                          rep("Stage 2: Medium", as.data.frame(table(experimentSub$IT))[2,2])))
names(ggjoydata)[1] <- "Variable"

ggjoydata$screenSample  <- c(rep("Complete Sample", nrow(experimentSub)),
                             rep("Low Subsample", as.data.frame(table(experimentSub$IT))[1,2]),
                             rep("Medium Subsample", as.data.frame(table(experimentSub$IT))[2,2]))

ggjoydata$Effort[ggjoydata$Variable=="Stage 1: High"]   <- experimentSub$Productivity
ggjoydata$Effort[ggjoydata$Variable=="Stage 2: Low"]    <- experimentSub$Performance[experimentSub$IT==0]
ggjoydata$Effort[ggjoydata$Variable=="Stage 2: Medium"] <- experimentSub$Performance[experimentSub$IT==1]

ggjoydata$Productivity[ggjoydata$Variable=="Stage 2: Low"]    <- experimentSub$Productivity[experimentSub$IT==0] - .5
ggjoydata$Productivity[ggjoydata$Variable=="Stage 2: Medium"] <- experimentSub$Productivity[experimentSub$IT==1] - .5
ggjoydata$Productivity[ggjoydata$Productivity <= 0] <- 0
ggjoydata$Productivity[ggjoydata$Productivity > 0]  <- 1

ggjoydata$Productivity <- as.factor(ggjoydata$Productivity)


ggjoydata$screenChoice[ggjoydata$screenSample=="Complete Sample"] <- experimentSub$screenChoice
ggjoydata$screenChoice[ggjoydata$screenSample=="Low Subsample"]   <- experimentSub$screenChoice[experimentSub$IT==0]
ggjoydata$screenChoice[ggjoydata$screenSample=="Medium Subsample"]  <- experimentSub$screenChoice[experimentSub$IT==1]

# Find and store medians if they should be included in some of the graphs
xm1  <- median(ggjoydata$Effort[ggjoydata$Variable == "Stage 1: High"])
xm2h <- median(ggjoydata$Effort[ggjoydata$Variable == "Stage 2: Medium"])
xm2l <- median(ggjoydata$Effort[ggjoydata$Variable == "Stage 2: Low"])

# Generate another ggjoydataset for the visualization of screenChoices
ggjoydata1 <- ggjoydata[ggjoydata$screenSample!="Complete Sample",]

# Count cases where screenChoice < maxScreens to create fisher test matrix
fewScreens <- NROW(experimentSub$screenChoice[experimentSub$screenChoice<maxScreens]) 
fewScreensHiBad <- NROW(experimentSub$screenChoice[experimentSub$screenChoice < maxScreens 
                                                    & experimentSub$IT == 1 & experimentSub$Productivity <= 1/2]) 
fewScreensLOBad <- NROW(experimentSub$screenChoice[experimentSub$screenChoice < maxScreens 
                                                    & experimentSub$IT == 0 & experimentSub$Productivity <= 1/2]) 

fewScreensHiGood <- NROW(experimentSub$screenChoice[experimentSub$screenChoice < maxScreens 
                                                     & experimentSub$IT == 1 & experimentSub$Productivity > 1/2]) 
fewScreensLOGood <- NROW(experimentSub$screenChoice[experimentSub$screenChoice < maxScreens 
                                                     & experimentSub$IT == 0 & experimentSub$Productivity > 1/2])

fishersData <- matrix(c(fewScreensHiBad, fewScreensLOBad, fewScreensHiGood, fewScreensLOGood), nrow = 2)
fishersData <- as.data.frame(fishersData)
fishersData[3,]   <- c(sum(fishersData$V1), sum(fishersData$V2))
fishersData$Total <- c(sum(fishersData[1,]), sum(fishersData[2,]), sum(fishersData[3,]))
row.names(fishersData) <- c("Semi-Strong Incentives", "Weak Incentives", "Total")
names(fishersData)[1]  <- "Unproductive"
names(fishersData)[2]  <- "Productive"

# Generate trimmed experimentSub df containing the most important variables for summary statistics
usefull <- c("Performance", "Productivity", "IT", "screenChoice")
summaryData <- experimentSub[usefull]

# OLS ---------------------------------------------------------------------
# In what follows, I'll more or less run the same three specifications over and over again:
# I'll either estimate the performance or the agent's workload and start with the Productivity as 
# the only independent variable. I'll then add IT and its interaction term with productivity and 
# subseqently, the principal's productivity. Afterward, I repeat these specifications but add sessions effects.
# I finally do the same thing running censored regressions instead of OLS.

# estimate the performance
ROLS1   <- lm(Performance ~ Productivity, data=experimentSub)
ROLS2   <- lm(Performance ~ IT + Productivity + IT*Productivity,  data=experimentSub)
ROLS3   <- lm(Performance ~ IT + Productivity + IT*Productivity + PrinProd,  data=experimentSub)
# estimate the agent's workload
ROLS6   <- lm(screenChoice ~ Productivity, data=experimentSub)
ROLS7   <- lm(screenChoice ~ IT + Productivity + IT*Productivity,  data=experimentSub)
ROLS8   <- lm(screenChoice ~ IT + Productivity + IT*Productivity + PrinProd,  data=experimentSub)


# Add fixed effects/session effects to estimate both outcome variables
#experimentSub$Session <- rep(c(1:3), 50) # the simulated data consists of one session
RFEOLS1   <- lm(Performance ~ Productivity + factor(Session),  data=experimentSub)
RFEOLS2   <- lm(Performance ~ IT + Productivity + IT*Productivity + factor(Session),  data=experimentSub)
RFEOLS3   <- lm(Performance ~ IT + Productivity + IT*Productivity + PrinProd + factor(Session),  data=experimentSub)
#
RFEOLS6   <- lm(screenChoice ~ Productivity + factor(Session), data=experimentSub)
RFEOLS7   <- lm(screenChoice ~ IT + Productivity + IT*Productivity + factor(Session),
               data=experimentSub)
RFEOLS8   <- lm(screenChoice ~ IT + Productivity + IT*Productivity + PrinProd + factor(Session),
               data=experimentSub)


# Censored Regressions ----------------------------------------------------
# The two outcome variables are censored by design. The Performance can neither be negative nor higher than 1
# because it is not possible to click on more than 100% of the boxes that are displayed. Likewise,
# the workload cannot be lower than 1 (a boundary of 0 was not possible to program) and not higher than
# a maximum we defined as maxScreens. Even though the models are called TobitX, the specifications here
# consider that the data is left- AND right-censored. I therefore use the censreg package and follow the
# same procedure as above.

# estimate the performance
RTobit1 <- censReg(Performance ~ Productivity, left = 0, right = 1, data = experimentSub)
RTobit2 <- censReg(Performance ~ IT + Productivity + IT*Productivity, left = 0, right = 1, data = experimentSub)
RTobit3 <- censReg(Performance ~ IT + Productivity + IT*Productivity + PrinProd, 
                  left = 0, right = 1, data = experimentSub)
# estimate the agent's workload
RTobit6 <- censReg(screenChoice ~ Productivity, left = 1, right = maxScreens, data = experimentSub)
RTobit7 <- censReg(screenChoice ~ IT + Productivity + IT*Productivity, left = 1, right = maxScreens, data = experimentSub)
RTobit8 <- censReg(screenChoice ~ IT + Productivity + IT*Productivity + PrinProd, 
                  left = 1, right = maxScreens, data = experimentSub)

# Add fixed effects/session effects to estimate both outcome variables
RFETobit1 <- censReg(Performance ~ Productivity + factor(Session), left = 0, right = 1, 
                    data = experimentSub)
RFETobit2 <- censReg(Performance ~ IT + Productivity + IT*Productivity + factor(Session), left = 0, right = 1, 
                    data = experimentSub)
RFETobit3 <- censReg(Performance ~ IT + Productivity + IT*Productivity + PrinProd + factor(Session), 
                    left = 0, right = 1, data = experimentSub)
#
RFETobit6 <- censReg(screenChoice ~ Productivity + factor(Session), left = 1, right = maxScreens,
                    data = experimentSub)
RFETobit7 <- censReg(screenChoice ~ IT + Productivity + IT*Productivity + factor(Session), left = 1, right = maxScreens,
                    data = experimentSub)
RFETobit8 <- censReg(screenChoice ~ IT + Productivity + IT*Productivity + PrinProd + factor(Session), 
                    left = 1, right = maxScreens, data = experimentSub)

# Run fisher’s exact test -------------------------------------------------
# Fisher test for choosing low screenChoice contingent on IT and Productivity.
# Because I do not know how many instances each cell will have, I chose to run 
# fisher's exact test because few cases suffice.

# The matrix looks as follows
matrix(c("HiBad", "LOBad", "HiGood", "LOGood"), nrow =2)

fisher.test((fishersData[1:2,1:2]))

# Graphs ------------------------------------------------------------------

# Style
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

# Create PDF with Regression lines
pdf("04_Figures/RS1_Regression.pdf",width=6.5,height=5)

ggplot(experimentSub, aes(x=Productivity, y=Performance, color=IT, alpha=IT)) +
        geom_point() +
        ggplotStyle +
        geom_smooth(method=lm, aes(fill=IT), alpha = 1/5) +
        labs(x = "Productivity in Stage 1", y = "Performance in Stage 2", col="Incentives") +
        geom_hline(yintercept = 0, alpha= 1/2) +
        geom_vline(xintercept = 0.5, alpha= 1/2, lty = 2) +
        # geom_hline(yintercept = 1, alpha= 1/2) +
        # geom_segment(x = 0.5, y = 0, xend = 0.5, yend = 1, size=1/2, colour= "gray50", inherit.aes = T) +
        #geom_abline(intercept = 0, slope = 1, alpha = 1/2, lty = 2) +
        geom_abline(intercept = 0, slope = 0.75, col = colMe,  alpha = 1/2, lty = 2) +
        geom_abline(intercept = 0, slope = 0.25, col = colLo, alpha = 3/4, lty = 2) +
        scale_x_continuous(limits=c(0, 1)) +
        scale_y_continuous(limits=c(0, 1)) +
        scale_alpha_manual(values=c(1/3, 1/3)) +
        scale_colour_manual(labels = c("Weak", "Semi-Strong"), values = c(colLo, colMe)) + 
        scale_fill_manual(labels = c("Weak", "Semi-Strong"), values = c(colLo, colMe)) + 
        guides(fill=FALSE, shape= FALSE, alpha= FALSE, col = guide_legend(reverse=TRUE)) 

# ggplot(experimentSub, aes(x = Productivity, y = eDiff, color = IT, fill = IT)) +
#         ggplotStyle + 
#         geom_point() +
#         labs(x = "Productivity in Stage 1", y = "Deviation from Rational Behavior", 
#              col="Incentives") +
#         geom_segment(aes(x = Productivity, xend = Productivity, y = 0, yend = eDiff), alpha = 3/5) +
#         geom_hline(yintercept = 0, alpha= 1/2) +
#         geom_vline(xintercept = 0.5, alpha= 1/2, lty = 2) +
#         scale_alpha_manual(values=c(1/3, 1/3)) +
#         scale_x_continuous(limits=c(0, 1)) +
#         scale_colour_manual(labels = c("Weak", "Semi-Strong"), values = c(colLo, colMe)) + 
#         scale_fill_manual(labels = c("Weak", "Semi-Strong"), values = c(colLo, colMe)) +
#         guides(fill=FALSE, shape= FALSE, alpha= FALSE, col = guide_legend(reverse=TRUE))

dev.off()                


# Create PDF with different histogram drafts
# pdf("04_Figures/RS2_Histograms.pdf",width=6.5,height=5)
# 
# ggplot(ggjoydata, aes(x = Effort, y = Variable, fill = Variable)) + 
#         ggplotStyle +
#         geom_joy(bandwidth = 0.05, alpha = 1, scale = 1.5) +
#         # geom_vline(xintercept = median(ggjoydata$Effort[ggjoydata$Variable == "Stage 1: High"]), color="#2B8FB7") +
#         # geom_vline(xintercept = median(ggjoydata$Effort[ggjoydata$Variable == "Stage 2: Medium"]), color="#EA4E6C") +
#         # geom_vline(xintercept = median(ggjoydata$Effort[ggjoydata$Variable == "Stage 2: Low"]), color="#EDE667") +
#         scale_fill_manual(values = c(colHi, colLo, colMe)) +
#         scale_x_continuous(breaks = seq(0, 1, 0.25)) +
#         xlab("Effort Provision") +
#         ylab("Material Incentives") +
#         guides(fill=FALSE) 
# 
# ggplot(ggjoydata, aes(x=Effort, fill=Variable)) +
#         ggplotStyle +
#         geom_bar(aes(y = (..count..)/sum(..count..))) +
#         scale_y_continuous(breaks = seq(0, 100, 2.5)) +
#         scale_x_continuous(breaks = seq(0, 1, 0.1)) +
#         geom_histogram(binwidth=0.01, alpha = 1) +
#         scale_fill_manual(values = c(colHi, colLo, colMe)) +
#         facet_grid(Variable~.) + 
#         geom_hline(yintercept = 0, alpha= 1/2) +
#         xlab("Effort Provision") +
#         ylab("Percent") +
#         guides(fill=FALSE)
# 
# dev.off() 


# Create PDF with different histogram drafts
pdf("04_Figures/RS3_Histogram.pdf",width=6.5,height=5)

# ggplot(ggjoydata1, aes(x=screenChoice, fill=screenSample)) +
#         ggplotStyle +
#         geom_bar(aes(y = (..count..)/sum(..count..))) +
#         scale_y_continuous(breaks = seq(0, 100, 10)) +
#         scale_x_continuous(breaks = c(seq(0, maxScreens, 2))) +
#         geom_histogram(binwidth=1, alpha = 1) +
#         scale_fill_manual(values = c(colLo, colMe)) +
#         facet_grid(screenSample~.) +
#         geom_hline(yintercept = 0, alpha= 1/2) +
#         ylab("Percent") +
#         guides(fill=FALSE)


p1 <- ggplot(subset(ggjoydata1, screenSample == "Medium Subsample"), aes(x = screenChoice, alpha = Productivity)) +
        geom_histogram(fill = colMe, binwidth = 1) +
        ggplotStyle +
        geom_hline(yintercept = 0, alpha= 1/2) +
        xlab("Semi-Strong Incentives") +
        scale_alpha_manual(labels = c("Low", "High"), values = c(.5, 1)) + 
        scale_x_continuous(expand = c(0, 0), limits = c(0, maxScreens + 1), 
                           breaks = scales::pretty_breaks(n = maxScreens/2))

p2 <- ggplot(subset(ggjoydata1, screenSample == "Low Subsample"), aes(x = screenChoice, alpha = Productivity)) +
        geom_histogram(fill = colLo, binwidth = 1) +
        ggplotStyle +
        geom_hline(yintercept = 0, alpha= 1/2) +
        xlab("Low Incentives") +
        scale_alpha_manual(labels = c("Low", "High"), values = c(.5, 1)) +
        scale_x_continuous(expand = c(0, 0), limits = c(0, maxScreens + 1), 
                           breaks = scales::pretty_breaks(n = maxScreens/2)) 

grid.arrange(p1,p2, top = textGrob("Workload", gp=gpar(fontsize = 8, fontfamily="Courier")))
dev.off() 

# p3 <- ggplot(subset(experimentSub, IT == 1), aes(x = Productivity, y = eDiff)) +
#         ggplotStyle +
#         geom_point(color = colMe) +
#         labs(x = "Semi-Strong Incentives", y = "",
#              col="Likelihood") +
#         geom_segment(aes(x = Productivity, xend = Productivity, y = 0, yend = eDiff), color = colMe, alpha = 3/5) +
#         geom_hline(yintercept = 0, alpha= 1/2) +
#         geom_vline(xintercept = 0.5, alpha= 1/2, lty = 2) +
#         scale_x_continuous(expand = c(0, 0), limits = c(-0.01,  1.01)) +
#         guides(col = FALSE, fill = FALSE)
# 
# p4 <- ggplot(subset(experimentSub, IT == 0), aes(x = Productivity, y = eDiff)) +
#         ggplotStyle +
#         geom_point(color = colLo) +
#         labs(x = "Weak Incentives", y = "",
#              col="Likelihood") +
#         geom_segment(aes(x = Productivity, xend = Productivity, y = 0, yend = eDiff), color = colLo, alpha = 3/5) +
#         geom_hline(yintercept = 0, alpha= 1/2) +
#         geom_vline(xintercept = 0.5, alpha= 1/2, lty = 2) +
#         scale_x_continuous(expand = c(0, 0), limits = c(-0.01, 1.01)) +
#         guides(col = FALSE, fill = FALSE)
# 
# # Create PDF with Difference Figures
# pdf("04_Figures/RS4_Differences.pdf",width=6.5,height=5)
# grid.arrange(p3, p4, top = textGrob("Productivity in Stage 1", gp=gpar(fontsize = 8, fontfamily = "Courier")),
#              left = textGrob("Deviation from Predicted Rational Behavior", rot = 90, vjust = 1,
#                              gp = gpar(fontsize = 8, fontfamily = "Courier")))
# dev.off()


# Regression Discontinuity Design

RDD1 <- ggplot(subset(experimentSub, IT == 1), aes(x = Productivity, y = Performance, colour = colMe)) +
        geom_point(alpha = 1/3) +
        ggplotStyle +
        geom_smooth(method=lm, aes(fill=Productive), alpha = 1/5) +
        labs(x = "Semi-Strong Incentives", y = "", col="Incentives") +
        geom_hline(yintercept = 0, alpha= 1/2) +
        geom_vline(xintercept = 0.5, alpha= 1/2, lty = 2) +
        scale_x_continuous(limits=c(0, 1)) +
        scale_y_continuous(limits=c(0, 1)) +
        scale_alpha_manual(values=c(1/3, 1/3)) +
        scale_colour_manual(labels = c("Weak", "Semi-Strong"), values = c(colMe, colMe)) + 
        scale_fill_manual(labels = c("Weak", "Semi-Strong"), values = c(colMe, colMe)) + 
        guides(fill=FALSE, shape= FALSE, alpha= FALSE, col = FALSE)

RDD2 <- ggplot(subset(experimentSub, IT == 0), aes(x = Productivity, y = Performance, colour = colLo)) +
        geom_point(alpha = 1/3) +
        ggplotStyle +
        geom_smooth(method=lm, aes(fill=Productive), alpha = 1/5) +
        labs(x = "Weak Incentives", y = "", col="Incentives") +
        geom_hline(yintercept = 0, alpha= 1/2) +
        geom_vline(xintercept = 0.5, alpha= 1/2, lty = 2) +
        scale_x_continuous(limits=c(0, 1)) +
        scale_y_continuous(limits=c(0, 1)) +
        scale_alpha_manual(values=c(1/3, 1/3)) +
        scale_colour_manual(labels = c("Weak", "Semi-Strong"), values = c(colLo, colLo)) + 
        scale_fill_manual(labels = c("Weak", "Semi-Strong"), values = c(colLo, colLo)) + 
        guides(fill=FALSE, shape= FALSE, alpha= FALSE, col = FALSE)

# Create PDF with RDD Plots
pdf("04_Figures/RS6_RDD.pdf",width=5,height=6.5)
grid.arrange(RDD1, RDD2, top = textGrob("Productivity in Stage 1", gp=gpar(fontsize = 8, fontfamily = "Courier")),
             left = textGrob("Performance in Stage 2", rot = 90, vjust = 1,
                             gp = gpar(fontsize = 8, fontfamily = "Courier")))
dev.off() 




# Tables ------------------------------------------------------------------

# Summary Statistics
stargazer(summaryData, type = "html", flip = TRUE)


# Regression Outputs for Performance
writeLines(capture.output(stargazer(OLS1, OLS2, Tobit1, Tobit2,
                                    intercept.bottom = FALSE,
                                    keep.stat = c("adj.rsq", "bic", "n" ),
                                    omit = "logSigma",
                                    dep.var.caption = "Performance in Stage 2",
                                    dep.var.labels = "measured as the percentage of boxes clicked away",
                                    title = "Agents' Performance in Stage 2", 
                                    label = "table:Performance",
                                    notes = c("ABC",
                                              "DEF")
)), 
"05_Tables/RS1_Performance.tex")

writeLines(capture.output(stargazer(FEOLS1, FEOLS2, FETobit1, FETobit2,
                                    intercept.bottom = FALSE,
                                    keep.stat = c("adj.rsq", "bic", "n" ),
                                    omit = "logSigma",
                                    dep.var.caption = "Performance in Stage 2",
                                    dep.var.labels = "measured as the percentage of boxes clicked away",
                                    title = "Agents' Performance in Stage 2", 
                                    label = "table:Performance",
                                    notes = c("ABC",
                                              "DEF")
)), 
"05_Tables/RS2_PerformanceFE.tex")

stargazer(OLS1, OLS2, Tobit1, Tobit2)

# Regression Outputs for screenChoice
writeLines(capture.output(stargazer(OLS6, OLS7, Tobit6, Tobit7,
                                    intercept.bottom = FALSE,
                                    keep.stat = c("adj.rsq", "bic", "n" ),
                                    omit = "logSigma",
                                    title = "Workloads chosen by the Agents in Stage 2", 
                                    label = "table:screenChoice2",
                                    notes = c("ABC",
                                              "DEF")
)), 
"05_Tables/RS3_screenChoice.tex")

writeLines(capture.output(stargazer(FEOLS6, FEOLS7, FETobit6, FETobit7,
                                    intercept.bottom = FALSE,
                                    keep.stat = c("adj.rsq", "bic", "n" ),
                                    omit = "logSigma",
                                    title = "Workloads chosen by the Agents in Stage 2", 
                                    label = "table:screenChoice2",
                                    notes = c("ABC",
                                              "DEF")
)), 
"05_Tables/RS4_screenChoiceFE.tex")

stargazer(OLS6, OLS7, Tobit6, Tobit7)


# Contingency Table to support Fisher Test
writeLines(capture.output(stargazer(fishersData, 
                                    summary=FALSE, 
                                    title = "Occurrences of non-maximal workload decisions", 
                                    label = "table:screenChoice1",
                                    notes = c("Non-maximal workload decisions are measured as screenChoice smaller than
                                              25.",
                                              "Threshold of 0.5 used to distinguish between high and low
                                              productivity.")
                                    )), 
           "05_Tables/RS5_WorkloadFischer.tex")



