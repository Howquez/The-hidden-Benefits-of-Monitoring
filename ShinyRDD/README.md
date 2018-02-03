## Shiny App  

I programmed this app such that you can perform robustness checks of the Regression Discontinuity Design (RDD) which I already plotted [here](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/Figures/06_RDD.pdf) on your own.
The app currently uses [simulated data](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/tree/master/Simulated_Data) and allows you to narrow the sample, such that you can omit the data that is too far away from the threshold in question. In addition, the user interface gives you the posibility to set arbitrary *'placebo'* thresholds that should not have any meaining or impact. Finally, the R scripts provided enable you to change the regression lines' smoothing methods (I provide two options: linear models "lm" as well as general additive models "gam"). Unfortunately, this feature does not work in the cloud.

You can either download the files and run them on your own computer or folow this link to run it in the cloud: https://roggenkamp.shinyapps.io/ShinyRDD/. Note that the gam-option does only work here.

To run it on your own computer, you have to store both files in the same working directory (a folder I called `shiny_RDD`) and create a third file with the following commands:

```R
setwd("YOUR/DIRECTORY/shiny_RDD")
getwd()

# install-packages("shiny") you only have tun run this once
library(shiny)
runApp()
```
You should now see a window running the app (and the `gam` smoothing option should work).
