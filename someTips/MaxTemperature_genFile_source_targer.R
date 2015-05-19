# Rscript source targetCSV
args <- commandArgs(T)

MISSING <- 9999
tempMatrix  <-matrix(c(1901,0),ncol = 2)
# args[1] 為欲讀入的檔案
# 開始擷取字串
for (i in readLines(args[1])){
  # year
  # print(substr(i,16,19))
  year <- as.numeric(substr(i,16,19))
  # symbo 看是否為+或-
  # print(substr(i,88,88))
  airTemperature <- 0 
  symbol <- substr(i,88,88)
  
  # 判斷前置符號
  if(symbol=="+"){
    airTemperature <- as.numeric(substr(i,89,92))
  }else{
    airTemperature <- as.numeric(substr(i,88,92))
  }
  
  # 判斷溫度是否為9999(無效)
  if(airTemperature != MISSING){
    print(c(year,airTemperature))
    tempMatrix <- rbind(tempMatrix,c(year,airTemperature))
  }else{
    print(c(year,0))
    tempMatrix <- rbind(tempMatrix,c(year,0))
  }
  
  
}


resultMatrix <- data.frame()
for (i in levels(factor(tempMatrix[,1]))){
  yearStep2 <- as.numeric(i)
  print(c(yearStep2,max(tempMatrix[tempMatrix[,1]==yearStep2,2])))
  resultMatrix <- rbind(resultMatrix,c(yearStep2,max(tempMatrix[tempMatrix[,1]==yearStep2,2])))
}

# 設定欄位名
colnames(resultMatrix) <- c("year","temperature")
# 第二個參數，儲存的檔案位置
write.csv(resultMatrix,file=args[2],row.names=F)

#write.csv(resultMatrix,file="test.csv",row.names=F)
