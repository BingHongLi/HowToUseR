################ CH3 Some Tips On R Reference Classes######################################################################################
#
# The PEMA classes used in RevoPemaR are based on R Reference Classes. 
# We include a brief overview of some tips for using R Reference Classes here, 
# before moving to the specifics of the PEMA classes.
#
###########################################################################################################################################
# R Reference Class objects are created using a generator function. 
#
# This function has four important pieces of information:
#
# The name of the class
# The inheritance of the class, that is, the superclasses of the class. Fields and methods of parent reference classes are inherited.
# The fields or member variables. These fields are accessed by reference, so values of the fields for an object of this class can change
# The methods of the class. These are functions that can be invoked by objects of this class, which might change values of the fields
#
###########################################################################################################################################
# When working with reference classes, here are a few tips to keep in mind
#
# Reference class generators are created using setRefClass. For the PEMA classes, we will use a wrapper for that function, setPemaClass
# Field values are changed within methods using the non-local assignment operator (<<-)
# Methods are documented internally with an initial line of text, rather than in an .Rd file. This information is accessed using the $help method for the generator function.
# The reference class object can be accessed in the methods using .self
# The parent method can be accessed using .callSuper
# Use the usingMethods call to declare that a method will be used by another method.
# The code for a method can be displayed using an instantiated reference class object, e.g. myRefClassObj$initialize
#
###########################################################################################################################################
### CH4 A Tutorial introduction to RevoPemaR

### CH4.1 Using setPemaClass to Create a Class Generator P.6

# Start by making sure that the RevoPemaR packages is loaded:
library(RevoPemaR)

# To create a PEMA class generator function, use the setPemaClass function
# setPemaClass, It is a wrapper function for setRefClass.
# As with setRefClass, 
# we will specify four basic pieces of information when using setPemaClass: 
# the class name, the superclasses, the fields, and the methods.

PemaMean<-setPemaClass(
	Class="PemaMean",
	contains="PemaBaseClass",
	fields=list(),
	methods=list()
	)
# The Class is the class name of your choice.
# The contains argument must specify PemaBaseClass or a child class of PemaBaseClass.

### CH4.1.1 Specifying the fields for PemaMean P.7
# The fileds or member variables of our class represent all of the variables 
# we need in order to compute and store our intermediate and final results.

#field=list(
#	sum="numeric",
#	totalObs="numeric",
#	totalValidObs="numeric",
#	mean="numeric",
#	varName="character"
#	)

PemaMean<-setPemaClass(
	Class="PemaMean",
	contains="PemaBaseClass",
	field=list(
		sum="numeric",
		totalObs="numeric",
		totalValidObs="numeric",
		mean="numeric",
		varName="character"
	),
	methods=list()
	)

### CH4.1.2 An Overview of the methods for PemaMean P.7
# There are five methods we will specify for PemaMean.
# These methods are all in the PemaBaseClass, and need to be overloaded for any custom analysis.

# initialize     : initializes field values.
# processData    : processes a chunk of data and updates field values
# updateResults  : updates the field values of a PEMA class object from another
# processResults : computes the final results from the final intermediate results
# getVarsToUse   : the names of the variables in the dataset used for analysis

### CH4.1.3 The initialize method P.7
# The primary use of the initialize method is to initialize field values.
# The one field that is initialized with user input 
# in this example is the name of the variable to use in the computations, varName.
# Use of the ellipses in the function signature allows for initialization values to be passed up to the parent class using .callSuper
# the first action in the initialize method after the documentation. 

