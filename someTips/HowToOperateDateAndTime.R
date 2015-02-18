########################
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