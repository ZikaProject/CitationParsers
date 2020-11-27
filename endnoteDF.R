#######################################
#                                     #
#        MJ Counotte                  #
#          q very quick xml parser    #
#             endnote to DF           #
#                                     #
#######################################


# endnote library: export: save as type: XML, output style: endnote export.


library(XML)
library(dplyr)

txt=readLines("example.xml", encoding="UTF-8")

txt=gsub(">", ">\n",txt)
data=xmlParse(txt, encoding="UTF-8")



records <- getNodeSet(data, "//record")

title <- lapply(records, xpathSApply, ".//title", xmlValue) 
title[sapply(title, is.list)] <- ""
title <- gsub("\n","",unlist(title))

endnoteid <- lapply(records, xpathSApply, ".//rec-number", xmlValue) 
endnoteid[sapply(endnoteid, is.list)] <- ""
endnoteid <- gsub("\n","",unlist(endnoteid))

linkid <- lapply(records, xpathSApply, ".//caption", xmlValue) 
linkid[sapply(linkid, is.list)] <- ""
linkid <- gsub("\n","",unlist(linkid))


# etc: author, embase_id, pmid (duplicate matched id [caption]), ...
# pmid is 'accession-num'

pmid <- lapply(records, xpathSApply, ".//accession-num", xmlValue) 
pmid[sapply(pmid, is.list)] <- ""
pmid <- gsub("\n","",unlist(pmid))


# embase_id is the first element of the 'notes' (if source is from embase)

notes <- lapply(records, xpathSApply, ".//notes", xmlValue) 
notes[sapply(notes, is.list)] <- ""
notes <- gsub("\n","",unlist(notes))

author <- lapply(records, xpathSApply, ".//author", xmlValue) 
author[sapply(author, is.list)] <- ""
authors=lapply(author, paste0, collapse=";")
authors <- gsub("\n","",authors)

journal <- lapply(records, xpathSApply, ".//secondary-title", xmlValue) 
journal[sapply(journal, is.list)] <- ""
journal <- gsub("\n","",unlist(journal))

year <- lapply(records, xpathSApply, ".//year", xmlValue) 
year[sapply(year, is.list)] <- ""
year <- gsub("\n","",unlist(year))

volume <- lapply(records, xpathSApply, ".//volume", xmlValue) 
volume[sapply(volume, is.list)] <- ""
volume <- gsub("\n","",unlist(volume))

issue <- lapply(records, xpathSApply, ".//number", xmlValue) 
issue[sapply(issue, is.list)] <- ""
issue <- gsub("\n","",unlist(issue))

pages <- lapply(records, xpathSApply, ".//pages", xmlValue) 
pages[sapply(pages, is.list)] <- ""
pages <- gsub("\n","",unlist(pages))

#url
url1 <- lapply(records, xpathSApply, ".//urls", xmlValue) 
url1[sapply(url1, is.list)] <- ""
url1 <- gsub("\n","",unlist(url1))

#pmid from embase records: [embase records come from medline sometimes as well, they have a pmid also:]

pmid_em <- lapply(records, xpathSApply, ".//custom5", xmlValue) 
pmid_em[sapply(pmid_em, is.list)] <- ""
pmid_em <- gsub("\n","",unlist(pmid_em))

#doi = electronic-resource-num?
doi <- lapply(records, xpathSApply, ".//electronic-resource-num", xmlValue) 
doi[sapply(doi, is.list)] <- ""
doi <- gsub("\n","",unlist(doi))

# abstract
abstract <- lapply(records, xpathSApply, ".//abstract", xmlValue) 
abstract[sapply(abstract, is.list)] <- ""
abstract <- gsub("\n","",unlist(abstract))


#issn=isbn
issn <- lapply(records, xpathSApply, ".//isbn", xmlValue) 
issn[sapply(issn, is.list)] <- ""
issn <- gsub("\n","",unlist(issn))


#embase_id
# get id from url1: between id= and next url (http)?
embase_id=gsub('^.*id=\\s*|\\s*http://dx.*$', '', url1)

# dataframe like below: 
df1=data.frame(#author1=author1,
  authors=authors,
  title=title,
  journal=journal,
  issn=issn,
  volume=volume,
  issue=issue,
  pages=pages,
  year=year,
  pmid=pmid,
  pmid_em=pmid_em,
  embase_id=embase_id,
  doi=doi,
  url1=url1,
  endnoteid=as.numeric(endnoteid),
  abstract=abstract,
  stringsAsFactors = FALSE)


df1 = df1 %>% mutate(embase_id =  ifelse(nchar(embase_id)==11 | nchar(embase_id)==10, embase_id, NA),
                     id=ifelse(is.na(embase_id), pmid, embase_id),
                     pmid=ifelse(pmid_em!="", pmid_em, pmid))

con<-file('endnote_csv.csv',encoding="UTF-8")
write.csv(df1, file=con, row.names=FALSE)
