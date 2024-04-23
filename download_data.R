# Script to download voting data from Polish Parliament (Sejm) for statistical analysis.
# API: api.sejm.gov.pl
# author: Borys Łangowicz (neloduka_sobe)

# Load required libraries
library(httr)
library(jsonlite)
library(dplyr)
library(lubridate)

API_URL <- "https://api.sejm.gov.pl"
TERM <- "10"

# Test run
#PATH = "/sejm/term"
#url = paste0(API_URL, PATH, TERM)
#res = GET(url)
#data  = fromJSON(rawToChar(res$content))
#data


# Loading clubs data
url <- paste0(API_URL, "/sejm/term", TERM, "/clubs")

res <- GET(url)
if (res$status != 200) {
  stop("Error loading clubs data")
}
clubs <- fromJSON(rawToChar(res$content))
clubs_dataframe <- as.data.frame(clubs)
write.csv(clubs_dataframe, "./Data/clubs.csv", row.names=FALSE)


# Loading MP data
url <- paste0(API_URL, "/sejm/term", TERM, "/MP")
res <- GET(url)
if (res$status != 200) {
  stop("Error loading MP data")
}
mp <- fromJSON(rawToChar(res$content))
mp_dataframe <- as.data.frame(mp)
write.csv(mp_dataframe, "./Data/mp.csv", row.names=FALSE)

# Loading votings data #TODO
sitting <- 1
url <- paste0(API_URL, "/sejm/term", TERM, "/votings/")
res <- GET(paste0(url,sitting))

while (rawToChar(res$content) != "[]") {
  number_of_votings <- dim(fromJSON(rawToChar(res$content)))[1]

  for (voting in 1:number_of_votings) {
    vot_url <- paste0(url, sitting, "/", voting)
    res <- GET(vot_url)
    if (fromJSON(rawToChar(res$content) != "ON_LIST")) {
      vot <- fromJSON(rawToChar(res$content))
      voting_dataframe <- as.data.frame(vot)
      filename <- paste0("./Data/votings/sitting_", sitting, "_voting_", voting, ".csv" )
      write.csv(vot, filename, row.names=FALSE)
    }
  }
  
  sitting = sitting + 1
  res <- GET(paste0(url,sitting))
}

