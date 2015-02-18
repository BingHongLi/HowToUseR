# 載入
library(dplyr)

# 引用範例資料集
data(Titanic)

# 觀察資料
# View(Titanic)
str(Titanic)

# 使用dplyr，放入的資料必須為table，data.frame或matrix等
titanic <- as.data.frame(Titanic)
str(titanic)
rm(Titanic)

### filter(資料,欄位名=="欄位內容名")

# 過濾資料，挑出性別為male，年紀為Adult
filter(titanic,Sex=="Male",Age=="Adult")

# 可用 | & %in% 等多種表達方式

# 找出性別為Male或著身分是Crew的資料
filter(titanic,Sex=="Male"|Class=="Crew")

# 找出性別為Male且身分為Crew的資料
filter(titanic,Sex=="Male"&Class=="Crew")

# 找出身分為 1st 或 Crew的資料
filter(titanic,Class %in% c("1st","Crew"))

### select(資料, 欲觀察的欄位名)

# 觀察titanic資料框內所有資料的Sex,Age兩個欄位
select(titanic,Sex,Age) 

# 進階選擇法 觀察titanic資料集內所有資料從Sex到Survived的所有欄位
select(titanic,Sex:Survived)

# 同時選擇欄位又過濾資料

filter(select(titanic,Sex,Class,Age),Age=="Child")

# 可用鏈結的方式(Chaining)(出自magrittr包), %>% (Then)(會將結果輸出至下一個function的第一個參數)
require(magrittr)
titanic %>% select(Sex,Class,Age) %>% filter(Age=="Child")

### arrange 排序 arrange(資料名,依照排序的欄位名)
arrange(filter(select(titanic,Class,Freq,Age),Age=="Child"),desc(Freq))

# 鏈結的寫法
titanic %>% select(Class,Freq,Age) %>% filter(Age=="Child") %>% arrange(desc(Freq))

### mutate 新增欄位 mutata(資料名, 新增欄位名=欄位A/欄位B)

# 計算總次數
freqSum<- titanic %>% select(Freq) %>% sum()

# 產生新資料集，新增一個欄位叫做portion
titanic %>% select(Sex,Age,Freq) %>% mutate(portion=Freq/freqSum)

# 對titanic資料集，新增一個欄位portion
titanic <- mutate(titanic,portion=Freq/freqSum)

### group_by 與 summarise
# group_by : 分組依據
# summarise : 依組別計算結果
summarise(group_by(titanic,Sex), Sexsum = sum(Freq,na.rm=T))

titanic %>% group_by(Sex) %>% summarise(Sexsum=sum(Freq,na.rm=T))

# 統計多個欄位 summarise_each(funs(計算函數),欄位)

titanic %>% group_by(Sex) %>% summarise_each(funs(sum),Freq,portion)

summarise_each(group_by(titanic,Sex),funs(sum),Freq,portion)

# 針對資料同時作不同的統計方法

titanic %>% group_by(Class) %>% summarise_each(funs(min(.,na.rm=T),max(.,na.rm=T)), matches("Freq"))

summarise_each(group_by(titanic,Class),funs(min(.,na.rm=T),max(.,na.rm=T)),matches("Freq"))

# 資料計數 a.一般計數 b.不重複計數

# 一般計數
titanic %>% select(Sex) %>% summarise_each(funs(n()))
summarise_each(select(titanic,Sex),funs(n()))

# 不重複計數
titanic %>% select(Sex) %>% summarise_each(funs(n_distinct(Sex)))
summarise_each(select(titanic,Sex),funs(n_distinct(Sex)))

### 依據多欄位取計數

# 使用tally 取總和並排序
titanic %>% group_by(Age,Sex) %>% tally(sort=T)
tally(group_by(titanic,Age,Sex),sort=T)

# 使用table 取總和並排序
titanic %>% group_by(Class) %>% select(Sex,Class) %>% table() %>% head()

head(table(select(group_by(titanic,Class),Sex,Class)))


### 使用top_n 跟 min_rank

# 使用min_rank 取分組排名前兩名
titanic %>% group_by(Class) %>% select(Sex,Age,Freq) %>% filter(min_rank(desc(Freq))<=2)

# 使用top_n 取分組排名前兩名
titanic %>% group_by(Class) %>% select(Sex,Age,Freq) %>% top_n(2)

