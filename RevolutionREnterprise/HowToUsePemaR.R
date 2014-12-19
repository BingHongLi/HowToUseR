###HowToUsePemaR

# 生成R Reference Class objects 必須使用一個生成函數,
# 而此函數內會包含了四個重要的資訊
# 1. 此類別的名稱
# 2. 此類別是繼承於哪個類別, 繼承類別會繼承該些受繼承類別的方法與成員變數  
# 3. 該些成員變數取得是以 by reference 的方式，故該類別物件的變數的value可以變更
# 4. The methods of the class. These are functions that can be invoked by objects of this class
#    which might change values of the fields

# 當使用該些reference class, 請注意下面幾點

# Reference class generators are created using setRefClass. For the PEMA classes, 
# we will use a wrapper for that function, setPemaClass.

# Field values are changed within methods using the non-local assignment operator (<<-)

# Methods are documented  internally  with an initial line of text, rather than in an
# .Rd file. This information is  accessed using the $help method for the generator 
# function. 

# The reference class object can be accessed in  the methods using .self

# The parent method can be accessed using  .callSuper

# Use the usingMethods call to declare that a method will be used by another method. 

# The code for a method can be displayed using an instantiated reference class 
# object, e.g. myRefClassObj$initialize.

library(RevoPemaR)

PemaMean <- setPemaClass(
	Class="PemaMean",
	contains="PemaBaseClass",
	fields=list(
		sum="numeric",
		totalObs="numeric",
		totalValidObs="numeric",
		mean="numeric",
		varName="character"
		),
	method=list(
		initialize=function(varName="",...){
			'Sum, totalValidObs, and mean are all initialized to 0'
			# callSuper calls the initialize method of the parent classs
			# 呼叫父類別的方法，使物件可將資料上傳至父類別的變數內
			callSuper(...)
			# 使用父類別的方法，使之可分散運算
			usingMethods(.pemaMethods)
			varName<<-varName
			sum<<-0
			totalValidObs<<-0
			totalObs<<-0
			mean<<-0
		},
		processData=function(dataList){
			'Updates the sum and total observations from the current chunk of data'			
			sum<<-sum+sum(as.numeric(dataList[[varName]]),na.rm=T)
			totalObs<<-totalObs+length(dataList[[varName]])
			totalValidObs<<-totalValidObs+sum(!is.na(dataList[[varName]]))
			invisible(NULL)
		},
		updateResults=function(pemaMeanObj){	
			'Updates the sum and total observations from another PemaMean object.'	
			sum<<-sum+pemaMeanObj$sum
			totalObs<<-totalObs+pemaMeanObj$totalObs
			totalValidObs<<-totalValidObs+pemaMeanObj$totalValidObs
			invisible(NULL)
		},
		processResults=function(){
			'Return the sum divided by the totalValidObs.'
			if (totalValidObs>0){
				mean<<-sum/totalValidObs	
			}else{
				mean<<-as.numeric(NA)
			}
			return(mean)		
		},
		getVarsToUse=function(){
			'Return the varName.'
			varName	
		}
	)#End of methods
)# End of class generator 

# 可看出PemaMeans此類所有的方法(包括繼承)
PemaMean$methods()

# 若想看該類別方法的詳述，可如此寫
PemaMean$help(initialize)

# 生成PemaMean類的物件，命名為meanPemaObj
meanPemaObj<-PemaMean()

# Using a PemaMean Object with the pemaCompute Function P.12
# pemaCompute 函數內必須放兩個參數，
# 一個為分析方法的pemaObject，需是由setPemaClass生成且直接或間接繼承於pemaBaseClass
# 一個為資料來源(data source)，可為data.frame或RevoScaleR所支援的data source
# 另外還需放要此分析方法計算的變數名稱

set.seed(67)
pemaCompute(pemaObj=meanPemaObj,data=data.frame(x=rnorm(1000)),varName="x")

# 對meanPemaObj重新做計算時，預設變數值會清空，但亦可增加initPema參數為F，使值不被淨空。
pemaCompute(pemaObj=meanPemaObj,data=data.frame(x=rnorm(1000)),varName="x", initPema=F)
meanPemaObj$totalValidObs

# 使用RevoScaleR Data Source with the pemaCompute Function

airXdf<-RxXdfData(file.path(rxGetOption("sampleDataDir"),"AirlineDemoSmall.xdf"))
pemaCompute(meanPemaObj,data=airXdf,varName="ArrDelay")	

######################################################################################

# 自我練習 計算變異數
# 先載入RevoPemaR包
library(RevoPemaR)

# 建立PemaVar類別, 
# 成員變數有totalObs, totalValidObs, tempDistance, variance, varName, 
#
PemaVar<-setPemaClass(
	Class="PemaVar",
	contain="PemaBaseClass",
	fields=list(
		totalObs="numeric",
		totalValidObs="numeric",
		tempDistance="numeric",
		variance="numeric",
		varName="character",
		mean="numeric"
	),
	methods=list(
		initialize=function(varName="",mean=0,...){
			'設定變數，將部分變數清空，對部分變數賦值'
			callSuper(...)
			usingMethods(.pemaMethods)
			totalObs<<-0
			totalValidObs<<-0
			tempDistance<<-0
			variance<<-0
			varName<<-varName
			mean<<-mean
		},
		processData=function(dataList){
			'計算觀測數量、有效觀測數量及 觀察值與均值相減後的平方'
			totalObs<<-totalObs+length(dataList[[varName]])
			totalValidObs<<-totalValidObs+sum(!is.na(dataList[[varName]]))
			tempDistance<<-tempDistance+sum((dataList[[varName]]-mean)^2)
			invisible(NULL)	
		},
		updateResults=function(pemaVarObj){
			'彙總所有觀測數量、有效觀測數量及 觀察值與均值相減後的平方'
			totalObs<<-totalObs+pemaVarObj$totalObs
			totalValidObs<<-totalValidObs+pemaVarObj$totalValidObs
			tempDistance<<-tempDistance+pemaVarObj$tempDistance
			invisible(NULL)	
		},
		processResults=function(){
			'將所有觀察值與均值相減後的平方除以有效觀察數量得到變異數'
			if (totalValidObs>0){
				variance<<-tempDistance/totalValidObs	
			}else{
				variance<<-as.numeric(NA)
			}
			return(variance)
		},
		getVarToUse=function(){
			varName
		}
	)	
)

# 生成物件
varPemaObj<-PemaVar()
# 設定種子數
set.seed(67)
pemaCompute(pemaObj=varPemaObj,data=data.frame(x=rnorm(1000)),varName="x",mean=test)

## 比較答案
set.seed(67)
test2<-data.frame(x=rnorm(1000))
var(test2[["x"]])
mean(test2[["x"]])

