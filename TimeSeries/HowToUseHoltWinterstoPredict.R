ORIGINDATA <- read.csv('SteamPrice16.csv',header=T,stringsAsFactors=F)

test <- ORIGINDATA[1,2:1000]
test <- test[!is.na(test)]
testTS <- ts(test,frequency=30)
plot.ts(testTS)
#testForecast <- HoltWinters(testTS,beta=F,gamma=F)
testForecast <- HoltWinters(testTS,beta=T,gamma=T)
#library(forecast)
testForecast20 <- forecast.HoltWinters(testForecast,h=20)
plot.forecast(testForecast20)
testForecast20


testSMA <- SMA(testTS,n=100)
plot.ts(testSMA)

# Examine error 
acf(testForecast20$residuals,lag.max=20)
Box.test(testForecast20$residuals,lag=20,type="Ljung-Box")
plot.ts(testForecast20$residuals)