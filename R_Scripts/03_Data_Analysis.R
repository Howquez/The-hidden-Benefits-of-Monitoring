
# Load Packages -----------------------------------------------------------

library(VGAM)
library(censReg)




# OLS ---------------------------------------------------------------------
# In what follows, I'll more or less run the same three specifications over and over again:
# I'll either estimate the performance or the agent's workload and start with the Productivity as 
# the only independent variable. I'll then add IT and its interaction term with productivity and 
# subseqently, the principal's productivity. Afterward, I repeat these specifications but add sessions effects.
# I finally do the same thing running censored regressions instead of OLS.

# estimate the performance
OLS1   <- lm(Performance ~ Productivity, data=experimentData)
OLS2   <- lm(Performance ~ IT + Productivity + IT*Productivity,  data=experimentData)
OLS3   <- lm(Performance ~ IT + Productivity + IT*Productivity + PrinProd,  data=experimentData)
# estimate the agent's workload
OLS6   <- lm(screenChoice ~ Productivity, data=experimentData)
OLS7   <- lm(screenChoice ~ IT + Productivity + IT*Productivity,  data=experimentData)
OLS8   <- lm(screenChoice ~ IT + Productivity + IT*Productivity + PrinProd,  data=experimentData)


# Add fixed effects/session effects to estimate both outcome variables
FEOLS1   <- lm(Performance ~ Productivity + factor(Session),  data=experimentData)
FEOLS2   <- lm(Performance ~ IT + Productivity + IT*Productivity + factor(Session),  data=experimentData)
FEOLS3   <- lm(Performance ~ IT + Productivity + IT*Productivity + PrinProd + factor(Session),  data=experimentData)
#
FEOLS6   <- lm(screenChoice ~ Productivity + factor(Session), data=experimentData)
FEOLS7   <- lm(screenChoice ~ IT + Productivity + IT*Productivity + factor(Session),
               data=experimentData)
FEOLS8   <- lm(screenChoice ~ IT + Productivity + IT*Productivity + PrinProd + factor(Session),
               data=experimentData)


# Censored Regressions ----------------------------------------------------
# The two outcome variables are censored by design. The Performance can neither be negative nor higher than 1
# because it is not possible to click on more than 100% of the boxes that are displayed. Likewise,
# the workload cannot be lower than 1 (a boundary of 0 was not possible to program) and not higher than
# a maximum we defined as maxScreens. Even though the models are called TobitX, the specifications here
# consider that the data is left- AND right-censored. I therefore use the censreg package and follow the
# same procedure as above.

# estimate the performance
Tobit1 <- censReg(Performance ~ Productivity, left = 0, right = 1, data = experimentData)
Tobit2 <- censReg(Performance ~ IT + Productivity + IT*Productivity, left = 0, right = 1, data = experimentData)
Tobit3 <- censReg(Performance ~ IT + Productivity + IT*Productivity + PrinProd, 
                  left = 0, right = 1, data = experimentData)
# estimate the agent's workload
Tobit6 <- censReg(screenChoice ~ Productivity, left = 1, right = maxScreens, data = experimentData)
Tobit7 <- censReg(screenChoice ~ IT + Productivity + IT*Productivity, left = 1, right = maxScreens, data = experimentData)
Tobit8 <- censReg(screenChoice ~ IT + Productivity + IT*Productivity + PrinProd, 
                  left = 1, right = maxScreens, data = experimentData)

# Add fixed effects/session effects to estimate both outcome variables
FETobit1 <- censReg(Performance ~ Productivity + factor(Session), left = 0, right = 1, 
                    data = experimentData)
FETobit2 <- censReg(Performance ~ IT + Productivity + IT*Productivity + factor(Session), left = 0, right = 1, 
                    data = experimentData)
FETobit3 <- censReg(Performance ~ IT + Productivity + IT*Productivity + PrinProd + factor(Session), 
                    left = 0, right = 1, data = experimentData)
#
FETobit6 <- censReg(screenChoice ~ Productivity + factor(Session), left = 1, right = maxScreens,
                    data = experimentData)
FETobit7 <- censReg(screenChoice ~ IT + Productivity + IT*Productivity + factor(Session), left = 1, right = maxScreens,
                    data = experimentData)
FETobit8 <- censReg(screenChoice ~ IT + Productivity + IT*Productivity + PrinProd + factor(Session), 
                    left = 1, right = maxScreens, data = experimentData)


