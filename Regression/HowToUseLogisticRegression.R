#########Old-Version
ORIGINDATA <- read.csv('E:/testLogistic2.csv')

View(ORIGINDATA)
colnames(ORIGINDATA) <- c("ID","COMPANY","YEAR","MONTH","DAY","WEEK","PRICE","HOLIDAY","PROMOTION")
ADJUSTDATA <- ORIGINDATA
#ADJUSTDATA['PRICE'] <-(ADJUSTDATA['PRICE']-min(ADJUSTDATA['PRICE']))/(max(ADJUSTDATA['PRICE']-min(ADJUSTDATA['PRICE'])))
View(ADJUSTDATA)


#log.glm <- glm(PROMOTION~YEAR+MONTH+DAY+WEEK+HOLIDAY,family=binomial,data=ADJUSTDATA)
log.glm <- glm(PROMOTION~HOLIDAY,family=binomial,data=ADJUSTDATA)
#possion.glm <- glm(PRICE~YEAR+MONTH+DAY+WEEK+HOLIDAY,family=poisson,data=ADJUSTDATA)

log.step <- step(log.glm)
summary(log.step)

##################################
clusterMethod=list()
max(test[clusterMethod])
# Create Model
#test <- read.csv('./data/forAnalysisCSATTR.csv')
#test <- read.csv('forAnalysisCSATTR.csv')
clusterNames = c("kmeans8","kmeans10","kmeans20","kmeans50","clara10","clara13","clara20","clara50","pamk6","pamk7","pamk8","pamk15","pamk20","pamk25","hclust8","hclust20","diana6","diana8","diana10","diana15","diana20")
#clusterNames = c("kmeans8","kmeans10","clara10","clara13","pamk6","pamk7","pamk8","hclust8","diana6","diana8","diana10","diana15")
clusterMethod <- list()

calculateModel <- function(x){
  temp <- list()
  for(i in 1:max(test[x])){
    if(nrow(test[which(test[x]==i),])==0){
      next
    }
    tempAnalysis <- test[which(test[x]==i),]
    c90  <- step(glm(day90~Adventure+Casual+EarlyAccess+Indie+Racing+RPG+Simulation+Strategy,family=binomial,data=tempAnalysis))
    c180 <- step(glm(day180~Adventure+Casual+EarlyAccess+Indie+Racing+RPG+Simulation+Strategy,family=binomial,data=tempAnalysis))
    c270 <- step(glm(day270~Adventure+Casual+EarlyAccess+Indie+Racing+RPG+Simulation+Strategy,family=binomial,data=tempAnalysis))
    c360 <- step(glm(day360~Adventure+Casual+EarlyAccess+Indie+Racing+RPG+Simulation+Strategy,family=binomial,data=tempAnalysis))
    c450 <- step(glm(day450~Adventure+Casual+EarlyAccess+Indie+Racing+RPG+Simulation+Strategy,family=binomial,data=tempAnalysis))
    c540 <- step(glm(day540~Adventure+Casual+EarlyAccess+Indie+Racing+RPG+Simulation+Strategy,family=binomial,data=tempAnalysis))
    c630 <- step(glm(day630~Adventure+Casual+EarlyAccess+Indie+Racing+RPG+Simulation+Strategy,family=binomial,data=tempAnalysis))
    c720 <- step(glm(day720~Adventure+Casual+EarlyAccess+Indie+Racing+RPG+Simulation+Strategy,family=binomial,data=tempAnalysis))
    c810 <- step(glm(day810~Adventure+Casual+EarlyAccess+Indie+Racing+RPG+Simulation+Strategy,family=binomial,data=tempAnalysis))
    temp[[i]]  <- list(c90 = c90,c180 = c180,c270 = c270,c360 = c360,c450 = c450,c540 = c540,c630 = c630,c720 = c720,c810 = c810)    
  }
  clusterMethod[[x]]<<- temp
}

