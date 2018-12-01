################
# Wahlrecht.de scrapen
################

#rm(list = ls())
#setwd("C:/Users/Samuel Brielmaier/Dropbox/Studium/R/scrape-wahlrecht")
#setwd("X:/13_Mailbox/Praktika/Brielmaier/civey")
source("packages.r")  #load packages

btw_wr <- germanpolls() #umfragen scapen
write.csv2(btw_wr, 
           paste("Sonntagsfrage-Bund-Polls-scapred_", Sys.Date(), ".csv",sep = "")
           )  #in Datensatz von Heute speichern


#polls Bayern
url <- "https://www.wahlrecht.de/umfragen/landtage/bayern.htm"

polls_by <- url %>% 
  read_html() %>%                               #downloads the entire html code
  html_nodes(xpath= "/html/body/table[1]") %>%  #selects the table
  html_table(header = TRUE, fill = TRUE) %>%    #extracts table, fill used for combined cells
  as.data.frame()
polls_by <- polls_by[-1, ]   #delete first row
write.csv2(polls_by, 
           paste("Sonntagsfrage-BY-Polls-scapred_", Sys.Date(), ".csv",sep = "")
)  #in Datensatz von Heute speichern
