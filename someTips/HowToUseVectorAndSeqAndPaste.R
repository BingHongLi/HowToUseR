######################

# Sequences of Numbers 

# 從0到10，每0.5個間距跳一次
seq(0,10,by=0.5)

# 從5到10，平均切出30個值
seq(5,10,length=30)

# 依照my_seq物件的個數產生連續數值
seq(along.with=my_seq)
seq_along(my_seq)

# 重複產生數值，並指定產生次數
rep(0,times=40)
rep(c(0,1,2),times=10)

# 重複產生某數列的個別值，並指定產生次數
rep(c(0,1,2),each=10)

#######################
# Vectors

# 輸入單一個向量，做字串黏貼
paste(my_char, collapse = " ")

# 輸入多個字串，做字串黏貼
paste("Hello","world",sep=" ")

# 若輸入數字跟字串做黏貼，則會交互黏貼
paste(1:3,c("X","Y","Z"),sep="")

# 若兩條向量長度不等，做黏貼，短的會重複使用
paste(LETTERS, 1:4, sep = "-")
# LETTERS為預設向量
