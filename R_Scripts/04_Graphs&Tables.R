
# Load Packages -----------------------------------------------------------
library(ggplot2)
library(ggthemes)
library(grid)
library(gridExtra)
# library(devtools)
# install_github("clauswilke/ggjoy")
library(ggjoy)
library(reshape2)
library(stargazer)


# Style -------------------------------------------------------------------

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

# Graphical Exploration ---------------------------------------------------

# Create PDF with Regression lines
pdf("04_Figures/01_Regression.pdf",width=6.5,height=5)

ggplot(experimentData, aes(x=Productivity, y=Performance, color=IT, alpha=IT)) +
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

# ggplot(experimentData, aes(x = Productivity, y = eDiff, color = IT, fill = IT)) +
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
# pdf("04_Figures/02_Histograms.pdf",width=6.5,height=5)
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
pdf("04_Figures/03_Histogram.pdf",width=6.5,height=5)

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

# p3 <- ggplot(subset(experimentData, IT == 1), aes(x = Productivity, y = eDiff)) +
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
# p4 <- ggplot(subset(experimentData, IT == 0), aes(x = Productivity, y = eDiff)) +
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
# pdf("04_Figures/04_Differences.pdf",width=6.5,height=5)
# grid.arrange(p3, p4, top = textGrob("Productivity in Stage 1", gp=gpar(fontsize = 8, fontfamily = "Courier")),
#              left = textGrob("Deviation from Predicted Rational Behavior", rot = 90, vjust = 1,
#                              gp = gpar(fontsize = 8, fontfamily = "Courier")))
# dev.off()


# Regression Discontinuity Design

RDD1 <- ggplot(subset(experimentData, IT == 1), aes(x = Productivity, y = Performance, colour = colMe)) +
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

RDD2 <- ggplot(subset(experimentData, IT == 0), aes(x = Productivity, y = Performance, colour = colLo)) +
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
pdf("04_Figures/06_RDD.pdf",width=5,height=6.5)
grid.arrange(RDD1, RDD2, top = textGrob("Productivity in Stage 1", gp=gpar(fontsize = 8, fontfamily = "Courier")),
             left = textGrob("Performance in Stage 2", rot = 90, vjust = 1,
                             gp = gpar(fontsize = 8, fontfamily = "Courier")))
dev.off() 


# Plot the Principals' choices

p5 <- ggplot(subset(experimentData, IT == 0), aes(x = IT, alpha = Productive)) +
        geom_bar(fill = colLo, aes(y = (..count..)/sum(..count..))) +
        ggplotStyle +
        geom_hline(yintercept = 0, alpha= 1/2) +
        xlab("") +
        ylab("") +
        scale_y_continuous(labels = scales::percent) +
        scale_alpha_manual(name = "Productivity", labels = c("Low", "High"), values = c(.5, 1)) +
        scale_x_discrete(labels = "Weak") + 
        theme(legend.position="top")

p6 <- ggplot(subset(experimentData, IT == 1), aes(x = IT, alpha = Productive)) +
        geom_bar(fill = colMe, aes(y = (..count..)/sum(..count..))) +
        ggplotStyle +
        geom_hline(yintercept = 0, alpha= 1/2) +
        xlab("") +
        ylab("") +
        scale_y_continuous(labels = scales::percent) +
        scale_alpha_manual(name = "Productivity", labels = c("Low", "High"), values = c(.5, 1)) +
        scale_x_discrete(labels = "Semi-Strong") + 
        theme(legend.position="top")

pdf("04_Figures/07_Principal.pdf",width=5,height=6.5)
grid.arrange(p5, p6, ncol=2, bottom = textGrob("Incentives", gp=gpar(fontsize = 8, fontfamily = "Courier")),
             left = textGrob("Percentage", rot = 90, vjust = 1,
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
           "05_Tables/01_Performance.tex")

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
           "05_Tables/02_PerformanceFE.tex")

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
           "05_Tables/03_screenChoice.tex")

writeLines(capture.output(stargazer(FEOLS6, FEOLS7, FETobit6, FETobit7,
                                    intercept.bottom = FALSE,
                                    keep.stat = c("adj.rsq", "bic", "n" ),
                                    omit = "logSigma",
                                    title = "Workloads chosen by the Agents in Stage 2", 
                                    label = "table:screenChoice2",
                                    notes = c("ABC",
                                              "DEF")
                                    )), 
           "05_Tables/04_screenChoiceFE.tex")

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
           "05_Tables/05_WorkloadFischer.tex")


