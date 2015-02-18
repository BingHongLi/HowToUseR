
## R3.1.2 windows無法安裝，請改用linux
# 教學可看官網 https://github.com/taiyun/recharts
# http://youhaolin.blog.163.com/blog/static/22449412020142179434843/

# 上傳至shinyapps.io 教學
# http://shiny.rstudio.com/articles/shinyapps.html

# 安裝recharts
if (!require(recharts)){
  if(!require(devtools)){install.packages("devtools")}
  install_github('recharts', 'taiyun')
}

# 設置工作路徑
setwd("GitHub/HowToUseR/reCharts/")

# 讀取log
log <- read.csv("data/Log_20150126130533.csv",stringsAsFactors=F)

# 將四台車的log分開
logID5 <- log[which(log[['ID']]==5),]
logID6 <- log[which(log[['ID']]==6),]
logID7 <- log[which(log[['ID']]==7),]
logID8 <- log[which(log[['ID']]==8),]


# 第一次資料清洗，使recharts包的ePline折線圖，可產生圖像。
newData <- matrix(rep(0,4*2265),ncol=4)
colnames(newData) <- c("logID5","logID6","logID7","logID8")
newData[,1]=logID5[['speedInMetresPerSecond']]
newData[1:1833,2]=logID6[['speedInMetresPerSecond']]
newData[1:544,3]=logID7[['speedInMetresPerSecond']]
newData[1:115,4]=logID8[['speedInMetresPerSecond']]

# 將生成的資料存成RDS，以利快速存取
# saveRDS(newData,file="speedInMetresPerSecond.RDS")

# 折線圖
plot(eLine(newData,title="test"))

# 點狀圖
plot(ePoints(newData))

# 面積圖
plot(eArea(newData))

# 第二次資料清洗，每台車為一列資料，共四列資料
newData2 <- t(data.frame(ID5=nrow(logID5),ID6=nrow(logID6),ID7=nrow(logID7),ID8=nrow(logID8)))
plot(ePie(newData2))

# 將生成的資料存成RDS
# saveRDS(newData2,file="recordCount.RDS")


# 第三次資料清洗，每台車為一筆資料，取關於速度的四個欄位
newData3 <- matrix(rep(0,4*4),ncol=4)
newData3 <- as.data.frame(newData3)
rownames(newData3) <- c("logID5","logID6","logID7","logID8")
colnames(newData3) <- c("speedInKmPerHour","speedInMetresPerSecond","localAccelInMetresPerSecond2.X","localAccelInMetresPerSecond2.Z")

# 取得每一台車的log，並取其四個欄位的最大值，放入先前生成的矩陣
for(i in 1:4){
    temp <- log[log[['ID']]==(i+4),]
    temp2 <- c(max(temp[['speedInKmPerHour']]),max(temp[['speedInMetresPerSecond']]),max(temp[['localAccelInMetresPerSecond2.X']]),max(temp[['localAccelInMetresPerSecond2.Z']]))
    newData3[i,]=temp2
}

# 畫雷達圖
plot(eRadar(newData3))

# 存成RDS檔
# saveRDS(newData3,file="forDemoRadar.RDS")


# speedInKmPerHour
# speedInMetresPerSecond
# localAccelInMetresPerSecond2.X
# localAccelInMetresPerSecond2.Y
# localAccelInMetresPerSecond2.Z