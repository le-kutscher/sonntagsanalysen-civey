# install packages from CRAN
p_needed <- c("plyr",           #benötigt für rbind.fill, macht mglw. probleme da Vorgängerversion von dplyr (in tidyverse enthaltens)
              "tidyverse",      #visualisation of plots
              "devtools",       
              "xlsx",           #read and write excel
              "zoo",            #nötig für germanpolls
              "rvest",          #scrape html
              "jsonlite")       #read json files

p_installed <- rownames(installed.packages())   #vector with all installed packages

p_to_install <- p_needed[!(p_needed %in% p_installed)]
if (length(p_to_install) > 0) {
  install.packages(p_to_install)
}
lapply(p_needed, require, character.only = TRUE)

# install packages from github
install_github("cutterkom/germanpolls")     #scrape wahlrecht.de
library(germanpolls)