##############################################
### Analysis Step
### 1.Specify the NameNode
### 2.Create a compute context for Hadoop
### 3.Copy a data set into the HDFS
### 4.Create a date source
### 5.Summarize your data
### 6.Fit a linear model to the data
### 7.Analyzing a Large Data Set With RevoScaleR
### 7-1 取得資料及上傳至hdfs
### 
### 補充 Create a Non-waiting Compute Context(暫略)
### 補充 提取hdfs資料以單台電腦算
### 補充 在Hadoop平台上做資料清洗
##############################################
 
### Create a compute context for hadoop
# RRE客戶端可透過本機RRE，並透過SSH協定去連線至Hadoop叢集其中一台node的RRE，
# 以該node去跟叢集進行溝通，使用叢集資源進行運算。
# 連入node之前，必須先確認客戶端是否有下載Putty，若無請上網進行下載
# 客戶端是否已有該node的private key，並透過Putty由客戶端不輸入密碼連線至node
# 若無，請先設定

# RRE有三種設定連線至node，這裡採先透過Putty儲存可連線的資訊後，RRE會自行開啟Putty進行連線的方式

# 欲連線的node之使用者帳號
mySshUsername<-"cloudera"
# 存在putty內的session名稱
mySshHostname<-"CDH4.7Cluster"
# 在node本地端那邊供RRE存取的資料夾路徑，請勿更動此行
myShareDir <- paste("/var/RevoShare",mySshUsername,sep="/")
# 在hdfs供RRE存取的資料夾路徑，請勿更動此行
myHdfsShareDir <-paste("/user/RevoShare",mySshUsername,sep="/")

# 新增一個ComputeContext，忘記參數內容請自己上Rdocument查，對自己有好處，可了解該函數
# sshClientDir 請設定你putty的儲存路徑
myHadoopCluster <- RxHadoopMR(
	hdfsShareDir=myShareDir,
	shareDir=myShareDir,
	sshUsername=mySshUsername,
	sshHostname=mySshHostname,
	sshClientDir="D:\\putty"
	)

# 告訴RRE 他必須要計算的ComputeContext為myHadoopCluster
rxSetComputeContext(myHadoopCluster)

# Copying a Data File into the Hadoop Distributed File System
# 為了要達到分散運算，把資料存入Hdfs為必要的動作
# 此處可設定把node的native File System 內的檔案copy進入HDFS，
# 亦可從客戶端將檔案傳入node，再由node傳入HDFS
# 若要從客戶端傳檔案至HDFS請使用 rxHadoopCopyFromClient()
# rxHadoopCopyFromClient(source=source,hdfsDest=inputDir)
# 參數source為檔案來源，參數hdfsDest為要存在hdfs的位置

# 此處先以RRE內的範例檔案做示範，從node內的原生系統傳入HDFS做說明

# 先確認檔案是否存在(非必要步驟，故註解，有需要使用再使用即可)，若回傳True，則存在
# file.exists(system.file("SampleData/AirlineDemoSmall.csv"),package="RevoScaleR")

# 設定存入Hdfs的位置，RRE設計理念是把要運算的檔案存入Hdfs的/share資料夾，各node的RRE會從此資料夾讀資料
bigDataDirRoot <-"/share"

# 要把檔案存入某資料夾內時，必須先確認該資料夾是否存在。
# 可用rxHadoopCommand("hadoop的原生指令")，或用RRE內建的查詢函數
rxHadoopListFiles(bigDataDirRoot)

# 若Hdfs內不存在/share/AirlineDemoSmall資料夾則執行以下註解指令
# 標記native system檔案位置
# source <- system.file("SampleData/AirlineDemoSmall.csv",package="RevoScaleR")
# 預設檔案存放路徑
# inputDir <- file.path(bigDataDirRoot,"AirlineDemoSmall")
# 在Hdfs依照剛預設的路徑建立資料夾
# rxHadoopMakeDir(inputDir)
# 把nativeFileSystem的file複製進Hdfs
# 若是用client端把資料複製進hdfs則使用rxHadoopCopyFromClient(source,hdfsDest)
# rxHadoopCopyFromLocal(source,inputDir)
# 查閱Hdfs內/share資料夾下的檔案
# rxHadoopListFiles(inputDir)