# Censored Regression with Sensitivity Parameter Y ------------------------
# These regression can later be used as a robustness check. Since they are, however,
# hard to interpret and because these specifications rely on many independent variables
# I prefer to generate a subsample that contains the most reciprocal observations, that is,
# the highest values of YAgent, to run the specifications from above. I can then compare
# the coefficients of the whole sample with those of the subsample.

Tobit3 <- censReg(Performance ~ IT + Productivity + IT*Productivity + PrinProd, 
                  left = 0, right = 1, data = experimentData)
Tobit4 <- censReg(Performance ~ IT + Productivity + YAgent + IT*Productivity + IT*YAgent + Productivity*YAgent + 
                          IT*Productivity*YAgent + PrinProd, left = 0, right = 1, data = experimentData)
FETobit4 <- censReg(Performance ~ IT + Productivity + YAgent + IT*Productivity + IT*YAgent + Productivity*YAgent + 
                            IT*Productivity*YAgent + PrinProd + factor(Session), 
                    left = 0, right = 1, data = experimentData)

Tobit8 <- censReg(screenChoice ~ IT + Productivity + IT*Productivity + PrinProd, 
                  left = 1, right = maxScreens, data = experimentData)
Tobit9 <- censReg(screenChoice ~ IT + Productivity + YAgent + IT*Productivity + IT*YAgent + Productivity*YAgent + 
                          IT*Productivity*YAgent + PrinProd, left = 1, right = maxScreens, data = experimentData)
FETobit9 <- censReg(screenChoice ~ IT + Productivity + YAgent + IT*Productivity + IT*YAgent + Productivity*YAgent + 
                            IT*Productivity*YAgent + PrinProd + factor(Session), 
                    left = 1, right = maxScreens, data = experimentData)


# Run fisher’s exact test -------------------------------------------------
# Fisher test for choosing low screenChoice contingent on IT and Productivity.
# Because I do not know how many instances each cell will have, I chose to run 
# fisher's exact test because few cases suffice.

fisher.test((fishersData[1:2,1:2]))
# Find screenChoice Mode --------------------------------------------------
Mode <- function(x) {
        ux <- unique(x)
        tab <- tabulate(match(x, ux)) 
        ux[tab == max(tab)]
}

Maxi <- function(x) {
        tab <- tabulate(x)
        max(tab)
}

Maxi(experimentData$screenChoice[experimentData$IT==0])

# find mode of screenchoices for both IT choices (we'll need this for the graphs)
modeIT0 <- Mode(experimentData$screenChoice[experimentData$IT==0])
nmaxIT0 <- Maxi(experimentData$screenChoice[experimentData$IT==0])

modeIT1 <- Mode(experimentData$screenChoice[experimentData$IT==1])
nmaxIT1 <- Maxi(experimentData$screenChoice[experimentData$IT==1])

# save the higher value
max(c(nmaxIT0, nmaxIT1))
nmaxIT  <- max(c(nmaxIT0, nmaxIT1))


# The principal's choice --------------------------------------------------
# Count the principals who seem to expect an adverse effect of choosing the 'wrong' IT
# 'wrong' thereby means that the agent would be materialy better off had the principal chosen
# the other IT (likelihood of receiving a performance based payment).
# I store the values in meaningless obects to see whether it sums up correctly. I'll then store these
# objects in a data frame as I did with the fisher data.

aa <- as.data.frame(table(experimentData$Productive))[1,2] # counts unproductive agents
bb <- NROW(experimentData$IT[experimentData$IT == 1 & experimentData$Productive  == 0]) # 'wrong' choice
cc <- NROW(experimentData$IT[experimentData$IT == 0 & experimentData$Productive  == 0]) # 'good' choice
aa == bb + cc # has to evaluate as true

dd <- as.data.frame(table(experimentData$Productive))[2,2] # counts productive agents
ee <- NROW(experimentData$IT[experimentData$IT == 1 & experimentData$Productive  == 1]) # 'good' choice
ff <- NROW(experimentData$IT[experimentData$IT == 0 & experimentData$Productive  == 1]) # 'wrong' choice
dd == ee + ff # has to evaluate as true

# The principal's earnings ------------------------------------------------
# Run Factorial ANOVA
# where PayA2 (what the principals would have earned in stage 2) is affected by 
# the principal's IT choice and the agent's productivity

anova(lm(PayA2 ~ IT * Productive, data = experimentData))
