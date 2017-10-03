
# Load Packages -----------------------------------------------------------

library(VGAM)
library(censReg)


# Analysis ----------------------------------------------------------------
names(experimentData)
#experimentData$Session <- rep(c(1:3), 50)
# Multiple Linear Regression Example 
OLS1   <- lm(Performance ~ Productivity, data=experimentData)
OLS2   <- lm(Performance ~ IT + Productivity + IT*Productivity,  data=experimentData)
Tobit1 <- censReg(Performance ~ Productivity, left = 0, right = 1, data = experimentData)
Tobit2 <- censReg(Performance ~ IT + Productivity + IT*Productivity, left = 0, right = 1, data = experimentData)

FEOLS1   <- lm(Performance ~ Productivity + factor(Session),  data=experimentData)
FETobit1 <- censReg(Performance ~ Productivity + factor(Session), left = 0, right = 1, 
                    data = experimentData)
FEOLS2   <- lm(Performance ~ IT + Productivity + IT*Productivity + factor(Session),  data=experimentData)
FETobit2 <- censReg(Performance ~ IT + Productivity + IT*Productivity + factor(Session), left = 0, right = 1, 
                    data = experimentData)

OLS6   <- lm(screenChoice ~ Productivity, data=experimentData)
OLS7   <- lm(screenChoice ~ IT + Productivity + IT*Productivity,  data=experimentData)
Tobit6 <- censReg(screenChoice ~ Productivity, left = 1, right = maxScreens, data = experimentData)
Tobit7 <- censReg(screenChoice ~ IT + Productivity + IT*Productivity, left = 1, right = maxScreens, data = experimentData)

FEOLS6   <- lm(screenChoice ~ Productivity + factor(Session), data=experimentData)
FETobit6 <- censReg(screenChoice ~ Productivity + factor(Session), left = 1, right = maxScreens,
                    data = experimentData)
FEOLS7   <- lm(screenChoice ~ IT + Productivity + IT*Productivity + factor(Session),
               data=experimentData)
FETobit7 <- censReg(screenChoice ~ IT + Productivity + IT*Productivity + factor(Session), left = 1, right = maxScreens,
                    data = experimentData)




# Fisher test for choosing low screenChoice contingent on IT and Productivity
# The matrix looks as follows
matrix(c("HiBad", "LOBad", "HiGood", "LOGood"), nrow =2)

fisher.test((fishersData[1:2,1:2]))


# decision trees ----------------------------------------------------------
# 
# 
# #setting the tree control parameters
# fitControl <- trainControl(method = "cv", number = 5)
# cartGrid <- expand.grid(.cp=(1:50)*0.01)
# 
# #decision tree
# tree_model <- train(perfDifference ~ IT + relProductivity + Yaphat, 
#                     data = experimentData, method = "rpart", trControl = fitControl, tuneGrid = cartGrid)
# print(tree_model)
# 
# #build tree with 0.01 as complexity parameter
# main_tree <- rpart(perfDifference ~ IT + relProductivity + Yaphat, 
#                    data = experimentData, control = rpart.control(cp=0.01))
# prp(main_tree)
# 
# #conditional partitioning
# tree_fit <- ctree(perfDifference ~ IT + relProductivity + Yaphat, 
#                   data = experimentData)
# plot(tree_fit, type="simple")
# 
# #check corresponding RMSE
# pre_score <- predict(main_tree, type = "vector")
# rmse(experimentData$perfDifference, pre_score)
# 
# #random forest
# #set tuning parameters
# control <- trainControl(method = "cv", number = 5)
# 
# #random forest model
# rf_model <- train(perfDifference ~ IT + relProductivity + Yaphat, 
#                   data = experimentData, method = "parRF",
#                   trControl = control, prox = TRUE, allowParallel = TRUE)
# 
# #check optimal parameters
# print(rf_model)
# 
# #random forest model with 1000 trees and mtry = 3 as it minimizes RMSE
# forest_model <- randomForest(perfDifference ~ IT + relProductivity + Yaphat, 
#                              data = experimentData, mtry = 3, ntree = 1000)
# print(forest_model)
# varImpPlot(forest_model)













