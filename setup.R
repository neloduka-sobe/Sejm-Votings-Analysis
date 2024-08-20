# Installs all the requirements for the project
# author: Borys Łangowicz (neloduka_sobe)

# Libraries to be installed
LIBRARIES = c(
    "knitr",
    "dplyr",
    "ggplot2",
    "DT",
    "calendR",
    "lubridate",
    "treemapify",
    "httr",
    "jsonlite",
    "deeplr",
    "igraph",
    "RColorBrewer")

install = function(lib) {
    # Takes library name as an input
    # Installs library if it is not already installed
    if(!require(lib)) {
      install.packages(lib)
    }
}

for (lib in LIBRARIES) {
    install(lib)
}