###########################################################

### Creating a Data Source
# RRE預設會先搜尋local端的nativeFileSystem，
# 若要RRE預設去找其他檔案系統的話可使用rxSetFileSystem()
# 此處使用另外一種方式，計算或執行其他動作時，再指定要尋找的fileSystem
hdfsFS<-RxHdfsFileSystem() 

# 為資料的變數設定好基本資訊，可節省運算時間
colInfo<- list(
	DayOfWeek=list(
		type="factor",
		levels=c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")
		)
	)

# 檔案是csv，屬文字型資料，故使用RxTextData函數去告知RRE這是文字資料，
# file : 此文字資料的檔案路徑
# missingValueString : 對於遺漏值的表示從NA改成指定的字元
# colInfo : 資料內變數的資訊，可不設，讓RRE自動偵測
# fileSystem : 指定去何個檔案系統找尋檔案
airDS <- RxTextData(
	file=inputDir,
	missingValueString="M",
	colInfo=colInfo,
	fileSystem=hdfsFS
	)
###############################################

### Summarizing Your Data
# 對資料做敘述性統計
adsSummary<-rxSummary(~ArrDelay+CRSDepTime+DayOfWeek,data=airDS)
adsSummary

###############################################

### Fitting a Linear Model

arrDelayLm1 <-rxLinMod(ArrDelay~DayOfWeek,data=airDS)
summary(arrDelayLm1)

###############################################

### Create a Non-Waiting Compute Context



###############################################

### 7-1 取得資料及上傳至hdfs
# 先去下載下面網頁的所有資料
# http://packages.revolutionanalytics.com/datasets/AirOnTimeCSV2012/
# 下載好，放入hdfs內的/share/airOnTime12/CSV，不會放，請參考簡報。

airDataDir <- file.path(bigDataDirRoot,"/airOnTime12/CSV")
### 7-2 設定欄位資訊 加速運算效率
airlineColInfo <- list(
	MONTH = list(newName = "Month", type = "integer"),
	DAY_OF_WEEK = list(
		newName = "DayOfWeek", type = "factor",
		levels = as.character(1:7),
		newLevels = c("Mon", "Tues", "Wed", "Thur", "Fri", "Sat","Sun")
		),
	UNIQUE_CARRIER = list(
		newName = "UniqueCarrier", type = 
		"factor"
		),
	ORIGIN = list(
		newName = "Origin", 
		type = "factor"
		),
	DEST = list(
		newName = "Dest", 
		type = "factor"
		),
	CRS_DEP_TIME = list(
		newName = "CRSDepTime", 
		type = "integer"
		),
	DEP_TIME = list(
		newName = "DepTime", 
		type = "integer"
		),
	DEP_DELAY = list(
		newName = "DepDelay", 
		type = "integer"
		),
	DEP_DELAY_NEW = list(
		newName = "DepDelayMinutes", 
		type = "integer"
		),
	DEP_DEL15 = list(
		newName = "DepDel15", 
		type = "logical"
		),
	DEP_DELAY_GROUP = list(
		newName = "DepDelayGroups", 
		type = "factor",
		levels = as.character(-2:12),
		newLevels = c(
			"< -15", "-15 to -1","0 to 14", "15 to 29",
			"30 to 44", "45 to 59", "60 to 74",
			"75 to 89", "90 to 104", "105 to 119",
			"120 to 134", "135 to 149", "150 to 164",
			"165 to 179", ">= 180")
		),
	ARR_DELAY = list(
		newName = "ArrDelay", 
		type = "integer"
		),
	ARR_DELAY_NEW = list(
		newName = "ArrDelayMinutes", 
		type = "integer"
		),
	ARR_DEL15 = list(
		newName = "ArrDel15", 
		type = "logical"
		),
	AIR_TIME = list(
		newName = "AirTime", 
		type =  "integer"
		),
	DISTANCE = list(
		newName = "Distance",
 		type = "integer"
		),
	DISTANCE_GROUP = list(
		newName = "DistanceGroup", 
		type = "factor",
		levels = as.character(1:11),
		newLevels = c(
			"< 250", "250-499", "500-749", "750-999",
			"1000-1249", "1250-1499", "1500-1749", "1750-1999",
			"2000-2249", "2250-2499", ">= 2500")
		)
	) 
