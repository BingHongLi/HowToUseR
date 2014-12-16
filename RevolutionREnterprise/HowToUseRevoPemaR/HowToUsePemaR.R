###HowToUsePemaR

# �ͦ�R Reference Class objects �����ϥΤ@�ӥͦ����,
# �Ӧ���Ƥ��|�]�t�F�|�ӭ��n����T
# 1. �����O���W��
# 2. �����O�O�~�ө�������O, �~�����O�|�~�ӸӨǨ��~�����O����k�P�����ܼ�  
# 3. �ӨǦ����ܼƨ��o�O�H by reference ���覡�A�G�����O�����ܼƪ�value�i�H�ܧ�
# 4. The methods of the class. These are functions that can be invoked by objects of this class
#    which might change values of the fields

# ���ϥθӨ�reference class, �Ъ`�N�U���X�I

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
			# �I�s�����O����k�A�Ϫ���i�N��ƤW�Ǧܤ����O���ܼƤ�
			callSuper(...)
			# �ϥΤ����O����k�A�Ϥ��i�����B��
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

# �i�ݥXPemaMeans�����Ҧ�����k(�]�A�~��)
PemaMean$methods()

# �Y�Q�ݸ����O��k���ԭz�A�i�p���g
PemaMean$help(initialize)

# �ͦ�PemaMean��������A�R�W��meanPemaObj
meanPemaObj<-PemaMean()

# Using a PemaMean Object with the pemaCompute Function P.12
# pemaCompute ��Ƥ��������ӰѼơA
# �@�Ӭ����R��k��pemaObject�A�ݬO��setPemaClass�ͦ��B�����ζ����~�ө�pemaBaseClass
# �@�Ӭ���ƨӷ�(data source)�A�i��data.frame��RevoScaleR�Ҥ䴩��data source
# �t�~�ٻݩ�n�����R��k�p�⪺�ܼƦW��

set.seed(67)
pemaCompute(pemaObj=meanPemaObj,data=data.frame(x=rnorm(1000)),varName="x")

# ��meanPemaObj���s���p��ɡA�w�]�ܼƭȷ|�M�šA����i�W�[initPema�ѼƬ�F�A�ϭȤ��Q�b�šC
pemaCompute(pemaObj=meanPemaObj,data=data.frame(x=rnorm(1000)),varName="x", initPema=F)
meanPemaObj$totalValidObs

# �ϥ�RevoScaleR Data Source with the pemaCompute Function

airXdf<-RxXdfData(file.path(rxGetOption("sampleDataDir"),"AirlineDemoSmall.xdf"))
pemaCompute(meanPemaObj,data=airXdf,varName="ArrDelay")	

######################################################################################

# �ۧڽm�� �p���ܲ���
# �����JRevoPemaR�]
library(RevoPemaR)

# �إ�PemaVar���O, 
# �����ܼƦ�totalObs, totalValidObs, tempDistance, variance, varName, 
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
			'�]�w�ܼơA�N�����ܼƲM�šA�ﳡ���ܼƽ��'
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
			'�p���[���ƶq�B�����[���ƶq�� �[��ȻP���Ȭ۴�᪺����'
			totalObs<<-totalObs+length(dataList[[varName]])
			totalValidObs<<-totalValidObs+sum(!is.na(dataList[[varName]]))
			tempDistance<<-tempDistance+sum((dataList[[varName]]-mean)^2)
			invisible(NULL)	
		},
		updateResults=function(pemaVarObj){
			'�J�`�Ҧ��[���ƶq�B�����[���ƶq�� �[��ȻP���Ȭ۴�᪺����'
			totalObs<<-totalObs+pemaVarObj$totalObs
			totalValidObs<<-totalValidObs+pemaVarObj$totalValidObs
			tempDistance<<-tempDistance+pemaVarObj$tempDistance
			invisible(NULL)	
		},
		processResults=function(){
			'�N�Ҧ��[��ȻP���Ȭ۴�᪺���谣�H�����[��ƶq�o���ܲ���'
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

# �ͦ�����
varPemaObj<-PemaVar()
# �]�w�ؤl��
set.seed(67)
pemaCompute(pemaObj=varPemaObj,data=data.frame(x=rnorm(1000)),varName="x",mean=test)

## �������
set.seed(67)
test2<-data.frame(x=rnorm(1000))
var(test2[["x"]])
mean(test2[["x"]])
