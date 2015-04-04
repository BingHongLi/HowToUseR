
# 判斷 系統是否有此套件
if(!require("rjson")){install.packages("rjson")}

# 讀取json
test <- list()
for( i in 1:length(readLines("testbank.json"))){
  test[[i]] <- fromJSON(paste(readLines("testbank.json"))[i])
}

# 將message欄位抽出來變成data.frame
documentDataFrame <- data.frame(rep(0,length(test)))

for(i in 1:length(test)){
  documentDataFrame[i,1] <-test[[i]]$message 
}

# 斷詞

# 載入中文分詞套件
if (!require(rJava)) install.packages("rJava")
if (!require(Rwordseg)) install.packages("Rwordseg")

# 載入字典檔
options(dic.dir="./dic/")
loadDict()


# 製作TFIDF

# 製作欄名為字典詞名，值全為零的matrix
test2 <- iconv(readLines("./dic//dic_total.dic"),from="utf8",to="utf8")
tfidfDF <- matrix(rep(0,length(test2)*nrow(documentDataFrame)),nrow=nrow(documentDataFrame),ncol=length(test2))
colnames(tfidfDF) <- test2

# 比對，若字典有在切割後的字串出現過，則該文本的該欄位值為1
for (i in 1:length(test)) {
  # 對文本切詞
  try <- segmentCN(documentDataFrame[i,1])
  # 調閱字典檔的詞是否有在文本已切好的詞庫內
  target <- which(colnames(tfidfDF) %in% try)
  if(length(target)!=0){
    # 若有則加一
    tfidfDF[i,target]=tfidfDF[i,target]=1
  }
}

# kmean 分群
# 設定中心點數
clusterNumber <- 9
result <- kmeans(tfidfDF,centers=clusterNumber)
final <- list()
for(i in 1:clusterNumber){
  final[[i]] <- documentDataFrame[which(result$cluster==i),1]
}

 

