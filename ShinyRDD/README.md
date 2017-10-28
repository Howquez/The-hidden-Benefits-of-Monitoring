## Shiny App  

I programmed this app such that you can perform robustness checks of the Regression Discontinuity Design (RDD) on your own.
The app currently uses [simulated data](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/tree/master/Simulated_Data) and allows you to narrow down the sample, such that you can omit the data that is too far away from the threshold in question. In addition, the user interface gives you the posibility to set arbitrary *'placebo'* thresholds that should not have any meaining or impact.

As you have seen, the app referes to the [Figure](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/Figures/06_RDD.pdf) I am using for the data analysis.

You can either download the files and run them on your own computer or folow this link: https://roggenkamp.shinyapps.io/shiny_rdd/.

To run it on your own computer, you have to store both files in the same working directory (a folder I called `shiny_RDD`) and create a third file with the following commands:

```R
setwd("YOUR/DIRECTORY/shiny_RDD")
getwd()

# install-packages("shiny") you only have tun run this once
library(shiny)
runApp()
```
