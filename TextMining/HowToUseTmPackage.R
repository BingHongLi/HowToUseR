
### Data Import

# VCorpus(x,readerControl)函數存在記憶體內，速度較快，缺點是記憶體內若有任一R物件損毀，亦會連帶影響到VCorpus不能使用
# PCorpus(x,readerControl)函數存在硬碟或資料庫內，速度較慢。

# corpus的建構子內，x為資料來源的路徑依形式分為DirSource VectorSource DataframeSource 或dataframe
# DirSource是設計為讀取資料夾內的檔案，VectorSource僅能接受為字串類向量，其他的方式則可以接收字串或檔案形態
## getSources() lists available sources, and users can create their own sources.

# 第二個引數readerControl為list，裡面放兩個引數 
# list內第一個引數用來設定閱讀器( readPlain(), readPDF(), readDOC(), . . .)
## See getReaders() for an up-to-date list of available readers. 
# list內第二個引數用來設定此文檔的語言類型(preferably using ISO 639-2 codes).

## In case of a permanent corpus, 
## a third argument dbControl has to be a list with the named components dbName giving the filename holding the sourced out objects 
## (i.e., the database), and dbType holding a valid database type as supported by package filehash. 
## Activated database support reduces the memory demand, however, 
## access gets slower since each operation is limited by the hard disk's read and write capabilities.
## So e.g., plain text files in the directory txt containing Latin (lat) texts by the Roman poet Ovid can be
## read in with following code:

#設定檔案路徑→轉入語料庫
txt <- system.file("texts", "txt", package = "tm")
(ovid <- VCorpus(DirSource(txt, encoding = "UTF-8"),readerControl = list(language = "lat")))

## For simple examples VectorSource is quite useful, 
## as it can create a corpus from character vectors, e.g
# VCorpus的運用
docs <- c("This is a text.", "This another one.")
VCorpus(VectorSource(docs))

## Finally we create a corpus for some Reuters documents as example for later use:
reut21578 <- system.file("texts", "crude", package = "tm")
reuters <- VCorpus(DirSource(reut21578),readerControl = list(reader = readReut21578XMLasPlain))

### Data Export
# 資料輸出

## For the case you have created a corpus via manipulating other objects in R, 
## thus do not have the texts already stored on a hard disk, and want to save the text documents to disk, 
## you can simply use writeCorpus()
## which writes a character representation of the documents in a corpus to multiple files on disk.
writeCorpus(ovid)

### Inspecting Corpora

## Custom print() methods are available which hide the raw amount of information 
## (consider a corpus could consist of several thousand documents, like a database).
## print() gives a concise overview whereas the full content of text documents is displayed with inspect().
inspect(ovid[1:2])

## Individual documents can be accessed via [[, either via the position in the corpus, or via their identifier.
meta(ovid[[2]], "id")
identical(ovid[[2]], ovid[["ovid_2.txt"]])

### Transformations
## Once we have a corpus we typically want to modify the documents in it, e.g., stemming, stopword removal,
## et cetera. In tm, all this functionality is subsumed into the concept of a transformation. Transformations are
## done via the tm_map() function which applies (maps) a function to all elements of the corpus. Basically, all
## transformations work on single text documents and tm_map() just applies them to all documents in a corpus.

## Eliminating Extra Whitespace
reuters <- tm_map(reuters, stripWhitespace)

## Convert to Lower Case
## which provides a convenience wrapper to access and
## set the content of a document. Consequently most text manipulation functions from base R can directly be used
## with this wrapper.
reuters <- tm_map(reuters, content_transformer(tolower))

## Remove Stopwords
reuters <- tm_map(reuters, removeWords, stopwords("english"))

## Stemming
tm_map(reuters, stemDocument)

### Filters
## Often it is of special interest to filter out documents satisfying given properties. 
## For this purpose the func-tion tm_filter is designed. 
## It is possible to write custom filter functions which get applied to each document in the corpus. 
## Alternatively, we can create indices based on selections and subset the corpus with them. 
## E.g., the following statement filters out those documents having an ID equal to "237" and the string
## "INDONESIA SEEN AT CROSSROADS OVER ECONOMIC CHANGE" as their heading.
idx <- meta(reuters, "id") == '237' & meta(reuters, "heading") == 'INDONESIA SEEN AT CROSSROADS OVER ECONOMIC CHANGE'
reuters[idx]

### Metadata Management
## Metadata is used to annotate text documents or whole corpora with additional information. 
## The easiest way to accomplish this with tm is to use the meta() function. 
## A text document has a few predefined attributes like author but can be extended with an arbitrary number of additional user-defined metadata tags. 
## These additional metadata tags are individually attached to a single text document. 
## From a corpus perspective these metadata attachments are locally stored together with each individual text document. 
## Alternatively to meta() the function DublinCore() provides a full mapping between Simple Dublin Core metadata and tm metadata
## structures and can be similarly used to get and set metadata information for text documents, e.g.:
DublinCore(crude[[1]], "Creator") <- "Ano Nymous"
meta(crude[[1]])

## For corpora the story is a bit more sophisticated. 
## Corpora in tm have two types of metadata: one is the metadata on the corpus level (corpus),
## the other is the metadata related to the individual documents (indexed) in form of a data frame.
## The latter is often done for performance reasons (hence the named indexed for indexing) 
## or because the metadata has an own entity but still relates directly to individual text documents,
## e.g., a classification result; the classifications directly relate to the documents but the set of classification levels
## forms an own entity. Both cases can be handled with meta():
meta(crude, tag = "test", type = "corpus") <- "test meta"
meta(crude, type = "corpus")

### Creating Term-Document Matrices
## A common approach in text mining is to create a term-document matrix from a corpus. 
## In the tm package the classes TermDocumentMatrix and DocumentTermMatrix 
## (depending on whether you want terms as rows and documents as columns, or vice versa) 
## employ sparse matrices for corpora.
dtm <- DocumentTermMatrix(reuters)
inspect(dtm[5:10, 740:743])

### Operations on Term-Document Matrices
## Besides the fact that on this matrix a huge amount of R functions (like clustering, classifications, etc.) can be applied, 
## this package brings some shortcuts. Imagine we want to find those terms that occur at least five times,
## then we can use the findFreqTerms() function:
## findFrequency
findFreqTerms(dtm, 5)

## Or we want to find associations (i.e., terms which correlate) with at least 0.8 correlation for the term opec, 
## then we use findAssocs():
## findAssociation
findAssocs(dtm, "opec", 0.8)

## RemoveSparseTerms
## Term-document matrices tend to get very big already for normal sized data sets. 
## Therefore we provide a method to remove sparse terms, i.e., terms occurring only in very few documents. 
## Normally, this reduces the matrix dramatically without losing significant relations inherent to the matrix:
inspect(removeSparseTerms(dtm, 0.4))
## This function call removes those terms which have at least a 40 percentage of sparse 
## (i.e., terms occurring 0 times in a document) elements.

### Dictionary
## A dictionary is a (multi-)set of strings. It is often used to denote relevant terms in text mining. 
## We represent a dictionary with a character vector 
## which may be passed to the DocumentTermMatrix() constructor as a control argument. 
## Then the created matrix is tabulated against the dictionary, i.e., only terms from the dictionary appear in the matrix. 
## This allows to restrict the dimension of the matrix a priori and to focus on specific terms for distinct text mining contexts, e.g.,
inspect(DocumentTermMatrix(reuters,list(dictionary = c("prices", "crude", "oil"))))

