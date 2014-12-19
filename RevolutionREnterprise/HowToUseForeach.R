# The foreach package is a set of tools that allow you to run virtually anything that can be
# expressed as a for-loop as a set of parallel tasks

library(foreach)

# 使用 foreach 會回傳一個list，內包含每一次計算的結果。
# 使用for迴圈，是回傳最後一次計算的結果及依照使用者的定義


# %do%
foreach(i= 1:10)%do% sample(c("H","T"),10000,replace=T)

# %使用%dopar%， 需要 parallel backend registered 方能執行。
foreach(i= 1:10)%dopar% sample(c("H","T"),10000,replace=T)

## Parallel Backends

# 在使用foreach時，需要註冊parallel backend
# doParallel: 使用parallel包在多核上做平行運算(多平台支援)
# doMC      : 使用multicore包在多核上做平行運算(僅支持Linux)

# To use a parallel backend, you must first register it. Once a parallel backend is registered,
# calls to %dopar% run in parallel using the mechanisms provided by the parallel backend.

## Using the doParallel parallel backend P.7
# parallel包整合了snow與multicore包, doParallel similarly combines elements of both doSNOW and doMC.
# 我們可以在叢集上使用doParallel，就像使用doSNOW一樣。
# 或如同doMC一樣，使用多核運算。

# 範例，一使用parallel backend, 即可使用foreach去平行化。
library(doParallel)
# 設定四核運算
cl<-makeCluster(5)
registerDoParallel(cl)
# 跑一萬次glm
x<-iris[which(iris[,5]!="setosa"),c(1,5)]
trials<-10000
ptime<-system.time({
	r<-foreach(icount(trials), .combine=cbind)%dopar%{
		ind<-sample(100,100,replace=T)
		result1<-glm(x[ind,2]~x[ind,1],family=binomial(logit))
		coefficients(result1)	
	}
	
})[3]
ptime

## Getting information about the parallel backend P.8

# 取得目前有多少worker供平行運算使用，可使用此函數確認目前到底有沒有平行運算
getDoParWorkers()

# 查詢所使用的doPar方式
getDoParName()

# 查詢版本
getDoParVersion()


## 1.3 Nesting Calls to foreach P.8

# An important feature of foreach is nesting operator %:%. Like the %do% and %dopar% operators,
# it is a binary operator, but it operates on two foreach objects.
# It also returns a foreach object

# 以蒙特卡羅法模擬(使用sim函數),sim函數需要兩個參數. 將所有的值存在avec與bvec內

# 傳統方法  P.9
sim<-function(a,b){
	10*a+b
}
avec<-1:2
bvec<-1:4

x<-matrix(0,length(avec),length(bvec))
for(j in 1:length(bvec)){
	for(i in 1:length(avec)){
		x[i,j]<-sim(avec[i],bvec[j])
	}	
}

# foreach 平行化算法 P.9

x<- foreach(b=bvec, .combine='cbind')%:%{
		foreach(a=avec, .combine='c')%do%{
			sim(a,b)	
		}
	}
x	

# P.9
# 對巢狀迴圈平行化，建議是對外層迴圈做平行化運算，這在大量的獨立tasks及大型tasks上會顯得有效率，
# 而若外層迴圈迭代次數不多且該任務也非常的大，在外層迴圈平行化，不會被允許使用到所有的核心
# 而且也會導致讀取平衡的問題，此時可以選擇平行化內層迴圈，但如此一來可能就會顯得較無效率，
# 因為必須重複地等待內層迴圈所有的結果都回傳至外層迴圈，且如果tasks與迭代的次數多變的話，
# 會導致很難知道 which loop to parallelize

# the %:% operator does: it turns multiple foreach loops into a single loop.
# That is why there is only one %do% operator in the example above.

x<- foreach(b=bvec, .combine='cbind')%:%{
		foreach(a=avec, .combine='c')%dopar%{
			sim(a,b)	
		}
	}
x	

# the %:% operator makes it easy to specify the stream of tasks to be executed, 
# and the .combine argument to foreach allows us to specify how the results should be processed.

# For more on nested foreach calls, see the vignette “Nesting foreach Loops” in the foreach package
####################################################################################################
#
# 參考 RevoForeachIterators_Users_Guide.pdf
# http://www.boyunjian.com/do/article/snapshot.do?uid=3289022633462872166
# http://xccds1977.blogspot.tw/2012/09/parallelforeach.html
#
####################################################################################################