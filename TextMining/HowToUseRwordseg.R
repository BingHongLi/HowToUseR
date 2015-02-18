###中文分詞
# Rwordseg套件說明: https://r-forge.r-project.org/scm/viewvc.php/*checkout*/pkg/Rwordseg/inst/doc/Rwordseg_Vignette_CN.pdf?revision=35&root=rweibo

# 安裝套件
# install.packages("rJava")
# install.packages("Rwordseg", repos="http://R-Forge.R-project.org",type="source")
library("rJava")
library("Rwordseg")

# 使用自定義字典
options(dic.dir="E:/LBH/Dropbox/Github/findProspect/dic")
loadDict()

segmentCN("Spark與Hadoop間的愛恨情仇資料探勘海量資料，巨量資料分析,數據分析大資料資料,巨量,資料分析hive love李秉鴻是天才love李秉鴻")
segmentCN("資料分析工程師") %in% target
segmentCN(iconv(step3ConvertUTF8[4,11],from="UTF-8",to="UTF-8"))
segmentCN(step3ConvertUTF8[4,11])

# 讀入未轉編碼的RDS
forViewDF<- readRDS("E://LBH//filterLessThan11.RDS") 
# 超慢做法，將原先篩選過的data,frame轉為utf8格式以供操作，之後不得用View()觀察，建議可生成兩個，一個用來觀察，一個用來操作

for(i in 1:length(step3ConvertUTF8)){
  
  for(j in 1:length(step3ConvertUTF8[,1])){
    step3ConvertUTF8[[i]][[j]] <- iconv(step3ConvertUTF8[[i]][[j]],from="UTF-8",to="UTF-8")
    #print(paste(i,j,sep=" and "))
  }
  print(i)
}

saveRDS(step3ConvertUTF8,"E://LBH//step4ForTextMining.RDS")

# 比對內容簡介(PROFILE)
# 將有出現的資料列編號提出來，並刪除重複的編號

target <- c("數據","分析","數據分析","大數據","數據探勘","巨量數據","海量數據","資料","資料分析","資料探勘","大資料","巨量資料","海量資料","data","analysis","hadoop","spark","scala","hdfs","hive","pig")

rownumber <- c()

for(i in 1:length(step3ConvertUTF8)){
  
  for(j in 1:length(step3ConvertUTF8[,1])){
    #step3ConvertUTF8[[i]][[j]] <- iconv(step3ConvertUTF8[[i]][[j]],from="UTF-8",to="UTF-8")
    #print(paste(i,j,sep=" and "))
    if(any(target %in% segmentCN(step3ConvertUTF8[j,i]))){
      rownumber <<- c(rownumber,j) 
    }
  }
  print(i)
}

# 刪除重複出現的編號
uniqueRowNumber <-unique(rownumber) 
resultDF <- step3ConvertUTF8[uniqueRowNumber,]
saveRDS(resultDF,"E://LBH//afterFirstTMDataFrame.RDS")
saveRDS(uniqueRowNumber,"E://LBH//afterFirstTMrowNumber.RDS")
###################################################################

# 第二次篩選
# 成果不理想，沒有挑出許多公司
#
#
secondTarget <- c("數據分析","大數據","數據探勘","巨量數據","海量數據","資料分析","資料探勘","大資料","巨量資料","海量資料","data","analysis","hadoop","spark","scala","R","hdfs","hive","pig")
resultDF <- readRDS("E://LBH//afterFirstTMDataFrame.RDS")
secondRowNumber<-c()
for(i in 1:length(resultDF)){
  for(j in 1:length(resultDF[,1])){
    if(any(secondTarget %in% segmentCN(resultDF[j,i]))){
      secondRowNumber <<- c(secondRowNumber,j) 
    }
  }
  print(i)
}
secondResultDF <- resultDF[secondRowNumber,]



###################################################################

# 第三次篩選
# 之後可考慮加入關鍵字：資料採礦、巨量資料分析


