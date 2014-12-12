# 請先至 http://packages.revolutionanalytics.com/datasets/ 
# 下載mortDefault.zip，並解壓縮。
# install.package("downloader")
# library(downloader)
# source<-"http://packages.revolutionanalytics.com/datasets/mortDefault.zip"
# destFile <-"D:/mortDefault.zip"
# download(url=source, destfile="D:/mortDefault.zip")
# unzip(zipfile=destFile,overwrite=T,exdir="D:/LBH/mortDefault")

# 匯入檔案,並且合併為xdf檔
bigDataDir<-"D:/LBH/mortDefault"
mortCsvDataName<-file.path(bigDataDir,"mortDefault")
mortXdfFileName<-"D:/LBH/mortDefault.xdf"
append<-"none"
for(i in 2000:2009){
	importFile<-paste(mortCsvDataName,i,".csv",sep="")
	rxImport(
		inData=importFile,
		outFile=mortXdfFileName,
		append=append
		)
	append="rows"
}

# 讀入xdf檔案
mortDS<-RxXdfData(mortXdfFileName)

# 資料探索
summary(mortDS)
rxGetInfo(mortDS,getVarInfo=T,numRows=5)

rxSummary(~.,data=mortDS,blocksPerRead=10)
rxSummary(~creditScore+houseAge,data=mortDS)
rxSummary(creditScore~F(year),data=mortDS)
rxHistogram(~creditScore|F(year),data=mortDS)
rxSummary(~F(year):F(default),data=mortDS)

# 資料整理

# 新增變數

rxDataStep(
	inData=mortDS,
	outFile=mortXdfFileName,
	transforms=list(
		test=houseAge+10,
		test2=cut(creditScore,breaks=c(250,500,750,1000)),
		test3=cut(creditScore,breaks=c(250,500,750,1000),labels=c("差","普通","好")),
		test4=ifelse(houseAge>20,1,0)
		),
	overwrite=T
	)
rxGetInfo(mortDS,getVarInfo=T,numRows=6)


# 刪除變數
# 若inData與outFile所指的檔案是同一個檔案,則無法刪除,不可以在讀取該檔案時,又刪除該檔案.

rxDataStep(
	inData=mortDS,
	outFile="D:/LBH/temp.xdf",
	varsToDrop=c("test","test2","test3","test4"),
	overwrite=T
	)
rxDataStep(
	inData="D:/LBH/temp.xdf",
	outFile=mortDS,
	overwrite=T
	)
rxGetInfo(mortDS,getVarInfo=T,numRows=6)

# 抽出部分樣本
rxDataStep(
	inData=mortDS,
	outFile=mortDS,
	rowSelection = houseAge>15,
	overwrite=T
	)
rxGetInfo(mortDS,getVarInfo=T,numRows=6)

rxDataStep(
	inData=mortDS,
	outFile=mortDS,
	rowSelection = (seq(from=.rxStartRow,length.out=.rxNumRows)%%10==0),
	overwrite=T
	)

# 切資料 rxSplit
rxSplit(
	inData=mortDS,
	numOutFiles=10,
	splitBy="rows",
	rowsPerRead=1000000
	)

splitTrainAndTest <- rxSplit(
	inData=mortDS,
	splitByFactor="testSplitVar",
	transforms=list(
		testSplitVar=factor(
			sample(0:1,size=.rxNumRows,replace=T,prob=c(.1,.9)),
			levels=0:1,
			labels=c("Test","Train")
			)
		),
	overwrite=T
	)
rxSummary(~.,data=splitTrainAndTest[[1]])
rxSummary(~.,data=splitTrainAndTest[[2]])
# 排序資料 rxSort 建議以creditScore
mortSort<-rxSort(
	inData=mortDS,
	outFile="D:/LBH/moreDefaultSort.xdf",
	sortByVars=c("yearsEmploy","creditScore"),
	overwrite=T
	)


# 重整資料Block
rxGetInfo(mortDS,getVarInfo=T,numRows=6,getBlockSizes=T)
# rxQuantile


# 資料分析 Logistic Regression 
logitObj<-rxLogit(default~F(year)+creditScore+yearsEmploy+ccDebt,data=mortDS,blocksPerRead=2,reportProgress=1,cube=T)
summary(logitObj)

# 
system.time(
	logitObj <- rxLogit(
		default~F(houseAge)+F(year)+creditScore+yearsEmploy+ccDebt,
		data=mortDS,
		blocksPerRead=2,
		reportProgress=1
		)
	)
cc <- coef(logitObj)
df<-data.frame(Coefficient=cc[2:41],houseAge=0:39)
rxLinePlot(Coefficient~houseAge,data=df)

predictDF<-data.frame(
	creditScore=rep(c(300,700),times=16),
	yearsEmploy=rep(c(2,8),times=16),
	ccDebt=rep(c(5000,10000),times=16),
	year= rep(c(2008,2009),times=16),
	houseAge=rep(c(5,20),times=16)
	)
resultDF<-rxPredict(
	modelObject=logitObj,
	data=predictDF,
	writeModelVars=T
	)

