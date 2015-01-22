# 自設命名函數，path為檔案存放路徑，fileName為檔案名，fileType為檔案格式
autoFileName <-function(path=".//",fileName="forgetName",fileType=".RDS"){
  t <- Sys.time()
  timeStamp <- strftime(t,"%Y%m%d%H%M")
  completeFileName <- paste(path,fileName,timeStamp,fileType,sep="")
  completeFileName
} 