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
