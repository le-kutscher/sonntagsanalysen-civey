library(highcharter)
#library(tidyverse)   #nicht laden, st?rt highcharter

#setwd("X:/13_Mailbox/Praktika/Brielmaier/civey")
setwd("C:/Users/Samuel Brielmaier/Dropbox/Studium/R/scrape-wahlrecht/2018-11-01_civey_ver1")

polls.btw <- read.csv2("Sonntagsfrage-Bund-davum_2018-10-19.csv")
polls.btw <- polls.btw[,-1]    #erste Spalte entfernten (fortlaufende Nummer)

table(polls.btw$institut, exclude = NULL)             #eine zeile hat kein Institut -> unsch?n
polls.btw <- polls.btw[!is.na(polls.btw$institut) ,]  #entfertne diese Zeile
polls.btw$datum <- as.Date(polls.btw$datum)

# Datensatz in Longformat bringen
polls.btw <- reshape2::melt(polls.btw, id = c("institut", "datum", "befragte"))
names(polls.btw)[4:5] <- c("party", "value")



# BTW 2017 Ergebnisse
erg <- as.data.frame(rbind(
  c(32.9, "Union", NA),
  c(20.5, "SPD", NA),
  c(8.9, "Gr?ne", NA),
  c(10.7, "FDP", NA),
  c(9.2, "Linke", NA),
  c(12.6, "AfD", NA), 
  c(5, "Sonstige", NA)))
names(erg) <- c("value", "party", "datum")
erg <- erg[ ,c(1,3)]
erg$datum <- as.Date("2017-09-24")


#' gro?e Highchart bauen:
#' Input-Datensatz: Normales Format (Nicht Long)
#' Jede Partei mit der richtigen Farbe, plus gleitender Mittelwert
#' Wenn man auf die Datenpunkte geht, sollen folgende Infos angezeigt werden: Partei, Wert, Befragungsdatum, Anz. Befragte
#' X-Achse nur Monatsbeschriftung

### V1 mit Datensatz im normalen Format
highchart()%>%
  #aesthetics
  hc_xAxis(type = "datetime") %>%
  hc_yAxis(min = 0, title = list(text = "Stimmanteil in Prozent")) %>%
  hc_tooltip(crosshairs = TRUE) %>% #zeigt eine vertikale Linie an, wo die Maus ist

  #Data
  #hc_add_series(data = data, mapping = hcaes(x=date, y=hours), name = "Shipments", type = "scatter", color = "#2670FF", marker = list(radius = 2), alpha = 0.5) %>%
  hc_add_series(data = polls.btw, mapping = hcaes(datum, cdu.csu), type = "scatter", name = "Union"
                #tooltip = list(pointFormat = "tooltip with 2 values {this.point.cdu.csu}: {this.point.datum}" ) #tooltip funktioniert noch nicht
                ) %>%
  #Tooltip format
  hc_tooltip(formatter = JS("function(){
                      return ('Stimmanteil: ' + this.y + '%' + 
                              ' <br> Datum: ' + this.point.datum + 
                              ' <br> Institut: ' + this.point.institut +
                              ' <br> Anzahl Befragte: ' + this.point.befragte)
                      }")) 
 
### V2, Datensatz im Longformat
# Datensatz in Longformat bringen
polls.btw.long <- reshape2::melt(polls.btw, id = c("institut", "datum", "befragte"))
names(polls.btw.long)[4:5] <- c("party", "value")
# plotten
highchart()%>%
  hc_add_series(data = polls.btw.long, type = "scatter", mapping = hcaes(x = datum, y = value, group = party)) 


### V3 super simpel, funktioniert (Wenn tidyverse nicht geladen ist)
hchart(polls.btw.long, type = "scatter", hcaes(x = datum, y = value, group = party))


data(diamonds, mpg, package = "ggplot2")
hchart(mpg, "scatter", hcaes(x = displ, y = hwy, group = class))


highchart() %>% 
  hc_title(text = "Scatter chart with size and color") %>% 
  hc_add_series_scatter(mtcars$wt, mtcars$mpg,
                        mtcars$drat, mtcars$hp)


# ablage
data(diamonds, package = "ggplot2")

set.seed(123)
data <- sample_n(diamonds, 300)

modlss <- loess(price ~ carat, data = data)
fit <- arrange(augment(modlss), carat)

highchart() %>%
  hc_add_series(data, type = "scatter",
                hcaes(x = carat, y = price, size = depth, group = cut)) %>%
  hc_add_series(fit, type = "line", hcaes(x = carat, y = .fitted),
                name = "Fit", id = "fit") %>%
  hc_add_series(fit, type = "arearange",
                hcaes(x = carat, low = .fitted - 2*.se.fit,
                      high = .fitted + 2*.se.fit),
                linkedTo = "fit")
