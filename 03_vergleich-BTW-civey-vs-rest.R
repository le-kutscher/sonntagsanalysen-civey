polls.btw <- read.csv2("Sonntagsfrage-Bund-davum_2018-10-19.csv")
polls.btw <- polls.btw[,-1]    #erste Spalte entfernten (fortlaufende Nummer)

table(polls.btw$institut, exclude = NULL)             #eine zeile hat kein Institut -> unschön
polls.btw <- polls.btw[!is.na(polls.btw$institut) ,]  #entfertne diese Zeile
polls.btw <- reshape2::melt(polls.btw, id = c("institut", "datum", "befragte"))
names(polls.btw)[4:5] <- c("party", "value")
polls.btw$datum <- as.Date(polls.btw$datum)


# BTW 2017 Ergebnisse
btw_datum <- as.numeric(as.Date("2017-09-24"))
btw_datum2 <- as.Date("2017-09-24", "%Y-%m-%d")
erg <- as.data.frame(rbind(
  c(32.9, "Union", btw_datum2),
  c(20.5, "SPD", btw_datum2),
  c(8.9, "Grüne", btw_datum2),
  c(10.7, "FDP", btw_datum2),
  c(9.2, "Linke", btw_datum2),
  c(12.6, "AfD", btw_datum2), 
  c(5, "Sonstige", btw_datum2)))
names(erg) <- c("value", "party", "datum")
erg <- erg[ ,c(1,3)]
erg$datum <- as.Date("2017-09-24")

# Plotten
farben <- c("black", "red", "limegreen", "gold", "purple", "blue", "grey") #CSU, SPD, Grüne, FDP, Linke, AfD, Sonst. 
ggplot(data = polls.btw,
       aes(datum, value)) +
  # add points and smoothed line for normal institutes
  geom_point(data = polls.btw[polls.btw$institut != "civey" & 
                                polls.btw$institut != "Trend Research Hamburg" & 
                                polls.btw$institut != "YouGov",],
             aes(color = party), 
             size = 2, alpha = 0.2) +
  geom_smooth(data = polls.btw[polls.btw$institut != "civey" & 
                                 polls.btw$institut != "Trend Research Hamburg" & 
                                 polls.btw$institut != "YouGov",],
              aes(color = party), 
              method = "loess", span = 0.08,
              se = FALSE, size = 1.5) +
  geom_point(data = polls.btw[polls.btw$institut == "civey",],
             aes(color = party), 
             shape = 17, size = 3.2, alpha = 0.5) +
  geom_smooth(data = polls.btw[polls.btw$institut == "civey",],
              aes(color = party), 
              method = "loess", 
              span = 0.2,
              se = FALSE,
              linetype = "dashed", size = 1.5) +
  theme_bw() +
  theme(axis.text.x=element_text(angle=60, hjust=1)) +
  scale_colour_manual(values = farben, aesthetics = "colour") +
  scale_x_date(date_breaks = "1 month", date_labels =  "%b %Y") +
  geom_vline(xintercept =  btw_datum, alpha = 0.5) +
  annotate("text", label = "Bundestagswahl 2017", x = as.Date("2017-09-24", "%Y-%m-%d"), y = 40, color = "black") +
  #geom_point(aes(x = as.Date("2017-09-24", "%Y-%m-%d"), y = erg$value)) +             #Ziel: BTW-Ergebnisse anzeigen
  ggtitle("Sonntagsfrage zur Bundestagswahl", subtitle = "Umfrageinstitute im Vergleich: Umfragen von Civey sind die dreieckigen Datenpunkte, der gleitende Mittelwert ist die gestrichelte Linie. \n Alle anderen Institute sind als Kreise eingetragen mit dem gleitenden Mittelwert als durchgezogene Linie.") 
  


ggsave("03_Sonntagsfrage-Bundestagswahl_Umfrageinstitute-im-Vergleich.png", 
       plot = last_plot(),
       width = 25, height = 15)



# Indi, FG gegen civey

ggplot(data = polls.btw,
       aes(datum, value)) +
  # add points and smoothed line for normal institutes
  geom_point(data = polls.btw[polls.btw$institut == "Forschungsgruppe Wahlen" | 
                                polls.btw$institut == "Infratest dimap",],
             aes(color = party), 
             size = 2, alpha = 0.2) +
  geom_point(data = polls.btw[polls.btw$institut == "civey",],
             aes(color = party), 
             shape = 17, size = 3.2, alpha = 0.5) +
  theme_bw() +
  theme(axis.text.x=element_text(angle=60, hjust=1)) +
  scale_colour_manual(values = farben, aesthetics = "colour") +
  scale_x_date(date_breaks = "1 month", date_labels =  "%b %Y") +
  geom_vline(xintercept =  btw_datum, alpha = 0.5) +
  annotate("text", label = "Bundestagswahl 2017", x = as.Date("2017-09-24", "%Y-%m-%d"), y = 40, color = "black") +
  #geom_point(aes(x = as.Date("2017-09-24", "%Y-%m-%d"), y = erg$value)) +             #Ziel: BTW-Ergebnisse anzeigen
  ggtitle("Sonntagsfrage zur Bundestagswahl", subtitle = "Umfrageinstitute im Vergleich: Umfragen von Civey sind die dreieckigen Datenpunkte, der gleitende Mittelwert ist die gestrichelte Linie. \n Forschungsgruppe und Indi sind als Kreise eingetragen mit dem gleitenden Mittelwert als durchgezogene Linie.") 


### Ablage
geom_smooth(data = polls.btw[polls.btw$institut == "civey",],
            aes(color = party), 
            method = "loess", 
            span = 0.2,
            se = FALSE,
            linetype = "dashed", size = 1.5) +
  
  geom_smooth(data = polls.btw[polls.btw$institut == "Forschungsgruppe Wahlen" | 
                                 polls.btw$institut == "Infratest dimap",],
              aes(color = party), 
              method = "loess", span = 0.08,
              se = FALSE, size = 1.5) +
  