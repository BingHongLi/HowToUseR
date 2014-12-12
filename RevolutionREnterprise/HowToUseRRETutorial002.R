sampleDataDir <- rxGetOption("sampleDataDir")
inputFile<-file.path(sampleDataDir,"AirlineDemoSmall.csv")

# 資料匯入
# 要提升讀取及轉xdf的速度,不要用stringsAsFactor=T,改設colInfo,事先設定好欄位的屬性。
airDS<-rxImport(
	inData=inputFile,
	outFile="ADS.xdf",
	missingValueString="M",
	stringsAsFactor=T,
	overwrite=T,
	transforms=list(
		Result=ifelse(ArrDelay>0,1,0),
		forDelete=ArrDelay-(ArrDelay-1)
		)
	)

# 若xdf已存在，則可直接讀取，不要透過rxImport轉檔再讀取
# http://www.rdocumentation.org/packages/RevoScaleR/functions/RxXdfData
airDS<-RxXdfData(
	file="ADS.xdf",
	stringsAsFactors=T
	)

# 若抵死不從，不想使用xdf，可視檔案類型，去選擇要用來讀取資料的函數
airDS<-RxTextData(
	file=inputFile
	)

# 資料探索
# ncol(airDS)
# nrow(airDS)
# head(airDS)
rxGetInfo(airDS,getVarInfo=T,numRows=6)

# 看所有變數的敘述統計量
rxSummary(~.,data=airDS)

# 看DayOfWeek該變數的敘述統計量
rxSummary(~DayOfWeek,data=airDS)

# 看DayOfWeek為bala時的ArrDelay的敘述統計量
rxSummary(~ArrDelay:DayOfWeek,data=airDS)
rxSummary(ArrDelay~DayOfWeek,data=airDS)

rxHistogram(~DayOfWeek,data=airDS)
rxHistogram(~CRSDepTime|DayOfWeek,data=airDS)

# 資料整理，使用varsToKeep參數與varsToDrop參數時，輸入檔案與輸出檔案不得一樣
# 不輸入outFile時，函數會回傳data.frame，data.frame載入即占用記憶體空間。 
# http://www.rdocumentation.org/packages/RevoScaleR/functions/rxDataStep
airDS<-rxDataStep(
	inData=airDS,
	outFile="temp.xdf",
	#varsToKeep=c("ArrDelay","CRSDepTime","DayOfWeek","Result"),
	varsToDrop=c("forDelete"),
	overwrite=T
	)


# 資料分析
# logitObj<-rxLogit(Result~DayOfWeek+CRSDepTime+ArrDelay,data=airDS,cube=T)
# summary(logitObj)
# glmObj<-rxGlm(ArrDelay~DayOfWeek+CRSDepTime,data=airDS,cube=T)
# summary(glmObj)
lmObj<-rxLinMod(ArrDelay~CRSDepTime+I(CRSDepTime^2),data=airDS)
summary(lmObj)
# rxDTree(Result ~ DayOfWeek+CRSDepTime, data = airDS,cp=0.01)
