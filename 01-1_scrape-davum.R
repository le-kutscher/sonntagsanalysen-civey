source("packages.r")  #load packages

json <- fromJSON(txt = "01-1_davum-json.json")                               #json datei einlesen (von davum, erst ab Umfragedaten (einfach mit editor rauskopieren))
btw_dv <- do.call("rbind.fill", lapply(json, as.data.frame))  #wandelt json in dataframe um

#' Parlamente: 
#'  0 = Bundestag
#'  7 = Hessen
#' Institute:
insti <- rbind(
  c(1, "Infratest dimap"),
  c(2, "Forsa"),
  c(3, "Emnid"),
  c(4, "GMS"),
  c(5, "INSA"),
  c(6, "Forschungsgruppe Wahlen"), 
  c(7, "Trend Research Hamburg"), 
  c(9, "Allensbach"), 
  c(11, "GESS Phone & Field"),
  c(12, "uniQma"), 
  c(13, "YouGov"), 
  c(14, "dimap"), 
  c(16, "civey"), 
  c(17, "ipsos"), 
  c(20, "IM Field"))


# Format des Datensatzes: institut, datum, befragte, cdu.csu, spd, grüne, fdp, linke, afd, sonstige
variablen <- c("Institute_ID", "Date", "Surveyed_Persons", "Results.1", "Results.2", "Results.4", "Results.3", "Results.5", "Results.7", "Results.0")
btw_dv <- btw_dv[btw_dv$Parliament_ID == 0, variablen]  #entfernt Umfragen zu Ländern und ordnet Variablen
names(btw_dv) <- c("institut", "datum", "befragte", "cdu.csu", "spd", "grüne", "fdp", "linke", "afd", "sonstige")

#Variable institut erstellen mit korrekten Namen
btw_dv$institut <- factor(btw_dv$institut, 
                          levels = insti[,1],
                          labels = insti[,2])

write.csv2(btw_dv, paste("Sonntagsfrage-Bund-davum_", Sys.Date(), ".csv",sep = ""))