sapply(clusterNames,calculateModel)
###############################################
#Action+Adventure+Casual+DesignAndIllustration+EarlyAccess+FreeToPlay+Indie+RPG+Simulation+Sports+Strategy+Utilities
### getModel
test <- read.csv('E:/day7Attr.csv')
ORIGINDATA <- test
clusterNames<- colnames(ORIGINDATA)[50:91]
clusterModel <- list()
calculateModel <- function(x){
  temp <- list()
  for(i in 1:max(ORIGINDATA[x])){
    if(nrow(ORIGINDATA[which(ORIGINDATA[x]==i),])==0){
      next
    }
    tempAnalysis <- ORIGINDATA[which(ORIGINDATA[x]==i),]
    #c7   <- step(glm(d7~Action+Adventure+Casual+DesignAndIllustration+EarlyAccess+FreeToPlay+Indie+RPG+Simulation+Sports+Strategy+Utilities,family=binomial,data=tempAnalysis))
    #c14 <- step(glm(d14~Action+Adventure+Casual+DesignAndIllustration+EarlyAccess+FreeToPlay+Indie+RPG+Simulation+Sports+Strategy+Utilities,family=binomial,data=tempAnalysis))
    c21 <- step(glm(d21~Action+Adventure+Casual+DesignAndIllustration+EarlyAccess+FreeToPlay+Indie+RPG+Simulation+Sports+Strategy+Utilities,family=binomial,data=tempAnalysis))
    c28 <- step(glm(d28~Action+Adventure+Casual+DesignAndIllustration+EarlyAccess+FreeToPlay+Indie+RPG+Simulation+Sports+Strategy+Utilities,family=binomial,data=tempAnalysis))
    c35 <- step(glm(d35~Action+Adventure+Casual+DesignAndIllustration+EarlyAccess+FreeToPlay+Indie+RPG+Simulation+Sports+Strategy+Utilities,family=binomial,data=tempAnalysis))
    c42 <- step(glm(d42~Action+Adventure+Casual+DesignAndIllustration+EarlyAccess+FreeToPlay+Indie+RPG+Simulation+Sports+Strategy+Utilities,family=binomial,data=tempAnalysis))
    c49 <- step(glm(d49~Action+Adventure+Casual+DesignAndIllustration+EarlyAccess+FreeToPlay+Indie+RPG+Simulation+Sports+Strategy+Utilities,family=binomial,data=tempAnalysis))
    c56 <- step(glm(d56~Action+Adventure+Casual+DesignAndIllustration+EarlyAccess+FreeToPlay+Indie+RPG+Simulation+Sports+Strategy+Utilities,family=binomial,data=tempAnalysis))
    c63 <- step(glm(d63~Action+Adventure+Casual+DesignAndIllustration+EarlyAccess+FreeToPlay+Indie+RPG+Simulation+Sports+Strategy+Utilities,family=binomial,data=tempAnalysis))
    c70  <- step(glm(d70~Action+Adventure+Casual+DesignAndIllustration+EarlyAccess+FreeToPlay+Indie+RPG+Simulation+Sports+Strategy+Utilities,family=binomial,data=tempAnalysis))
    c77 <- step(glm(d77~Action+Adventure+Casual+DesignAndIllustration+EarlyAccess+FreeToPlay+Indie+RPG+Simulation+Sports+Strategy+Utilities,family=binomial,data=tempAnalysis))
    c84 <- step(glm(d84~Action+Adventure+Casual+DesignAndIllustration+EarlyAccess+FreeToPlay+Indie+RPG+Simulation+Sports+Strategy+Utilities,family=binomial,data=tempAnalysis))
    c91 <- step(glm(d91~Action+Adventure+Casual+DesignAndIllustration+EarlyAccess+FreeToPlay+Indie+RPG+Simulation+Sports+Strategy+Utilities,family=binomial,data=tempAnalysis))
    c98 <- step(glm(d98~Action+Adventure+Casual+DesignAndIllustration+EarlyAccess+FreeToPlay+Indie+RPG+Simulation+Sports+Strategy+Utilities,family=binomial,data=tempAnalysis))
    c105 <- step(glm(d105~Action+Adventure+Casual+DesignAndIllustration+EarlyAccess+FreeToPlay+Indie+RPG+Simulation+Sports+Strategy+Utilities,family=binomial,data=tempAnalysis))
    c112 <- step(glm(d112~Action+Adventure+Casual+DesignAndIllustration+EarlyAccess+FreeToPlay+Indie+RPG+Simulation+Sports+Strategy+Utilities,family=binomial,data=tempAnalysis))
    c119 <- step(glm(d119~Action+Adventure+Casual+DesignAndIllustration+EarlyAccess+FreeToPlay+Indie+RPG+Simulation+Sports+Strategy+Utilities,family=binomial,data=tempAnalysis))
    c126 <- step(glm(d126~Action+Adventure+Casual+DesignAndIllustration+EarlyAccess+FreeToPlay+Indie+RPG+Simulation+Sports+Strategy+Utilities,family=binomial,data=tempAnalysis))
    c133 <- step(glm(d133~Action+Adventure+Casual+DesignAndIllustration+EarlyAccess+FreeToPlay+Indie+RPG+Simulation+Sports+Strategy+Utilities,family=binomial,data=tempAnalysis))
    c140 <- step(glm(d140~Action+Adventure+Casual+DesignAndIllustration+EarlyAccess+FreeToPlay+Indie+RPG+Simulation+Sports+Strategy+Utilities,family=binomial,data=tempAnalysis))
    #temp[[i]]  <- list(c7 = c7,c14 = c14,c21 = c21,c28 = c28,c35 = c35,c42 = c42,c49 = c49,c56 = c56,c63 = c63,c70=c70,c77=c77,c84=c84,c91=c91,c98=c98,c105=c105,c112=c112,c119=c119,c126=c126,c133=c133,c140=c140)
    temp[[i]]  <- list(c21 = c21,c28 = c28,c35 = c35,c42 = c42,c49 = c49,c56 = c56,c63 = c63,c70=c70,c77=c77,c84=c84,c91=c91,c98=c98,c105=c105,c112=c112,c119=c119,c126=c126,c133=c133,c140=c140)    
  }
  clusterModel[[x]]<<- temp
}

