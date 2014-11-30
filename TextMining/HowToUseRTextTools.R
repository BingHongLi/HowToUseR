### RTextTools: A Supervised Learning Package for Text Classification
install.packages('RTextTools')
library(RTextTools)
## RTextTools was designed to make machine learning accessible by providing a start-to-finish product in less than 10 steps. 
# RTextTools 為機器學習套件，提供一個完整的流程作文字分類(不超過九個步驟)

## After installing RTextTools, 
## the initial step is to generate a document term matrix. 
## Second, a container object is created, which holds all the objects needed for further analysis. 
## Third, users can use up to nine algorithms to train their data.
## Fourth, the data are classified. 
## Fifth, the classification is summarized. 
## Sixth, functions are available for performance evaluation. 
## Seventh, ensemble agreement is conducted. 
## Eighth, users can cross-validate their data. 
## Finally, users write their data to a spreadsheet, allowing for further manual coding if required.
# 安裝RTextTools 套件之後，
# 第一個步驟是產生document term matrix
# 第二個步驟是建立一個容器，裡面將會有所有要用來做分析的物件
# 第三個步驟 使用者可使用九種演算法去建模
# 第四個步驟 對資料做分類
# 第五個步驟 對該分類模型做summarized
# 第六個步驟 評估函數的效能
# 第七個步驟 ensemble agreement is conducted
# 第八個步驟 使用交叉驗證的方式驗證模型
# 第九個步驟 對了未來可以繼續做其他的分析，使用者將資料寫入資料表內

### General workflow

## A user starts by loading his or her data from an Access, CSV, Excel file, or series of text files using the read_data() function. 
## We use a small and randomized subset of the congressional bills database constructed by Adler and Wilkerson (2004) for the running example offered here.
## 1. We choose this truncated dataset in order to minimize the amount of memory used, 
## which can rapidly overwhelm a computer when using large text corpora. 
## Most users therefore should be able to reproduce the example.

## However, the resulting predictions tend to improve (nonlinearly) with the size of the reference dataset,
## meaning that our results here are not as good as they would be using the full congressional bills dataset. 
## Computers with at least 4GB of memory should be able to run RTextTools on medium to large datasets (i.e., up to 30,000 texts) by using the three low-memory algorithms included: 
## general linearized models (Friedman et al., 2010) from the glmnet package, 
## maximum entropy (Jurka, 2012) from maxent, 
## and support vector machines (Meyer et al., 2012) from e1071. 
## For users with larger datasets, 
## we recommend a cloud computing service such as Amazon EC2.
# 取用小資料作範例，若要使用大資料建議去使用EC2的服務


### 1. Creating a matrix

## First, we load our data with data(USCongress), and use the tm package to create a document-term matrix. 
## The USCongress dataset comes with RTextTools and hence the function data　is relevant only to data emanating from R packages. 
## Researchers with data in Access, CSV, Excel, or　text files will want to load data via the read_data() function. 
## Several pre-processing options from the tm package are available at this stage, 
## including stripping whitespace, removing sparse terms, word stemming, and stopword removal for several languages.

## 2 We want readers to be able to reproduce our example, 
## so we set removeSparseTerms to .998, 
## which vastly reduces the size of the document-term matrix, 
## although it may also reduce accuracy in real-world applications. 
## Users should consult Feinerer et al. (2008) to take full advantage of preprocessing possibilities. 
## Finally, note that the text column can be encapsulated in a cbind() data frame, 
## which allows the user to perform supervised learning on multiple columns if necessary

# 建立Document Term Matrix
# create_matrix(資料來源，語系，功能)
data(USCongress)
## CREATE THE DOCUMENT-TERM MATRIX
doc_matrix <- create_matrix(USCongress$text, language="english", removeNumbers=TRUE,stemWords=TRUE, removeSparseTerms=.998)


### 2. Creating a container
## The matrix is then partitioned into a container, 
## which is essentially a list of objects that will be fed to the machine learning algorithms in the next step. 
## The output is of class matrix_container and includes separate train and test sparse matrices, 
## corresponding vectors of train and test codes, and a character vector of term label names. 
## Looking at the example below, doc_matrix is the document term matrix created in the previous step, 
## and USCongress$major is a vector of document labels taken from the USCongress dataset. 
## trainSize and testSize indicate which documents to put into the training set and test set, 
## respectively. The first 4,000 documents will be used to train the machine learning model, 
## and the last 449 documents will be set aside to test the model. 
## In principle, users do not have to store both documents and labels in a single dataset, 
## although it greatly simplifies the process. 
## So long as the documents correspond to the document labels via the trainSize and testSize parameters,
## create_container() will work properly. 
## Finally, the virgin parameter is set to FALSE 
## because we are still in the evaluation stage and not yet ready to classify virgin documents.

# 建立容器，裡面裝載第一步驟生成的矩陣，USCongress$major is a vector of document labels taken from the USCongress dataset
# 前四千筆作trainSet 後450 筆作testSet
container <- create_container(doc_matrix, USCongress$major, trainSize=1:4000,testSize=4001:4449, virgin=FALSE)

