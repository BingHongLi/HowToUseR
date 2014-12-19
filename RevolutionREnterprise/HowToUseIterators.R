### Using Iterators P.10
#
# 原文簡介
# An iterator is a special type of object that generalizes the notion of a looping variable.
# When passed as an argument to a function that knows what to do with it, the iterator supplies a sequence of values. 
# The iterator also maintains information about its state, in particular its current index.
#
# iterators包簡介
#
# 生成iterator物件最基本的方法 iter()， 將任意的R物件轉成iterator物件
# The iterators package includes a number of functions for creating iterators.
# the simplest of which is iter, which takes virtually any R object and turns it into an iterator object.
#
# 操作iterator物件的基本方法 nextElem()
# The simplest function that operates on iterators is the nextElem function,
# which when given an iterator, returns the next value of the iterator.
# 
# 範例
# library(iterators) 
#
# 向量
# i1<-iter(1:10)
# nextElem(i1)
# nextElem(i1)
#
# matrices and data.frames, 使用參數辨認要以一列或一欄當iterator迭代的單位
# istate<- iter(state.x77,by="row")
# nextElem(istate)
# nextElem(istate)
#
# 函數, 使用nextElem時，如同重跑一次函數，若結果僅有單次時。
# Iterators can also be created from functions
# ifun<-iter(function(){sample(0:9,4,replace=T)})
# nextElem(ifun)
# nextElem(ifun)
#
# 實際應用，常會將iterators與foreach做應用
# iterators can be paired with foreach to obtain parallel results quite easily
# library(foreach)
# library(doParallel)
# cl<-makeCluster(5)
# registerDoParallel(cl)
# x<-matrix(rnorm(1000000),ncol=1000)
# itx<-iter(x,by='row')
# foreach(i=itx, .combine=c)%dopar% {mean(i)}
# 更多關於foreach http://127.0.0.1:30810/library/foreach/html/foreach.html
#
#
### 1.4.1 Some Special Iterators P.11
# 
# iterators包內有多種用來生成iterators for some scenarios 的函數
# The iterators package includes a number of special functions that generate iterators for some
# common scenarios.
# 
# 範例：irnorm 函數，生成一個iterator，裡面每一個值都服從隨機常態分配
# library(iterators)
#
# generate an iterator object follow normal distribution
# itrn <- irnorm(1,count=10)
# nextElem(itrn)
# nextElem(itrn) 
#
# generate an iterator object follow uniform   
# itru<-irunif(1,count=10)
# nextElem(itru)
# nextElem(itru)
#
# The icount function returns an iterator that counts starting from one
# it<-icount(3)
# nextElem(it)
# nextElem(it)
# nextElem(it)
#
# 諸如此類的函數還有irunif,irbinom,irpois，產生的iterators 分別服從uniform, binomial, Poisson分配
#
### 1.4.2 Writing Iterators P.12
#
# 有時我們會需要使用到一些iterators包內未提供的iterator，此時便需要自行編寫iterator
# iterator為 s3的物件， 並且有 iter 與 nextElem 方法。
# Basically, an iterator is an S3 object whose base class is "iter", and has iter and nextElem methods.

# 引用RevoForeachIterators_Users_Guide.pdf