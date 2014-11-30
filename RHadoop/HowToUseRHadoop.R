###HowToUseRHadoop

###
# Set system variable
Sys.setenv(HADOOP_CMD="/usr/bin/hadoop")
Sys.setenv(HADOOP_STREAMING="/opt/cloudera/parcels/CDH-5.0.0-1.cdh5.0.0.p0.47/lib/hadoop-mapreduce/hadoop-streaming.jar")

library(rmr2)
library(rhdfs)
hdfs.init()
hdfs.mkdir('/user/cloudera/wordcount/data')
hdfs.put('fileName.txt','/user/cloudera/wordcount/data')

wordCount <- function(input,output=NULL,pattern=''){
  wc.map=function(.,lines){
    keyval(
      unlist(strsplit(x=lines,split=pattern)),
      1
    )
  }
  w.reduce=function(word,counts){
    keyval(word,sum(counts))
  }
}

