# HowToUse_plyrmr

#########################################################################################################

# 前置作業
Sys.setenv(HADOOP_CMD="/usr/bin/hadoop")
Sys.setenv(HADOOP_STREAMING="/usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming.jar")
Sys.setenv(JAVA_HOME="/usr/java/jdk1.7.0_67-cloudera")

library(plyrmr)
library(rJava)
library(rhdfs)
hdfs.init()
library(rmr2)
library(ravro)
#########################################################################################################


## 資料操作

# bind.cols 增加新欄位
# select    選擇欄位
# where     過濾資料
# transmute 資料轉換

## from reshape2
# melt      資料融合
# dcast     資料分離

## 統計函式
# count
# quantile
# sample

## 萃取函式
# top.k
# bottom.k

#########################################################################################################


## 新增欄位

# 將資料轉入hdfs(暫時轉入，session關閉後，即刪除)
cardata <- to.dfs(mtcars)
carDataNewCol <- bind.cols(input(cardata),carb.per.cyl=carb/cyl)
carDataNewCol

# 新增一個資料框
data(Titanic)
titanic <- data.frame(Titanic)

# 找出titanic資料集，Freq次數大於100
where(titanic , Freq>=100)

##########################################################################################################

## 使用gapply指定字串分割函式

getStrPath <- to.dfs("car car river qoo qoo qoo")

textSplit <- function(x){
  unlist(strsplit(as.character(x),'+'))
}

gapply()
##########################################################################################################