varNames<-names(airlineColInfo)
# 7-3 設定檔案來源
hdfsFS<-RxHdfsFileSystem()
bigAirDS<-RxTextData(
	airDataDir,
	colInfo=airlineColInfo,
	varsToKeep=varNames,
	fileSystem=hdfsFS
	)
# 7-4 線性迴歸
# 建模並紀錄花費時間
system.time(
	delayArr<-rxLinMod(
		ArrDelay~DayOfWeek,
		data=bigAirDS,
		cube=T
		)
	)
summary(delayArr)

# 7-5 Importing Data As Composite XDF Files
# 在RRE，推薦使用的檔案格式為xdf，可提升資料在硬碟與記憶體間的交換速度
# 詳見簡報的介紹，在Hadoop把檔案存為xdf格式，會是以set的方式儲存，副檔名為xdfd與xdfm
# xdfm為名冊，讓系統知道檔案在哪個節點上。
# 現在示範把多個csv檔轉為一個Composite Xdf File
bigAirXdfName<-"/user/RevoShare/cloudera/AirlineOnTime2012"
airData<-RxXdfData(bigAirXdfName,fileSystem=hdfsFS)
blockSize<-250000
numRowsToRead=-1
rxImport(
	inData=bigAirDS,
	outFile=airData,
	rowsPerRead=blockSize,
	overwrite=T,
	numRows=numRowsToRead
	)

# 7-6 用組合xdf檔再執行一次線性回歸
system.time(
	delayArr<-rxLinMod(
		ArrDelay~DayOfWeek,
		data=airData,
		cube=T
		)
	)
print(
	summary(delayArr)
	)
### 7.7 Prediction on Large Data
# 一般會將分析資料切成三份(建模、調整、測試)或兩份(建模、測試)
# modelObject 為 用來預測的模型，data為要用來生成預測結果的data
rxPredict(
	modelObject=delayArr,
	data=airData,
	overwrite=T
	)
# 請注意 使用rxPredict，輸入資料可為csv檔，
# 但輸出資料必定為xdf格式，故如果希望將rxPredict的結果output出去，
# 請在rxPrexdict函數內加進outData參數，並且outData參數所接收的物件必須為RxXdfData物件

#LBHTest<-RxXdfData("/user/RevoShare/cloudera/LBHTest",fileSystem=hdfsFS)
#rxPredict(
#	modelObject=delayArr,
#	data=airData,
#	outData=LBHTest,
#	overwrite=T
#	)

###############################################

# 補充,有時資料量並不是很大，用分散運算，速度反而比從HDFS提取資料到本機端做運算來得慢
# 以下範例為從hdfs提取資料進本端作運算
rxSetComputeContext("local")
inputFile<-file.path(bigDataDirRoot,"AirlineDemoSmall/AirlineDemoSmall.csv")
airDSLocal<-RxTextData(file=inputFile,missingValueString="M",colInfo=colInfo,fileSystem=hdfsFS)
adsSummary<-rxSummary(~ArrDelay+CRSDepTime+DayOfWeek,data=airDSLocal)
adsSummary
rxSetComputeContext(myHadoopCluster)

###############################################

### 補充 在Hadoop平台上做資料清洗
# 對資料作清洗，刪除不要的欄位或有時使用rxPredict()函數沒指定outData，此時預測後的結果會複寫至原資料
# 若不想要預測後的結果殘留在原資料上，亦可使用此步驟

newAirDir<-"/user/RevoShare/cloudera/newAirData"
newAirXdf<-RxXdfData(newAirDir,fileSystem=hdfsFS)
rxDataStep(
	inData=airData,
	outFile=newAirXdf,
	varsToDrop=c("ArrDel15_Pred","ArrDel15_Resid"),
	rowSelection=!is.na(ArrDelay)&(DepDelay>-60)
	)