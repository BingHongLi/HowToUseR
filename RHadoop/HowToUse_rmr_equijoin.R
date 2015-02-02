###HowToUseRHadoop

# 可用rmr.str

###
# Set system variable
Sys.setenv(HADOOP_CMD="/usr/bin/hadoop")
Sys.setenv(HADOOP_STREAMING="/usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming.jar")
Sys.setenv(JAVA_HOME="/usr/java/jdk1.7.0_67-cloudera")

library(rJava)
library(rhdfs)
hdfs.init()
library(rmr2)
library(ravro)

# SQL Join

# 查出reviews.id == solutions.id 的資料列 
solutions <- read.csv(file="./data/solutions.csv",header=T)
reviews <- read.csv(file="data/reviews.csv",header=T)
str(solutions)
str(reviews)

# R 的解決辦法 merge
# mergeByID <- merge(reviews,solutions,by.x="id",by.y="id", all=T) 
# View(mergeByID)

#############################################################

# 將reviews資料集合併，並在合併時增加一個欄位，X.rv 內容均為rv
rv <- to.dfs(keyval(reviews$id,reviews))
# from.dfs(rv)

# 將solution資料集合併，並在合併時增加一個欄位，X.sl 內容均為sl
sl <- to.dfs(keyval(solutions$id,solutions))
# from.dfs(sl)


dataJoin <- equijoin(
  left.input=sl,
  right.input=rv,
  outer="full"
)

JoinByID <- from.dfs(dataJoin)$val
View(JoinByID)

#####################################################################