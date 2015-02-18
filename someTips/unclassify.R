source("http://d396qusza40orc.cloudfront.net/rprog%2Fscripts%2Fsubmitscript1.R")
submit()

#############

library(swirl)
swirl()

#############
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

##############
# Sequences of Numbers 

# 從0到10，每0.5個間距跳一次
seq(0,10,by=0.5)

# 從5到10，平均切出30個值
seq(5,10,length=30)

# 依照my_seq物件的個數產生連續數值
seq(along.with=my_seq)
seq_along(my_seq)

# 重複產生數值，並指定產生次數
rep(0,times=40)
rep(c(0,1,2),times=10)

# 重複產生某數列的個別值，並指定產生次數
rep(c(0,1,2),each=10)

#######################
# Vectors

# 輸入單一個向量，做字串黏貼
paste(my_char, collapse = " ")

# 輸入多個字串，做字串黏貼
paste("Hello","world",sep=" ")

# 若輸入數字跟字串做黏貼，則會交互黏貼
paste(1:3,c("X","Y","Z"),sep="")

# 若兩條向量長度不等，做黏貼，短的會重複使用
paste(LETTERS, 1:4, sep = "-")
# LETTERS為預設向量

#######################
# Missing Values

# NA為Not Available
# NA大於0，故過濾時，會被挑出。
# NaN為 Not a Number


#######################
# Subsetting Vectors

# 檢驗兩個資料的欄位屬性是否相同
identical(vect,vect2)

#######################
# Matrices and Data Frames

# getOrSet維度
dim()

# attributes觀察屬性

# data.frame() 裡面可放單條向量與matrix，會自動整合成一個data.frame

# colnames() 更改dataframe欄位名

#######################
# Logic

# xor(x,y) x,y分別為一個邏輯表達式，若兩者的真偽相同，則傳回false

# which 傳回為True的index

# any 任意一個為True則傳回True

#0 all 必須所有值皆為True，方傳回True

########################
# lapply and sapply

# head() 看前面六筆資料

# lapply(x,Fun) 回傳list

# sapply(x,Fun) 
# | In general, if the result is a list where every element is of length one, then sapply() returns a vector. If the result is
# | a list where every element is a vector of the same length (> 1), sapply() returns a matrix. If sapply() can't figure
# | things out, then it just returns a list, no different from what lapply() would give you.

########################
# vapply and tapply

# | Whereas sapply() tries to 'guess' the correct format of the result, vapply() allows you to specify it explicitly. If the
# | result doesn't match the format you specify, vapply() will throw an error, causing the operation to stop. This can prevent
# | significant problems in your code that might be caused by getting unexpected return values from sapply().

#  vapply() may perform faster than sapply() for large datasets

# tapply(x,index,fun)
# ?tapply

#########################
# Looking at Data

# 查詢物件佔記憶體的大小
object.size(plants)

# head(), tail()觀察資料頭尾的長相

########################
# Simulation

# sample takes a sample of the specified size from the elements of x using either with or without replacement
# 當sample函數的size參數沒有被定義時，
sample()

# 依照binomial 分配產生亂數
rbinom()
# | Each probability distribution in R has an r*** function (for "random"), a d*** function (for "density"), 
# a p*** (for "probability"), and q*** (for "quantile"). We are most interested in the r*** functions in this lesson, but I encourage                                                                                                                   | "probability"), and q*** (for "quantile"). 
# We are most interested in the r*** functions in this lesson


rnorm(10)
# 按照常態分配，去分配十個亂數

rpois()
# 按照波式分配去產生亂數

colMeans()
# 針對欄位求均值

#########################
# Dates and Times


# "POSIXt", which just functions as a common language between POSIXct and POSIXlt.
Sys.Date()

# 將現在的時間換算成天數(以1970-01-01為基準)，
unclass(Sys.Date())

# 取得1970-01-01之前的時間
d2 <- as.Date("1969-01-01")

# 轉化成天數
unclass(d2)

# 未unclass前會得到 年-月-日 時間 地區
t1 <- Sys.time()

# 取得當前時間 類別為"POSIXCT" "POSIXt"
class(t1)

# 若對t1 進行unclass，會出現秒數
unclass(t1)

#
t2 <- as.POSIXlt(Sys.time())

# 發現已將格式轉為天數，
class(t2)

# 
unclass(t2) 

# 
str(unclass(t2))

# weekdays(), months(), and quarters() return the days of week,month and quarter,  from any date or time object
weekdays(d1)
months(d1)
quarters(d1)

# strptime() 可輸入字串及日期格式，辨認天(dates)跟時間(times)
t3 <- "October 17, 1986 08:24"
t4 <- strptime(t3, "%B%d,%Y%H:%M")
Sys.time() > t1
Sys.time() - t1
# 用天數來表達日期的差距
difftime(Sys.time(), t1, units = 'days')

# 進階用法 可參考lubridate package

############################
# Base Graphics

# | There is a school of thought that this approach is backwards, that we should teach ggplot2 first. See
# | http://varianceexplained.org/r/teach_ggplot2_to_beginners/ for an outline of this view.
# http://www.ling.upenn.edu/~joseff/rstudy/week4.html