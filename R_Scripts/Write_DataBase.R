
# Preamble ----------------------------------------------------------------

rm(list=ls())
set.seed(9999)

n        <- 400
Username <- rep(9999,n)
Password <- rep(8888, n)
Group    <- rep(1:(n/2), each = 2)
Role     <- rep((1:2), (n/2))

database <- data.frame(Username, Password, Group, Role)


# Generating Passwords & Usernames ----------------------------------------

generatePasswordA <- function(i=1, length=6){
        randomString <- c(1:i)
        for (j in 1:i){
                randomString[j] <- paste(sample(c(1:9, LETTERS),
                                                length, replace=T),
                                         collapse="")
        }
        return(randomString)
}

generatePasswordB <- function(i=1, length=6){
        randomString <- c(1:i)
        for (j in 1:i){
                randomString[j] <- paste(sample(c(1:9, letters),
                                                length, replace=T),
                                         collapse="")
        }
        return(randomString)
}

for (m in 1:n){
        database$Username[m] <- 1000 + m
        if (database$Role[m]==1){
                database$Password[m] <- paste(c("W_", generatePasswordA()), collapse="")
        }
        else{
                database$Password[m] <- paste(c("M_", generatePasswordB()), collapse="")
        }
} 
# Role 1 has odd  Usernames and Passwords with LETTERS and a "W_" as prefix
# Role 2 has even Usernames and Passwords with letters and a "M_" as prefix



# Store as XML ------------------------------------------------------------
library(XML)
xml <- xmlTree()
# names(xml)
xml$addTag("Users", close=FALSE)
for (i in 1:nrow(database)) {
        xml$addTag("User", close=FALSE)
        for (j in names(database)) {
                xml$addTag(j, database[i, j])
        }
        xml$closeTag()
}
xml$closeTag()

# write.table(saveXML(xml),"/Users/howquez/Documents/002_UNI/UCPH/016_Master Thesis/04_Program/DataBase/database.xml",sep="\t",row.names=FALSE)
# commented because I do not want to replace the file, since the first two as well as the last line have been edited manualy

# Store as XLSX -----------------------------------------------------------
library(xlsx)
# write.xlsx(database, "/Users/howquez/Documents/002_UNI/UCPH/016_Master Thesis/04_Program/database.xlsx")
# commented because I do not want to replace the file, since a new sheet has been edited manualy
