###HowToUseRHadoop

###
# Set system variable
Sys.setenv(HADOOP_CMD="/usr/bin/hadoop")
Sys.setenv(HADOOP_STREAMING="/usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming.jar")
Sys.setenv(JAVA_HOME="/usr/java/jdk1.7.0_67-cloudera")

library(rJava)
library(rhdfs)
library(rmr2)
library(ravro)

# wordcount
hdfs.init()
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
