sampleDataDir <- rxGetOption("sampleDataDir")
inputFile<-file.path(sampleDataDir,"AirlineDemoSmall.csv")

# ��ƶפJ
# �n����Ū������xdf���t��,���n��stringsAsFactor=T,��]colInfo,�ƥ��]�w�n��쪺�ݩʡC
airDS<-rxImport(
	inData=inputFile,
	outFile="ADS.xdf",
	missingValueString="M",
	stringsAsFactor=T,
	overwrite=T,
	transforms=list(
		Result=ifelse(ArrDelay>0,1,0),
		forDelete=ArrDelay-(ArrDelay-1)
		)
	)

# �Yxdf�w�s�b�A�h�i����Ū���A���n�z�LrxImport���ɦAŪ��
# http://www.rdocumentation.org/packages/RevoScaleR/functions/RxXdfData
airDS<-RxXdfData(
	file="ADS.xdf",
	stringsAsFactors=T
	)

# �Y�覺���q�A���Q�ϥ�xdf�A�i���ɮ������A�h��ܭn�Ψ�Ū����ƪ����
airDS<-RxTextData(
	file=inputFile
	)

# ��Ʊ���
# ncol(airDS)
# nrow(airDS)
# head(airDS)
rxGetInfo(airDS,getVarInfo=T,numRows=6)

# �ݩҦ��ܼƪ��ԭz�έp�q
rxSummary(~.,data=airDS)

# ��DayOfWeek���ܼƪ��ԭz�έp�q
rxSummary(~DayOfWeek,data=airDS)

# ��DayOfWeek��bala�ɪ�ArrDelay���ԭz�έp�q
rxSummary(~ArrDelay:DayOfWeek,data=airDS)
rxSummary(ArrDelay~DayOfWeek,data=airDS)

rxHistogram(~DayOfWeek,data=airDS)
rxHistogram(~CRSDepTime|DayOfWeek,data=airDS)

# ��ƾ�z�A�ϥ�varsToKeep�ѼƻPvarsToDrop�ѼƮɡA��J�ɮ׻P��X�ɮפ��o�@��
# ����JoutFile�ɡA��Ʒ|�^��data.frame�Adata.frame���J�Y�e�ΰO����Ŷ��C 
# http://www.rdocumentation.org/packages/RevoScaleR/functions/rxDataStep
airDS<-rxDataStep(
	inData=airDS,
	outFile="temp.xdf",
	#varsToKeep=c("ArrDelay","CRSDepTime","DayOfWeek","Result"),
	varsToDrop=c("forDelete"),
	overwrite=T
	)


# ��Ƥ��R
# logitObj<-rxLogit(Result~DayOfWeek+CRSDepTime+ArrDelay,data=airDS,cube=T)
# summary(logitObj)
# glmObj<-rxGlm(ArrDelay~DayOfWeek+CRSDepTime,data=airDS,cube=T)
# summary(glmObj)
lmObj<-rxLinMod(ArrDelay~CRSDepTime+I(CRSDepTime^2),data=airDS)
summary(lmObj)
# rxDTree(Result ~ DayOfWeek+CRSDepTime, data = airDS,cp=0.01)