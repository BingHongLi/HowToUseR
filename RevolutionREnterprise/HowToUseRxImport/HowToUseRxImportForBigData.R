##############################################################################
###
### Revolution R Enterprise �j�ƾڶפJ
### �����E
### �Ĵ����
### 
### 0.�e��
### 1.��{������
### 2.����5000�H�U
### 3.����5000��10000
### 4.����10000�H�W
###
### �ѦҸ��
### http://www.rdocumentation.org/packages/RevoScaleR/functions/rxImport
### http://www.rdocumentation.org/packages/RevoScaleR/functions/RxTextData
### https://revolutionanalytics.zendesk.com/entries/28416923-Change-variable-type-within-xdf-type-
##############################################################################
#
# 0.�e��
#
# ���g�@�ơA�����@���A�G�M�H���@���٬O�n�ݭn�g�窺�C
# ���ǫܦh�H�����w�ΫD�}���n��A�n����~�A�����W�S�S�������T�ɡA�߰ݵ��f�S�ܳ·Ю�
# �u�n����l�X�ʸ����F�A���䤣���l�X���ɭԡA�N�|�ܷF�F�C
#
# rxImport�b���w�qtype�����p�U�A�u����10000����쪺xdf��
# �p�G�S���w�qtype��, �S�Q�פJ�W�L10000����쪺�ɮ׮�
# �|�X�{ERROR : Line length is too long
# �|�X�{Error : rxCall("Rx_ImportDataSource",params)
#
##############################################################################
#
# 1.��{������
#
# ��ĳ�פJ�ɮ׫e�A���T�{���ӼơA�ڭ̥i�H����Ū�@��A�A�z�L���ΡA�ӽT�{��쪺�h��
# 
# varNamesTemp<-readLines("stage531_Indicator.csv",n=1)
# varName<-strSplit(VarNamesTemp,",")[[1]]
#
# ���E���w�g�F�@�Ө�ơA�Ȼݸ��J,�Y�i�ΨӧP�_�ɮת����Ӽ�,�u�n�]�w�ɮ׸��|�Τ��Φr�ꪺ�Ÿ��A
# �Y�i�P�_�ɮת����ƤΦ^�����W�١A���L�Ĥ@���ܼƦW�P�̫�@���ܼƦW�|�S�����ΰ��b�C
specifyColumnNums<-function(fileName,delimiter="\",\""){
	varNamesTemp<-readLines(fileName,n=1)
	varName<-strsplit(varNamesTemp,delimiter)[[1]]
	return(list(nums=length(varName),varName=varName))	
}
#
##############################################################################
# 
# 2.����5000�H�U
# 
# �����ϥ�rxImport(inData,outFile)
# �Yı�oŪ���t�׹L�C�A�i�Ѧ�3.����5000��10000���ާ@��k
#
##############################################################################
#
# 3.����5000��10000
#
# ���i�H�����ϥ�rxImport(inData,outFile) 
# �����ӷ|����P��t�פW���t���A����ڭ̥i�H��ĥΥ�Ū���p���������ܤ@��dataFrame,
# �A��dataFrame������ƪ��[��xdf�ɮסA�קK�C��Ū���Ҧ����y�����ɶ����O
# 
#varNamesTemp<-readLines("stage504_Indicator.csv",n=1)
#varNames<-strsplit(varNamesTemp,",")[[1]]
#colsPerRead<-1000
#numReadsFromFile<-ceiling(length(varNames)/colsPerRead)
#file.remove("stage504_Indicator.xdf")
#for(i in 1:numReadsFromFile){
#	tempDF<-rxImport(
#		inData="stage504_Indicator.csv",
#		varsToKeep=paste(varNames[(((i-1)*colsPerRead)+1):((((i-1)*colsPerRead)+1)+colsPerRead)],sep=","),
#		rowsPerRead=50)
#	
#	#targetXdf<-RxXdfData("stage504_Indicator.xdf")
#	if(!file.exists("stage504_Indicator.xdf")){
#		rxDataFrameToXdf(data=tempDF,outFile="stage504_Indicator.xdf")
#	}else{
#		rxDataFrameToXdf(data=tempDF,outFile="stage504_Indicator.xdf",append="cols",overwrite=T)
#	}
#}
# �w�N�y�{�]�i�ۭq��Ƥ��A�Ȼݳ]�w��J��ơB��X��ơB�C��Ū����쪺�ƶq(�w�]1000)�B�C��Ū���h�֦C�ƤΤ��βŸ�(�w�]��,)
rxImportCutColumn<-function(inData,outFile,colsPerRead=1000,rowsPerRead=50,sep=",",type="auto"){
	
	# Ū���ɮת��Ĥ@��(���]�Ĥ@�槡�����Y�ɡA�brxImport�n���ӷ��@�ܼƦW)
	varNamesTemp<-readLines(inData,n=1)
	# �NŪ�����Ĥ@��A���]�w�����βŸ������ΡC
	varNames<-strsplit(varNamesTemp,sep)[[1]]	
	# �]�w�C��Ū�J��쪺�ƶq
	colsPerRead<-colsPerRead
	# ����`�ư��H�C��Ū�J���ơA�D�o�`�@Ū�ɪ�����
	numReadsFromFile<-ceiling(length(varNames)/colsPerRead)
	# �������Ӧs�b���ɮסC
	file.remove(inData)	
	
	# ��X�ɮת��������A����s��dataFrame�A�A��dataFrame�s�i�ؼ�xdf��		
	for(i in 1:numReadsFromFile){
		
		# Ū����ơA��s��dataFrame�A
		# varsToKeep�����ΰʡA�C���j��|�۰ʧ�s�n��������
		tempDF<-rxImport(
			inData=inData,
			varsToKeep=paste(varNames[(((i-1)*colsPerRead)+1):((((i-1)*colsPerRead)+1)+colsPerRead)],sep=sep),
			rowsPerRead=rowsPerRead,
			type=type
			)
		
		# �˴��ɮ׬O�_�s�b�A�Y���s�b�h����else,�|�s�ؤ@��xdf�F�Y�s�b�h���Jif�B�J
		# �i����[���
		if(file.exists(inData)){
			# overwrite=T, �p�G����쭫�ơA�s�i�����|���N�¦����ۦP���
			rxDataFrameToXdf(data=tempDF,outFile=inData,append="cols",overwrite=T)
		}else{
			rxDataFrameToXdf(data=tempDF,outFile=inData)
		}
	}
}

###############################################################################
#
# 4.���ƶW�L10000
# 
# �YŪ���ɮ׬�csv����r�ɮ׮ɡA�ϥ�rxImport�ɡA�}�ҰѼ�type="text"�AŪ���t�׷|���C�A
# ���iŪ���W�L�@�U�����H�W���ɮסC
rxImport("stage642_Indicator.csv","stage642_Indicator.xdf",type="text")
 
 