
# 判斷 系統是否有此套件
if(!require("rjson")){install.packages("rjson")}

test <- list()
for( i in 1:length(readLines("testbank.json"))){
  test[[i]] <- fromJSON(paste(readLines("testbank.json"))[i])
}


