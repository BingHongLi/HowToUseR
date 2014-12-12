###展示用rxExec一次下載多個檔案
# install.package("downloader")
library(downloader)
rxSetComputeContext(RxLocalParallel())
t1<-c("http://packages.revolutionanalytics.com/datasets/AirOnTimeCSV2012/airOT201201.csv","D:/LBH/1.csv")
t2<-c("http://packages.revolutionanalytics.com/datasets/AirOnTimeCSV2012/airOT201202.csv","D:/LBH/2.csv")
rxExec(download,elemArgs=list(t1,t2),elemType="cores")


###展示用rxExec對某向量進行抽樣,並計算均值,以參數的方式傳輸物件至其他核心內運算
# 亂數生成1600個0~1間的值
set.seed(2123)
t3<-runif(1600) 
# 設定ComputeContext為單機平行運算
rxSetComputeContext(RxLocalParallel())
sampleCalculateMean<-function(vector){
	#set.seed(1234) #單機測試用
	temp<-sample(0:1,size=1600,replace=T)
	totalElement<-vector[which(temp==1)]
	mean(totalElement)
}
rxExec(sampleCalculateMean,t3,elemType="cores",timesToRun=2,RNGseed=3213)


###展示rxExec以非參數的方式,傳輸資料至其他核心內做運算
# 亂數生成1600個0~1間的值
set.seed(2123)
t3<-runif(1600) 
# 設定ComputeContext為單機平行運算
rxSetComputeContext(RxLocalParallel())
sampleCalculateMean<-function(){
	#set.seed(1234) #單機測試用
	temp<-sample(0:1,size=1600,replace=T)
	totalElement<-t3[which(temp==1)]
	mean(totalElement)
}
rxExec(sampleCalculateMean,elemType="cores",timesToRun=2,RNGseed=3213,execObjects=c("t3"))