## From this point, users pass the container into every subsequent function. 
## An ensemble of up to nine algorithms can be trained and classified.
# 至此已可以開始使用演算法來train data


### 3. Training models

## The train_model() function takes each algorithm, one by one, 
## to produce an object passable to classify_model(). 
## A convenience train_models() function trains all models at once by passing in a vector of model requests.
## The syntax below demonstrates model creation for all nine algorithms. 
## For expediency, users replicating this analysis may want to use just the three low-memory algorithms:
## support vector machine (Meyer et al., 2012), 
## glmnet (Friedman et al., 2010), 
## and maximum entropy (Jurka, 2012).4 
## The other six algorithms include: 
## scaled linear discriminant analysis (slda) and 
## bagging (Peters and Hothorn, 2012) from ipred; 
## boosting (Tuszynski, 2012) from caTools; 
## random forest (Liaw and Wiener, 2002) from randomForest; 
## neural networks (Venables and Ripley, 2002) from nnet; 
## and classification or regression tree (Ripley., 2012) from tree. 
## Please see the aforementioned references to
## find out more about the specifics of these algorithms and the packages from which they originate.
## Finally, additional arguments can be passed to train_model() via the ... argument.

# 可使用九種方法去建模
SVM <- train_model(container,"SVM")          ## support vector machine (Meyer et al., 2012), 
GLMNET <- train_model(container,"GLMNET")    ## glmnet (Friedman et al., 2010),
MAXENT <- train_model(container,"MAXENT")    ## and maximum entropy (Jurka, 2012).4 
SLDA <- train_model(container,"SLDA")        ## scaled linear discriminant analysis (slda) and 
BOOSTING <- train_model(container,"BOOSTING")## boosting (Tuszynski, 2012) from caTools;
BAGGING <- train_model(container,"BAGGING")  ## bagging (Peters and Hothorn, 2012) from ipred;
RF <- train_model(container,"RF")            ## random forest (Liaw and Wiener, 2002) from randomForest;
NNET <- train_model(container,"NNET")        ## neural networks (Venables and Ripley, 2002) from nnet; 
TREE <- train_model(container,"TREE")        ## and classification or regression tree (Ripley., 2012) from tree. 


### 4. Classifying data using trained models
## The functions classify_model() and classify_models() use the same syntax as train_model().
## Each model created in the previous step is passed on to classify_model(), 
## which then returns the classified data.

SVM_CLASSIFY <- classify_model(container, SVM)
GLMNET_CLASSIFY <- classify_model(container, GLMNET)
MAXENT_CLASSIFY <- classify_model(container, MAXENT)
SLDA_CLASSIFY <- classify_model(container, SLDA)
BOOSTING_CLASSIFY <- classify_model(container, BOOSTING)
BAGGING_CLASSIFY <- classify_model(container, BAGGING)
RF_CLASSIFY <- classify_model(container, RF)
NNET_CLASSIFY <- classify_model(container, NNET)
TREE_CLASSIFY <- classify_model(container, TREE)


### 5. Analytics
## The most crucial step during the machine learning process is interpreting the results, 
## and RTextTools provides a function called create_analytics() 
## to help users understand the classification of their test set data. 
## The function returns a container with four different summaries: by label (e.g., topic), by algorithm, by document, and an ensemble summary.

## Each summary’s contents will differ depending on whether the virgin flag was set to TRUE or FALSE in the create_container() function in Step 3. 
## For example, when the virgin flag is set to FALSE, indicating that all data in the training and testing sets have corresponding labels, 
## create_analytics() will check the results of the learning algorithms against the true values to determine the accuracy of the process. 
## However, if the virgin flag is set to TRUE, indicating that the testing set is unclassified data with no known true values, 
## create_analytics() will return as much information as possible without comparing each predicted value to its true label.

# 讀至第五個步驟

analytics <- create_analytics(container,cbind(SVM_CLASSIFY, SLDA_CLASSIFY,
                                              BOOSTING_CLASSIFY, BAGGING_CLASSIFY,
                                              RF_CLASSIFY, GLMNET_CLASSIFY,
                                              NNET_CLASSIFY, TREE_CLASSIFY,
                                              MAXENT_CLASSIFY))

summary(analytics)

# CREATE THE data.frame SUMMARIES
topic_summary <- analytics@label_summary
alg_summary <- analytics@algorithm_summary
ens_summary <-analytics@ensemble_summary
doc_summary <- analytics@document_summary

### 6. Testing algorithm accuracy

### 7. Ensemble agreement
create_ensembleSummary(analytics@document_summary)

### 8. Cross validation
SVM <- cross_validate(container, 4, "SVM")
GLMNET <- cross_validate(container, 4, "GLMNET")
MAXENT <- cross_validate(container, 4, "MAXENT")
SLDA <- cross_validate(container, 4, "SLDA")
BAGGING <- cross_validate(container, 4, "BAGGING")
BOOSTING <- cross_validate(container, 4, "BOOSTING")
RF <- cross_validate(container, 4, "RF")
NNET <- cross_validate(container, 4, "NNET")
TREE <- cross_validate(container, 4, "TREE")

### 9. Exporting data
write.csv(analytics@document_summary, "DocumentSummary.csv")

