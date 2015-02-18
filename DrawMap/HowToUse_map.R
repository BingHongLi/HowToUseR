###繪製地圖




###

## 繪製台灣地圖

if(!require("sp")){install.packages("sp")}
if(!require("RColorBrewer")){install.packages("RColorBrewer")}

con <- url("http://biogeo.ucdavis.edu/data/gadm2/R/TWN_adm2.RData")
print(load(con))
close(con)

# plot Taiwan with random colors, length of the vector taiwan is 21
taiwan <- c("高雄市","台北市","彰化縣","嘉義縣","新竹縣","花蓮縣","宜蘭縣","高雄縣","基隆市","苗栗縣","南投縣","澎湖縣","屏東縣","台中縣","台中市","台南縣","台南市","新北市","台東縣","桃園縣","雲林縣")
gadm$NAME_2 <- as.factor(taiwan)
col = rainbow(length(levels(gadm$NAME_2)))
spplot(gadm, "NAME_2", col.regions=col, main="Taiwan Regions", colorkey = FALSE, lwd=.4, col=grey(.9))


###