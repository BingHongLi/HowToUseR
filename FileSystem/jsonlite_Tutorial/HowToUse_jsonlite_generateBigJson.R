

# 載入jsonlite與plyr包

if(!require("jsonlite")){
  install.packages("jsonlite")
  library("jsonlite")
}

if(!require("plyr")){
  install.packages("plyr")
  library("plyr")
}



###############################################

# 生成日期函數

generateDate <- function(startDay=1,lastDay=14,startHour=6,lastHour=24){
  name <- c()
  for(i in startDay:lastDay){
    for(j in startHour:lastHour){
      day <- c()
      if(i<10){
        day <- paste(0,i,sep="")
      }else{
        day <- i
      }
      hour <- c()
      if(j < 10){
        hour <- paste(0,j,sep="")
      }else{
        hour <- j
      }
      name <- c(name,paste("201503",day,hour,"00",sep=""))
    }
  }
  name
}

timeName<-generateDate() 

################################################

# 載入捷運運量資料，有幾個站別必須特別抓出來看，因載入會有問題

locationEntryAndOut <- read.csv("complete.csv",header=F,stringsAsFactor=F)
locationEntryAndOut <- na.omit(locationEntryAndOut)
names(locationEntryAndOut) <- c("CN","EN","Entry","Out")

################################################

# 生成各卡別進出站人數函數

randomEntryOrOutput <- function(originLog=locationEntryAndOut,rowIndex,colIndex=3){
  entryVector <- originLog[rowIndex,colIndex]
  temp <- 0
  result <- c()
  for(i in 1:11){
    if(i!=11){
      set.seed(24)
      temp <- sample(0:(entryVector-sum(result)),1)
      result <- c(result,temp)
    }else{
      temp <- entryVector-sum(result)
      result <- c(result,temp)
    }
  }
  result
}

#################################################

#測試檔
#demolist <- list()
#for(i in timeName){
#   demo <- list(start=c(i),tspan=c(60))
#   demo$stations <- list(cn="TaipeiMainStation",entry=randomEntryOrOutput(locationEntryAndOut,23,3),out=randomEntryOrOutput(locationEntryAndOut,23,4))
#   demolist[[which(timeName==i)]] <- demo
#}

#################################################

# 生成json檔

demolist <- list()
for(i in timeName){
  demo <- list(start=c(i),tspan=c(60))
  station <- list()
  k <- 1
  for(j in locationEntryAndOut[,2]){
    temp <- list(cn=j,entry=randomEntryOrOutput(locationEntryAndOut,which(locationEntryAndOut[,2]==j),3),out=randomEntryOrOutput(locationEntryAndOut,which(locationEntryAndOut[,2]==j),4))
    station[[k]] <- temp
    k <- k+1
  }
  demo$stations  <- station
  demolist[[which(timeName==i)]] <- demo
}

data2 <- toJSON(demolist, flatten = F,POSIXt="string")
#Encoding(data2)
#data2 <- minify(data2)
write(data2,"complete.json")