sapply(clusterNames,calculateModel)


#### getDay

#### One file
### generate Test File to Examine function getDay
# test.frame <- data.frame(GenreAction=0,Accounting=0,Action=0,Adventure=0,AnimationAndModeling=0,AudioProduction=0,Casual=0,DesignAndIllustration=0,EarlyAccess=0,Education=0,FreeToPlay=0,Indie=0,MassivelyMultiplayer=0,Racing=0,RPG=0,Simulation=0,Sports=0,Strategy=0)
# forTestList <- list(gameName='aaa',clusterNumber=1,tag=test.frame)
# clusterModel <- readRDS('./data/getDay/forTestLogisticPredict.RDS') #for test Function



### generate Test File to Examine function getDay
#test.frame <- data.frame(GenreAction=0,Accounting=0,Action=0,Adventure=0,AnimationAndModeling=0,AudioProduction=0,Casual=0,DesignAndIllustration=0,EarlyAccess=0,Education=0,FreeToPlay=0,Indie=0,MassivelyMultiplayer=0,Racing=0,RPG=0,Simulation=0,Sports=0,Strategy=0)
#forTestList <- list(gameName=c('aaa'),clusterNumber=1,tag=test.frame)
#logisticRegressionModel <- readRDS('./data/getDay/forTestLogisticPredict.RDS') #for test Function


#logisticRegressionModel <- readRDS('./data/getDay/logisticRegressionModel.RDS')
logisticRegressionModel<- readRDS('E:/ALLMETHODModel.RDS')
getDay <- function(listName,clusterMethod='pamk_7'){
  gameName=listName$gameName
  clusterNumber=listName$clusterNumber
  tag=listName$tag
  
  tempDataFrame <- data.frame()
  for(i in names(logisticRegressionModel[[clusterMethod]][[clusterNumber]])){
    probability <- predict(logisticRegressionModel[[clusterMethod]][[clusterNumber]][[i]],tag)
    tempDataFrame <- rbind(tempDataFrame,data.frame(modelName=i,probability=probability))
  }
  
  tempDayString <- tempDataFrame[which(tempDataFrame[,2]==max(tempDataFrame[,2])),1][1]
  #print(tempDayString)
  day <- as.numeric(gsub("c","",tempDayString))
  #day <- as.numeric(gsub("d","",tempDayString))
  returnList <- list(gameName=gameName,clusterNumber=clusterNumber,day=day)
  
  return(returnList)
}


unitTest <- getDay(forTestList)


### mulitple rows Tag
#getDay <- function(gameName,clusterNumber,tag){
#  #View(tag)
#  tempDataFrame <- data.frame()
#  
#  for(i in names(clusterModel[[clusterNumber]])){
#    probability <- predict(clusterModel[[clusterNumber]][[i]],tag)
#    tempDataFrame <- rbind(tempDataFrame,data.frame(modelName=i,probability=probability))
#    rownames(tempDataFrame) <- c(1:nrow(tempDataFrame))
#  }
#  #View(tempDataFrame)
#  day <- c()
#  for(i in 0:(nrow(tag)-1)){
#      prepareSelectMax<- tempDataFrame[which(as.numeric(rownames(tempDataFrame))%% nrow(tag)==i),]
#      #View(prepareSelectMax)
#      tempDayString <- prepareSelectMax[which(prepareSelectMax[,2]==max(prepareSelectMax[,2])),1][1]
#      day <- c(day,as.numeric(gsub("c","",tempDayString)))
#  }
#  #tempDayString <- tempDataFrame[which(tempDataFrame[,2]==max(tempDataFrame[,2])),1][1]
#  #print(tempDayString)
#  #day <- as.numeric(gsub("c","",tempDayString))
#  #day <- as.numeric(gsub("d","",tempDayString))
#  returnList <- list(gameName=gameName,clusterNumber=clusterNumber,day=day)
#  
#  return(returnList)
#}
