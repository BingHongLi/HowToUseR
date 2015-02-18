###################
#檔案系統的操作

file.create("檔案名")
# 檢驗檔案名
file.exists("受檢驗檔案名")
# 觀看檔案資訊
file.info("檔案名")
# 更換檔案名
file.rename(from="",to="")
# 複製檔案
file.copy("mytest2.R","mytest3.R")
# 抓取檔案路徑
file.path("檔案名")
# 創建遞迴資料夾
dir.create("testdir2/testdir3",recursive=TRUE)
# 刪除資料夾
unlink("testdir2",recursive=TRUE)

