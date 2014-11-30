library(party)
ind <- sample(2,nrow(test),replace=T,prob=c(0.5,0.5))

myFomula <- CLARA~Accounting+Action+Adventure+Casual+Indie+Racing+RPG+Simulation+Sports+Strategy+Utilities  
#myFomula <- CLARA~.

trainData <-test[ind==1,]
testData <- test[ind==2,]
#test_ctree <- ctree(myFomula,data=trainData)
test_ctree <- ctree(myFomula,data=CLUSTER12)

plot(test_ctree)
print(test_ctree)

library(rpart)
myFomula <- CLARA~.
test_rpart <- rpart(myFomula,data=CLASSIFICATION,control=rpart.control(minsplit=10),method="class")
plot(test_rpart)
text(test_rpart,use.n=T)


library(tree)
treeModel <- tree(CLARA~Accounting+Adventure+Casual+Education+Indie+Racing+RPG,data=CLUSTER12)
plot(treeModel)
text(treeModel)

########################################################################################
library(rpart)
library(rpart.plot)
C1 <- ALLCLUSTER[which(ALLCLUSTER[,55]==6),]
C2 <- ALLCLUSTER[which(ALLCLUSTER[,55]==7),]
C3 <- ALLCLUSTER[which(ALLCLUSTER[,55]==8),]
C4 <- ALLCLUSTER[which(ALLCLUSTER[,55]==4),]
C5 <- ALLCLUSTER[which(ALLCLUSTER[,55]==3),]
PREPAREANALYSIS <- rbind(C1,C2,C3,C4,C5)
myFomula <- PAMA~Accounting+Adventure+Casual+Education+Indie+Racing+RPG+Simulation+Sports+Strategy+Utilities
test_rpart <- rpart(myFomula,method="class",data=PREPAREANALYSIS,control=rpart.control(minsplit=10))
plot(test_rpart)
text(test_rpart,use.n=T)
rpart.plot(test_rpart)
#########################################################################################
test <- read.csv('E:/Dropbox/IPJCode/WebDesign/timeSeriesShiny/data/forClassify.csv')
test <- na.omit(test)
colnames(test)[which(colnames(test)=='Animation & Modeling')]='AnimationModeling'
colnames(test)[which(colnames(test)=='Audio Production')]='AudioProduction'
colnames(test)[which(colnames(test)=='Design & Illustration')]='DesignIllustration'
colnames(test)[which(colnames(test)=='Early Access')]='EarlyAccess'
colnames(test)[which(colnames(test)=='Free to Play')]='FreeToPlay'
colnames(test)[which(colnames(test)=='Video Production')]='VideoProduction'
colnames(test)[which(colnames(test)=='Web Publishing')]='WebPublishing'
colnames(test)[which(colnames(test)=='Software Training')]='SoftwareTraining'
ALLCLUSTER <- test
set.seed(4562)
C1 <- ALLCLUSTER[which(ALLCLUSTER['PAMK']==1),]
C1IND <- sample(1:nrow(C1),size=30)
C1 <- C1[C1IND,]
C2 <- ALLCLUSTER[which(ALLCLUSTER['PAMK']==2),]
#C2IND <- sample(1:nrow(C2),size=30)
C2 <- C2[C2IND,]
C3 <- ALLCLUSTER[which(ALLCLUSTER['PAMK']==3),]
C3IND <- sample(1:nrow(C3),size=30)
C3 <- C3[C3IND,]
C4 <- ALLCLUSTER[which(ALLCLUSTER['PAMK']==4),]
C4IND <- sample(1:nrow(C4),size=30)
C4 <- C4[C4IND,]
C5 <- ALLCLUSTER[which(ALLCLUSTER['PAMK']==5),]
C5IND <- sample(1:nrow(C5),size=30)
C5 <- C5[C5IND,]
C6 <- ALLCLUSTER[which(ALLCLUSTER['PAMK']==6),]
C6IND <- sample(1:nrow(C6),size=30)
C6 <- C6[C6IND,]
C7 <- ALLCLUSTER[which(ALLCLUSTER['PAMK']==7),]
C7IND <- sample(1:nrow(C7),size=30)
C7 <- C7[C7IND,]
C8 <- ALLCLUSTER[which(ALLCLUSTER['PAMK']==8),]
C8IND <- sample(1:nrow(C8),size=30)
C8 <- C8[C8IND,]
#PREPAREANALYSIS <- rbind(C3,C4,C6,C7,C8)
#PREPAREANALYSIS <- rbind(C3,C4,C7)
#PREPAREANALYSIS <- rbind(C4,C6,C7)
PREPAREANALYSIS <- rbind(C1,C2,C3,C4,C5,C6,C7,C8)
myFomula <- PAMK~Accounting+Adventure+Casual+Education+Indie+Racing+RPG+Simulation+Sports+Strategy+Utilities#+AnimationAndModeling+AudioProduction+DesignIllustration+FreeToPlay+VideoProduction+WebPublishing+SoftwareTraining
#myFomula <- PAMA~.
test_rpart <- rpart(myFomula,method="class",data=PREPAREANALYSIS,control=rpart.control(minsplit=10))
plot(test_rpart)
text(test_rpart,use.n=T)
rpart.plot(test_rpart)