methods = list(
	# The initialize method P.7
	initialize=function(varName="",...){
		' sum, totalValidObs, and mean are all initialized to 0'
		# callSuper calls the initialize method of the parent class
		callSuper(...)
		
		# The pemaSetClass function also provides addtional functionality used in the initialize method to ensure that all of the methods of the class
		# and its parent classes are included when an object is serialized. This is critical for distributed computing.
		# To use this functionality, add the following to the initialize method:
		usingMethods(.pemaMethods)
		# If we do not want to use this functionality we can omit this line 
		# and set includeMethods to FALSE in setPemaClass 
		varName<<-varName
		sum<<-0
		totalObs<<-0
		totalValidObs<<-0
		mean<<-0
		},
	# The processData method P.8
	processData=function(dataList){
		# The processData method is the core of an external memory algorithm.
		# It process a chunk of data and computes intermediate results, updating the field value(s).	
		# It takes as an argument a rectangular list  of data vectors; 
		# typically only the variable(s) of interest will be included.
		'Updates the sum and total observations from the current chunk of data. '
		sum<<-sum+sum(as.numeric(dataList[[varName]]),na.rm=T)
		totalObs<<-totalObs+length(dataList[[varName]])
		totalValidObs<<-totalValidObs+sum(!is.na(dataList[[varName]]))
		invisible(NULL)	
		},
	# The updateResults method P.8
	# It is the key method used when computations are done in parallel. Consider the following scenario:
	# 1) The master node on a cluster assigns each worker the task of processing a series of chunks of data.
 	# 2) The workers do so in parallel, each with their own instantiation of  a reference class object.
	#    Each worker calls processData for each chunk it need to process.
	#    In each call, the values of the fields of its reference class object are updated.
	# 3) Now the master process must collect the information from each of the nodes 
	#    and update all of the information in a single reference class object.
	#    This is done using the updateResults method,
	#    which takes as an argument another instance of the reference class.
	#    The reference class object from each of the nodes is processed by the master node,
	#    resulting in the final intermediate results in the master node's reference class object's fields
	updateResults=function(pemaMeanObj){
		'Update the sum and total observations from another PemaMean object.'	
		sum<<-sum+pemaMeanObj$sum
		totalObs<<-totalObs+pemaMeanObj$totalObs
		totalValidObs<<-totalValidObs+pemaMeanObj$totalValidObs
		invisible(NULL)
		},
	# The processResults method P.9
	# The processResults performs any necessary computations to produce the final result from the accumulated intermediate results.
	processResults=function(){
		'Returns the sum divided by the totalValidObs.'
		if(totalValidObs>0){
			mean<<-sum/totalValidObs
			}else{
				mean<<-as.numeric(NA)
			}
		return(mean)
		},
	# The getVarsToUse method P.9
	# The getVarsToUse method specifies the names of the variables in the dataset that are used in the analysis.
	# Specifying this information can improve performance if reading data from disk.
	getVarsToUse=function(){
		
		'Returns the varName'
		varName
		} # End of methods
	
	)# End of class generator

### CH4.2 Creating and Using a PemaMean Reference Class Object P.10

### CH4.2.2 Using a PemaMean Object with the pemaCompute Function P.11
# The pemaCompute function takes two required arguments: an "analysis" object and a data source object.
# The analysis object must be generated by setPemaClass and inherit (directly or indirectly) from PemaBaseClass.
# The data source object must be either a data frame or a data source object supported by the RevoScaleR packages if it is available.
# The ellipses will take any additional information used in the initialize method.
set.seed(67)
pemaCompute(pemaObj=meanPemaObj,data=data.frame(x=rnorm(1000)),varName="x")

# By default the pemaCompute method will reinitialize the pemaObj. 
# By setting the initPema flag to FALSE, we can add more data to our analysis:
pemaCompute(
	pemaObj=meanPemaObj,
	data=data.frame(x=rnorm(1000)),
	varName="x",
	initPema=F
	)
# Note that the number of total valid observations is now 2000.
meanPemaObj$totalValidObs

### CH4.2.3 Using a RevoScaleR Data Source with pemaCompute Function P.13
# In the previous section we analysed data in memory. 
# The RevoScaleR package provides a data source framework that allows data to be automatically extracted in chunks from data on disk or in a database.
# It also provides the .xdf file format that can very efficiently extract chunks of data.

airXdf<-RxXdfData(file.path(rxGetOption("sampleDataDir"),"AirlineDemoSmall.xdf"))

# Using the meanPemaObj created above, we compute the mean of the variable ArrDelay(the arrival delay in minutes)
# The data in this file is stored in three blocks, with 200,000 rows in each block. 
# The pemaCompute function will process these chunks one at a time
pemaCompute(meanPemaObj,data=airXdf,varName="ArrDelay")

# we can control the amount of progress reported to the console using the reportProgress field of PemaBaseClass

### CH5 Additional Example Using RevoPemaR P.14

# A number of examples are provided in the demoScripts directory of the RevoPemaR package.
# we can find the location of this directory by entering


