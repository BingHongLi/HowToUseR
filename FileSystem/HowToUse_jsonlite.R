#
# https://www.opencpu.org/posts/jsonlite-a-smarter-json-encoder/

# The primary goal in the design of jsonlite is to recognize and comply with conventional ways of encoding data in JSON (outside the R community)

if(!require("jsonlite")){
  install.packages("jsonlite")
  library("jsonlite")
}

# 將Data.fram資料轉為JSON
myJson <- toJSON(iris,pretty=T)
cat(myJson) 

# 將JSON轉為Data.frame
iris2 <- fromJSON(myJson)
print(iris2)
