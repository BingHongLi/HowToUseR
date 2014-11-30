mySshUsername<-"cloudera"
#public facing cluster IP address
#mySshHostname<-"192.168.56.2"
myShareDir<-paste("/var/RevoShare",mySshUsername,sep="/")
myHdfsShareDir<-paste("/user/RevoShare",mySshUsername,sep="/")
myHadoopCluster<-RxHadoopMR(
	hdfsShareDir=myHdfsShareDir,
	shareDir = myShareDir,
	sshUsername = mySshUsername,
	sshHostname = "CDH4.7Cluster",
	sshClientDir = "D:\\putty",
	consoleOutput = T
	)

bigDataDirRoot <- "/share"
rxSetComputeContext(myHadoopCluster)
source <- system.file("SampleData/AirlineDemoSmall.csv", package="RevoScaleR")
inputDir <- file.path(bigDataDirRoot,"AirlineDemoSmall")
rxHadoopMakeDir(inputDir)
rxHadoopCopyFromClient(source=source,hdfsDest=inputDir)
# rxHadoopCommand("fs -mkdir -p /airOnTime12/CSV")
# rxHadoopMakeDir("/share/airOnTime12/CSV")
# rxHadoopListFiles("/share")
# rxHadoopCopyFromClient(source="D:/DataSet/airOT2012/*",hdfsDest="/share/airOnTime12/CSV")
hdfsFS <- RxHdfsFileSystem()
colInfo <- list(DayOfWeek = list(type = "factor",
levels = c("Monday", "Tuesday", "Wednesday", "Thursday", 
"Friday", "Saturday", "Sunday")))
airDS <- RxTextData(file = inputDir, missingValueString = "M", 
colInfo = colInfo, fileSystem = hdfsFS) 
adsSummary <- rxSummary(~ArrDelay+CRSDepTime+DayOfWeek,data = airDS)
adsSummary
rxExec(list.files)

###############################################################
arrDelayLm1 <- rxLinMod(ArrDelay ~ DayOfWeek, data = airDS)
#summary(arrDelayLm1)
###############################################################


