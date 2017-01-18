##read in emoji dictionary and comments ####
emojis <- read.csv("C:/Users/Ye Tian/Dropbox/teaching/Corpus course Nov 2016/Resources/Facebook/emoji sentiment.csv", header = T)
emojis<-emojis[emojis$Sentiment.score!="#N/A",]
emojis$Sentiment.score<-as.numeric(levels(emojis$Sentiment.score))[emojis$Sentiment.score]

comments<-read.csv("C:/Users/Ye Tian/Dropbox/teaching/Corpus course Nov 2016/Resources/Facebook/bbcnews_facebook_comments.csv",header=T,sep="|")

### function for counting the number of matched emojis in each comment
# in this function text argument MUST be a vector of text
# the useBytes = TRUE is crutial for mapping the emojis
bytes_count<-function(pattern,text,ignore.case = FALSE, perl = FALSE,
                      fixed = FALSE, useBytes = TRUE){
  out<-vector(mode = "integer", length = length(text))
  r<-1
  for (r in 1:length(text)){
    if (regexpr(pattern,text[r],useBytes = TRUE)==-1) {out[r]<-0
    } else {out[r]<-(length(unlist(gregexpr(pattern,text[r],useBytes = TRUE))))}
  }
  return(out)
}

library("parallel")
library("foreach")
library("doParallel")
library("Matrix")

## makeCluster creates a set of copies of R running in parallel and communicating over sockets.
## so how fast this goes depends on your CPU (given enough RAM)
mycluster <- makeCluster(detectCores() - 1)
registerDoParallel(mycluster, cores = detectCores() - 1)

## parSapply is a matrix where each row corresponds to each row of your comments
## and each column represents an emoji, and the number (0,1,2 etc) says whether and how many times that emoji appeared in this comment
## parSapply is simply sapply with parellel processing

## as we are only getting winky faces and 
wink.pout<-emojis[emojis$Description=="WINKING FACE"|emojis$Description=="POUTING FACE",]
system.time(emoji.freq <- parSapply(cl = mycluster, wink.pout$Bytes,
                                    bytes_count,
                                    text=comments$comment_message, useBytes = T))
#give the description of emojis as column names of this matrix
colnames(emoji.freq)<-wink.pout$Description
#stopping the cluster
stopCluster(mycluster)

winking_comments<-comments
winking_comments$winkings<-emoji.freq[,1]
winking_comments<-winking_comments[winking_comments$winkings>0,]
winking_comments$page<-"theSun"
winking_comments$page<-"bbc"


#### read the reactions data and merge with comments ####
reactions<-read.csv("C:/Users/Ye Tian/Dropbox/teaching/Corpus course Nov 2016/Resources/Facebook/thesun_facebook_statuses.csv",sep="|")
reactions<-read.csv("C:/Users/Ye Tian/Dropbox/teaching/Corpus course Nov 2016/Resources/Facebook/bbcnews_facebook_statuses.csv",sep="|")
winking_comments<-merge(winking_comments,reactions,by="status_id")

winking_comments_thesun<-winking_comments
winking_comments_bbc<-winking_comments

