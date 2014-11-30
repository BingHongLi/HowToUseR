library(RODBC)

channel <- odbcConnect("YB802", uid="YB802", pwd="YB802-3")

as.data.frame(sqlQuery(channel,"select * from SGameTag"))

test<- as.data.frame(sqlQuery(channel,"select * from SGameTag"))

#stored procedure
as.data.frame(sqlQuery(channel,"exec CLASSBIGTABLE"))

tryCombine <- c()
for(i in 2:7){
  
  tryCombine <- c(tryCombine,levels(test[,i]))

}

#unique(tryCombine)[2:24]

all0Matrix <- matrix(rep(0,5805*23),nrow=5805,ncol=23,dimnames=list(test[,1],unique(tryCombine)[2:24]))

# bad code
for(i in 1:nrow(test)){
       for( j in 2:8 ){
           k=0
           for(t in 1:23){
            k=k+1
            if(test[i,j] == colnames(all0Matrix)[k]){
                     all0Matrix[i,k] <- 1
           }    
           }
         }
   }
