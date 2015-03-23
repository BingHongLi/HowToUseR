# 網路爬蟲(使用RCurl包)
# 資料來源：http://www.omegahat.org/RCurl/RCurlJSS.pdf

# 安裝套件
# install.packages("RCurl")

# 載入套件
library(RCurl)
library(XML)
# Ch3.1 Getting URIs P.8
# 使用getURL可一次性取得該HTML的內容，並轉存成一條字串，但此方法並不是非常地好，會隱藏了很多訊息。
# 建議進階解讀，解讀Data可選用read.table() or scan()，解析HTML or XML 可使用htmlTreeParse() 或xmlTreeParse() 
w <- getURL("http://www.omegahat.org/")

# Ch3.2 Forms P.9
# RCurl包裡提供getForm() 及 postForm() 函數 分別去取得GET 及POST
# 範例，以Google Search為例
# 以中文查詢李秉鴻，輸出結果為The result is the HTML text that contains the search results in the usual format.
# postForm has the same user-level interface and only differs in how the underlying HTTP request is formed
getForm("http://www.google.com/search",q="台灣富朗巴FORUM8",ie="BIG5")

# Ch3.3 Options controlling the request P.9
# the functions getURI() and getForm() provide the same basic functionality that is already available in R
# 除了附加一些多變的protocols, 像HTTPS, FTPS， 另外RCurl 及 libcurl 也允許去去客製化函數參數 去決定 the HTTP request and response and how they are sent and received

# P.10
# 定義附加資訊去決定 HTTP的request，比如說某些網站會因為擺放檔案位置更改而將網頁自動導向去他處(redirection)，
# 但我們會抓到該網站說其網址已不存在，將轉址到他處的情況
# specify additional information to govern the HTTP request.
# 我們可在getURL或getForm等函數去設定一個參數
# When submitting forms, one must use the .opts argument for specifying settings for the curl request.
# 我們可將探訪網站的input直接以參數的方式表示 name = value, 也可以用參數 .opts=list(參數名=參數值)
# 這兩種寫法會合併，而在最後若有重複出現，則會以直接寫在函數內的參數為優先引用
# 建議去使用.opt這個參數, 因在函數內額外去寫的參數，一般會用於其他用途
getURI( followlocation = TRUE)
getURI( .opts = list(followlocation = TRUE))

# Ch3.4 The Request Options P.10

#####
htmlParse(getURL("http://www.google.com",q="FORUM8",ie="BIG5"),encoding="UTF-8")