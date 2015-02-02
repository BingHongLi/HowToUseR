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

# wordcount
hdfs.mkdir("/user/cloudera/wordcount")
hdfs.ls("/")
srcPath <- file.path("data/","wordcount.txt")
hdfs.put(srcPath,dest="/user/cloudera/wordcount/",dstFS=hdfs.defaults("fs"))
hdfs.ls("/user/cloudera/wordcount")

text <- "/user/cloudera/wordcount/wordcount.txt"

test <- mapreduce(
  input=text,
  input.format="text",
  map=function(k,v){
    
    keyval(
      unlist(
          strWord <- strsplit(x=tolower(v),split=" ")),1)
  },reduce=function(k,v){
    keyval(k,sum(v))
  }
)

result <- from.dfs(test)

View(result)

library(dplyr)
arrange(as.data.frame(result),desc(val))

#############################################

# 非rmr版本

test <- readLines("data//wordcount.txt")
#class(test)
step2 <- strsplit(tolower(test)," ")
step3 <- unlist(step2)
step4 <- unique(step3)
library(dplyr)
resultDF <- data.frame(word=step4,counts=rep(0,length(step4)))

for(i in step3 ){
  resultDF[resultDF[,1]==i,2]=resultDF[resultDF[,1]==i,2]+1
}

resultDF<- arrange(resultDF,word)
#############################################
# 針對mtcars$mpg 做平均與變異數值

meanSource <- to.dfs(mtcars$mpg)

# mean 
rmrMean <- mapreduce(
  input=meanSource,
  map=function(k,v){
    rmr.str(v)
    keyval(1,v)
  },reduce=function(k,v){
    rmr.str(v)
    keyval(1,sum(v)/length(v))
  }
)

tempMean <- from.dfs(rmrMean)$val

rmrVariance <- mapreduce(
  input=meanSource,
  map=function(k,v){
    step1Range=v-tempMean
    step2Square=step1Range^2
    keyval(1,step2Square)
  },reduce=function(k,v){
    keyval(1,sum(v)/(length(v)-1))
  }
)

from.dfs(rmrVariance)

mean(mtcars$mpg)
var(mtcars$mpg)