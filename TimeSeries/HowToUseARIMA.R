#### ARIMA(p,d,q)  page 39
## d為差分的階數

### 時間序列差分
## 若時間序列為非平穩的時間序列，則需要做時間序列差分直到得到一個平穩時間序列
## 在R中可使用diff()函數作時間序列的差分
skirtsseriesdiff1 <- diff(skirtsseries,differences=1)
plot.ts(skirtsseriesdiff1)
# 圖形顯示不夠平穩，再做一次差分
skirtsseriesdiff2 <- diff(skirtsseries,differences=2)
plot.ts(skirtsseriesdiff2)

## 對於平穩性正式的檢驗 單位根測試 可在fUnitRoots包中得到

### 尋找ARIMA(p,d,q)的p值 以國王去世年齡為例

## 下載資料→時間序列化→平穩時間序列(差分)→選擇合適的ARIMA模型
kings <- scan("http://robjhyndman.com/tsdldata/misc/kings.dat",skip=3)
kingstimeseries <- ts(kings)
# 一階差分，並繪圖，發現平穩
kingtimeseriesdiff1 <- diff(kingstimeseries,differences=1)
plot.ts(kingtimeseriesdiff1)
# 找出p值，q值，需檢查平穩時間序列的(自)相關圖，運用acf()與pacf()分別




