# write a RIS file:
library(stringr)

df <- read.csv("endnote_csv.csv", stringsAsFactors=FALSE, encoding="UTF-8")


writeRIS<-function(df){
  sink("bibliography.ris", append = FALSE)
  for(i in 1:nrow(df)){
    cat("TY  - JOUR\n")
    cat("RI  - REF_", str_pad(df$endnote[i], 4, pad = "0") ,"\n", sep="")
    cat("TI  - ", df$title[i], "\n")
    auth<-unlist(strsplit(df$authors[i],";"))
    for(a in 1:length(auth)){
      cat("AU  - ", auth[a], "\n")
    }
    cat("AB  - ", df$abstract[i], "\n")
    cat("T2  - ", df$journal[i], "\n")
    cat("VL  - ", df$volume[i], "\n")
    cat("IS  - ", df$issue[i], "\n")
    cat("PY  - ", df$year[i],"\n")
    cat("SP  - ", df$pages[i], "\n")
    cat("AN  - ",df$pmid[i],"\n")
    cat("DO  - ",df$doi[i],"\n") 
    cat("LB  - ",df$doi[i],"\n")
    cat("ER  -\n\n")
  }
  sink()
}

writeRIS(df)

library(bib2df)
library(dplyr) #use dplyr to format our dataformat into bib2df format:

bib2 = df %>% mutate(CATEGORY="ARTICLE", 
                     BIBTEXKEY=paste0("REF_",str_pad(df$endnoteid, 4, pad = "0")),
                     ADDRESS=NA,
                     ANNOTATE=NA,
                     AUTHOR=strsplit(df$authors,";"),
                     BOOKTITLE=NA,
                     CHAPTER=NA,
                     CROSSREF=NA,
                     EDITION=NA,
                     EDITOR=NA,
                     HOWPUBLISHED=NA,
                     INSTITUTION=NA,
                     JOURNAL=df$journal,
                     KEY=NA,
                     MONTH=NA,
                     NOTE=NA,
                     NUMBER=df$issue,
                     ORGANIZATION=NA,
                     PAGES=df$pages,
                     PUBLISHER=NA,
                     SCHOOL=NA,
                     SERIES=NA,
                     TITLE=df$title,
                     TYPE=NA,
                     VOLUME=df$volume,
                     YEAR=df$year) %>% select(BIBTEXKEY,ADDRESS,ANNOTATE,AUTHOR,BOOKTITLE,CHAPTER,CROSSREF,EDITION,EDITOR,HOWPUBLISHED,INSTITUTION,JOURNAL,KEY,MONTH,NOTE,NUMBER,ORGANIZATION,PAGES,PUBLISHER,SCHOOL,SERIES,TITLE,TYPE,VOLUME,YEAR)


df2bib(bib2, file="references.bib")
