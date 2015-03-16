# R 中文分詞(科技部專案計畫)
# 設定工作路徑為專案目錄

# 載入中文分詞套件
if (!require(rJava)) install.packages("rJava")
if (!require(Rwordseg)) install.packages("Rwordseg")

# 載入要分割的檔案
textSource <- read.csv("./data/totalName.csv",stringsAsFactor=F)

# 載入字典檔
options(dic.dir="./dic/")
loadDict()

# 設定organizationName向量用來儲存分析後得到的機關名稱
# 設定otherName向量用來儲存分析後得到的單位名稱
# 設定temp向量用來暫存中文分詞後的結果，會轉存到organizationName與otherName向量
organizationName <- c()
otherName <- c()
temp <- c()

for(i in 1:length(textSource[,2])){
  # 對該列的第三行做分詞，並轉存至temp向量
  temp <- segmentCN(textSource[i,2])
  # 將temp的第一個值轉存至organizationName向量中
  organizationName <- c(organizationName,temp[1])
  
  # otherTemp欄位是為了該些僅有機關名而無單位名的資料所建立，預設為空值，若無單位名，則仍為空值
  # 若有值，則取代原本的空值，並將所有temp[2]以後的值相黏貼成為一個值(單位名稱)，存入otherName該向量中
  otherTemp <- c("")
  if(length(temp)>1){
    for(j in temp[2:length(temp)] ){ 
      otherTemp <- paste(otherTemp,j,sep="")
    }  
  }
  
  # 將新生成的otherTemp存入otherName向量中
  otherName <- c(otherName,otherTemp)
}


# 將organizationName與otherName兩條向量以data.frame方式儲存
textResultDF <- data.frame(organizationName,otherName)


