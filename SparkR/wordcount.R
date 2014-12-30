# 簡易安裝及註解 李秉鴻
# 如有錯誤或指教, 煩請寄信
# b97607065@gmail.com

# 引用資料: SparkR 之開發github,
# 安裝檔  : 引用DockerHub內beniyama先生的spark與rstudio安裝檔
# https://github.com/amplab-extras/SparkR-pkg/blob/master/examples/wordcount.R
# https://github.com/beniyama/sparkr-docker

# 安裝, 作業系統建議使用clouderaQuickstartVM, 並安裝docker, 在linux執行下方兩行指令
# sudo yum install http://mirrors.yun-idc.com/epel/6/i386/epel-release-6-8.noarch.rpm
# sudo yum install docker-io

# 至 https://github.com/beniyama/sparkr-docker 依照指令下載
# sudo docker pull beniyama/sparkr-docker
# sudo docker run -d -p <YOUR PORT>:8787 -t beniyama/sparkr-docker

# 載入SparkR package
library(SparkR)

# 建立一個spark context
# http://<ip:port>/help/library/SparkR/html/sparkR.init.html
sc<-sparkR.init("local")

# 將資料載入至context, 並建立一個RDD
# http://<ip:port>/help/library/SparkR/html/textFile.html
# textFile函數可從HDFS, 本地檔案系統或any Hadoop-supported file system URI 建立一個RDD 
lines<-textFile(sc,"test.txt")

# 將一個RDD內所有元素依照function的指示去處理, 並將產生的結果以list的方式回傳. 
# 以空白做切割符號, 切割該RDD內每一行, strsplit是R用作切字串的一個函數.
# http://<ip:port>/help/library/SparkR/html/flatMap.html
words <- flatMap(
          lines,
          function(line){
            strsplit(line," ")[[1]]
          }
         )
# collect(words)

# 此lapply非R原生的lapply, 但功能與原生R的lapply相似, 
# 使用者將此lapply當為對list內的元素依照函數內要求做處理即可
# 此動作是將每一個單字以鍵值方式呈現 <k,v> => <word,1>
# 將原有RDD經transformation後成為一個新的RDD
# http://<ip:port>/help/library/SparkR/html/lapply.html
wordCount <- lapply(
              words,
              function(word){
                list(word,1L)  
              }
             )


# 依照Key去將資料彙整, 並且依照an associative reduce function將每一筆<k,v>資料的value合併
# reduceByKey(rdd, combineFunc, numPartitions)
# http://<ip:port>/help/library/SparkR/html/reduceByKey.html
counts<- reduceByKey(wordCount,"+",2L)

# 到這個動作之前, 都僅是紀錄動作, 而未執行, 到collectc後, Spark才開始真正執行指令
# 並回傳一個list裡面會包含函數內RDD的所有元素
# collect returns a list that contains all of the elements in this RDD. 
# http://<ip:port>/help/library/SparkR/html/collect.html
output<-collect(counts)

# 列出所有值
for(wordcount in output){
  cat(wordcount[[1]], ": ", wordcount[[2]], "\n")
}