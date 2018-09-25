getwd()
setwd('C:/Users/Administrator/Documents/GitHub/play_20180925_wordcloud_whitenight')
wordbase<-read.csv("white_night.txt")
head(wordbase)

## 以及清洗 去掉各种标点符号
word_clean<-NULL
word_clean$msg <- gsub(pattern = " ", replacement ="", wordbase[,1]) 
#去空格
word_clean$msg <- gsub("\t", "", word_clean$msg) 
#有时需要使用\\\t  
word_clean$msg <- gsub(",", "，", word_clean$msg)
#英文逗号
word_clean$msg <- gsub("~|'", "", word_clean$msg)
#替换了波浪号（~）和英文单引号（'），它们之间用“|”符号隔开，表示或的关系
word_clean$msg <- gsub("\\\"", "", word_clean$msg)
#替换所有的英文双引号（"），因为双引号在R中有特殊含义，所以要使用三个斜杠（\\\）转义

head(word_clean)

## 分词
seg_word<-segmentCN(as.character(word_clean))
seg_word

## 统计
words=unlist(lapply(X=smartcn, FUN=segmentCN))
word=lapply(X=seg_word, FUN=strsplit, " ") 
v=table(unlist(word))
v<-rev(sort(v))
d<-data.frame(word=names(v),cnt=v)
d=subset(d, nchar(as.character(d$word))>1)
head(d)


## 去停用词
write.table(v,file="word_result2.txt")
ssc=read.table("word_result2.txt",header=TRUE)
class(ssc)
ssc[1:10,]
ssc=as.matrix(d)
stopwords=read.table("wordclean_list.txt")
class(stopwords)
stopwords=as.vector(stopwords[,1])
wordResult=removeWords(ssc,stopwords)
#去空格
kkk=which(wordResult[,2]=="")
wordResult=wordResult[-kkk,][,2:3]


## 画词云
names(wordResult)
write.table(wordResult,'white_night_cloud.txt')
mydata<-read.table('white_night_cloud.txt')
#mydata<-filter(mydata,mydata$cnt>=10)
wordcloud2(mydata,figPath='boyandgirl.jpg')  #figPath='jingyu.jpg')