thirdTarget <- c("數據分析","大數據","數據探勘","數據挖掘","巨量數據","海量數據","資料分析",
                 "資料探勘","大資料","巨量資料","海量資料","data","Data","analysis","Analysis",
                 "hadoop","Hadoop","HADOOP","spark","Spark","SPARK","scala","Scala","SCALA",
                 "R","hdfs","Hdfs","HDFS","hive","Hive","HIVE","pig","Pig","PIG")

thirdRowNumber <- c()

for(i in 1:length(step3ConvertUTF8)){
  
  for(j in 1:length(step3ConvertUTF8[,1])){
    #step3ConvertUTF8[[i]][[j]] <- iconv(step3ConvertUTF8[[i]][[j]],from="UTF-8",to="UTF-8")
    #print(paste(i,j,sep=" and "))
    if(any(thirdTarget %in% segmentCN(step3ConvertUTF8[j,i]))){
      thirdRowNumber <<- c(thirdRowNumber,j) 
    }
  }
  print(i)
}
thirdUniqueRowNumber <-unique(thirdRowNumber) 
thirdResultDF <- step3ConvertUTF8[thirdUniqueRowNumber,]

#####################################################################

# 第四次篩選
# 挑出精確職缺

fourthTarget <- c("數據分析","大數據","數據探勘","數據挖掘","巨量數據","海量數據","資料分析",
                 "資料探勘","大資料","巨量資料","海量資料","data","Data","analysis","Analysis",
                 "hadoop","Hadoop","HADOOP","spark","Spark","SPARK","scala","Scala","SCALA",
                 "R","hdfs","Hdfs","HDFS","hive","Hive","HIVE","pig","Pig","PIG")

finalResultDF <- data.frame(ADDRESS="",ADDR_INDZONE="",ADDR_NO_DESCRIPT="",INDCAT="",JOB="",JOBCAT_DESCRIPT="",LINK="",NAME="",OTHERS="",PRODUCT="",PROFILE="",stringsAsFactors=F)
for(i in unique(thirdResultDF[["NAME"]])){
  finalResultDF <- rbind(finalResultDF,unique(thirdResultDF[thirdResultDF[["NAME"]]==i,]))
}
  
testDF<- unique(thirdResultDF[thirdResultDF[["NAME"]]=="邑泰科技股份有限公司",])

########################################################################

# 20152239

fifthTarget <- c("數據分析","大數據","數據探勘","數據挖掘","巨量數據","海量數據","資料分析",
                 "資料探勘","大資料","巨量資料","海量資料","數據採礦","資料採礦",
                 "data","Data","analysis","Analysis","hadoop","Hadoop","HADOOP",
                 "spark","Spark","SPARK","scala","Scala","SCALA","R","hdfs","Hdfs","HDFS",
                 "hive","Hive","HIVE","pig","Pig","PIG")
fifthRowNumber <- c()

for(i in 1:length(step3ConvertUTF8)){
  
  for(j in 1:length(step3ConvertUTF8[,1])){
    #step3ConvertUTF8[[i]][[j]] <- iconv(step3ConvertUTF8[[i]][[j]],from="UTF-8",to="UTF-8")
    #print(paste(i,j,sep=" and "))
    if(any(fifthTarget %in% segmentCN(step3ConvertUTF8[j,i]))){
      fifthRowNumber <<- c(fifthRowNumber,j) 
    }
  }
  print(i)
}
fifthUniqueRowNumber <-unique(fifthRowNumber) 
fifthResultDF <- step3ConvertUTF8[fifthUniqueRowNumber,]

finalResultDF <- data.frame(ADDRESS="",ADDR_INDZONE="",ADDR_NO_DESCRIPT="",INDCAT="",JOB="",JOBCAT_DESCRIPT="",LINK="",NAME="",OTHERS="",PRODUCT="",PROFILE="",stringsAsFactors=F)
for(i in unique(fifthResultDF[["NAME"]])){
  finalResultDF <- rbind(finalResultDF,unique(fifthResultDF[fifthResultDF[["NAME"]]==i,]))
}
finalResultDF[,9]
