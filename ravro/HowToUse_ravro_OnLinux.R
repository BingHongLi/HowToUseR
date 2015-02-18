##### HowToUse_ravro_OnLinux


if (!require(Rcpp)) install.packages("Rcpp")
if (!require(rjson)) install.packages("rjson")
if (!require(bit64)) install.packages("bit64")
# if (!require(ravro)) install.packages("ravro")

############################################################################################################################

# on singleNode
setwd("./forMount/")


# origin file size is 46kb
#avro_make_schema(test,name="test")
test<-read.csv("GitHub/HowToUseR/ravro/data/LOG141006-161641.csv",stringsAsFactor=F,header=T) 
write.avro(test,file="GitHub/HowToUseR/ravro/example.avro",name="example1",namespace="example",codec="snappy",unflatten=F)
readExample <- read.avro("GitHub/HowToUseR/ravro/example.avro")


# origin 
test2<-read.csv("GitHub/HowToUseR/ravro/data/Log_20150126131953_Unknown Road_test2_0_18_0.csv",stringsAsFactor=F,header=T) 
write.avro(test,file="GitHub/HowToUseR/ravro/example2.avro",name="example2",namespace="example2",codec="snappy",unflatten=F)
readExample <- read.avro("GitHub/HowToUseR/ravro/example2.avro")



###########################################################################
testDF <- iris
write.avro(testDF,file="GitHub/HowToUseR/ravro/test.avro",namespace="test")
readDF <- read.avro("GitHub/HowToUseR/ravro/test.avro")
###########################################################################