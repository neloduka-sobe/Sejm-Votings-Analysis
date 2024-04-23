# Script to download voting data from Polish Parliament (Sejm) for statistical analysis.
# API: api.sejm.gov.pl
# author: Borys Łangowicz (neloduka_sobe)

# Load required libraries
library(httr)
library(jsonlite)

API_URL <- "https://api.sejm.gov.pl"
TERM <- "10"

# Test run
PATH = "/sejm/term"
url = paste0(API_URL, PATH, TERM)
res = GET(url)
data  = fromJSON(rawToChar(res$content))
data
