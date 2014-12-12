# install.packages("downloader")
library(downloader)
# source <- "packages.revolutionanalytics.com/datasets/AirOnTimeCSV2012/"
source<-"http://packages.revolutionanalytics.com/datasets/AirOnTimeCSV2012/airOT201201.csv"
download(url=source, destfile="D:/airOT201201.csv")