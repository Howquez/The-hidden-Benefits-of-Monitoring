library(shiny)
library(ggplot2)
library(ggthemes)

ui <- fluidPage(
        # App title
        titlePanel("Regression Discontinuity Design", windowTitle = "RDD"),
        
        # Sidebar layout with input and output definitions
        sidebarLayout(
                
                # Sidebar to demonstrate various slider options
                sidebarPanel(
                        
                        # Help Text
                        helpText("To explore the data and to check the robustness of our RDD, I built this app where you
                                 can choose a random 'placebo threshold' or a 'discontinuity sample' by zooming in."),
                        
                        #Input: Choose an IT
                        selectInput(inputId = "IT",
                                    label = "Choose the Plot you want to modify",
                                    choices = c("High IT", "Low IT")),
                        
                        # Input: Simple integer interval
                        sliderInput(inputId = "threshold",
                                    label = "Choose a Threshold",
                                    value = 0.50, min = 0, max = 1),
                        
                        
                        # Input: Specification of range of data that is plotted
                        sliderInput(inputId = "range",
                                    label = "Specify a Discontinuity Sample",
                                    min = 0, max = 1,
                                    value = c(0.25, 0.75)),
                        
                        hr(),
                        helpText("")
                        ),
                # Main panel for displaying outputs
                mainPanel(
                        plotOutput("RDD1")
                )))
