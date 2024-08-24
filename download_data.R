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

check_response <- function(res, text) {
  if (res$status != 200) {
    warning(paste0("Error code: ", text))
    return(FALSE)
  }
  return(TRUE)
}

# Loading clubs data
url <- paste0(API_URL, "/sejm/term", TERM, "/clubs")

res <- GET(url)
check_response(res, "While downloading clubs")

clubs <- fromJSON(rawToChar(res$content))
clubs_dataframe <- as.data.frame(clubs)
write.csv(clubs_dataframe, "./Data/clubs.csv", row.names=FALSE)


# Loading MP data
url <- paste0(API_URL, "/sejm/term", TERM, "/MP")
res <- GET(url)
check_response(res, "While downloading MP")

mp <- fromJSON(rawToChar(res$content))
mp_dataframe <- as.data.frame(mp)
write.csv(mp_dataframe, "./Data/mp.csv", row.names=FALSE)

# Loading votings data
Y_N_VOTINGS <- "y_n_votings.csv"
ON_LIST <- "_on_list"
on_list <- FALSE
sitting <- 1
url <- paste0(API_URL, "/sejm/term", TERM, "/votings/")
res <- GET(paste0(url,sitting))
check_response(res, paste("While downloading votings, sitting:", sitting))
y_n_voting <- data.frame()

while (rawToChar(res$content) != "[]") {
  number_of_votings <- dim(fromJSON(rawToChar(res$content)))[1]

  for (voting in 1:number_of_votings) {
    vot_url <- paste0(url, sitting, "/", voting)
    res <- GET(vot_url)
    # In the main loop:
    if (!check_response(res, paste("While downloading votings, sitting:", sitting, "voting:", voting))) {
      # Log the error and continue with the next voting
      cat(paste("Skipping sitting:", sitting, "voting:", voting, "\n"))
      next
    }
    vot <- fromJSON(rawToChar(res$content))
    
    if (fromJSON(rawToChar(res$content))$kind == "ON_LIST") {
      votes <- vot$votes
      voting_options <- vot$votingOptions
      names(votes$listVotes) <- voting_options$option
      vot <- votes
      on_list <- TRUE
    }
    else {
      on_list <- FALSE
    }
    voting_dataframe <- as.data.frame(vot)
    
    # Merging data
    if (!on_list) {
    y_n_voting <- merge(y_n_voting, voting_dataframe, all=TRUE)
    }
    else {
      filename <- paste0("./Data/votings/sitting_", sitting, "_voting_", voting, ".csv" )
      write.csv(voting_dataframe, filename, row.names=FALSE)
    }
   
  }
  
  sitting = sitting + 1
  res <- GET(paste0(url,sitting))
  check_response(res, paste("While downloading votings, sitting:", sitting))
}

# Saving yes/no votings
filename <- paste0("./Data/votings/", Y_N_VOTINGS)
write.csv(y_n_voting, filename, row.names=FALSE)