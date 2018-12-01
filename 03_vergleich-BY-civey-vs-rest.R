
polls.BY <- read.xlsx("03_vergleich-BY-civey-vs-rest-data.xlsx", 1)
polls.BY <- reshape2::melt(polls.BY, id = c("Institut", "Datum"))
names(polls.BY)[3:4] <- c("party", "value")
farben <- c("black", "red", "green", "yellow", "purple", "orange", "blue", "grey") #CSU, SPD, Grüne, FDP, Linke, FW, AfD, Sonst. 

ggplot(data = polls.BY,
       aes(Datum, value)) +
  # add points and smoothed line for normal institutes
  geom_point(data = polls.BY[polls.BY$Institut != "civey",],
             aes(color = party), 
             size = 2) +
  geom_smooth(data = polls.BY[polls.BY$Institut != "civey",],
              aes(color = party), 
              method = "loess", span = 0.4,
              se = FALSE) +
  geom_point(data = polls.BY[polls.BY$Institut == "civey",],
             aes(color = party), shape = 15, size = 2) +
  geom_smooth(data = polls.BY[polls.BY$Institut == "civey",],
              aes(color = party), 
              method = "loess", 
              span = 0.4,
              se = FALSE,
              linetype = 3) +
  theme_bw() +
  scale_colour_manual(values = farben, aesthetics = "colour") +
  ggtitle("Sonntagsfrage zur Landtagswahl Bayern", subtitle = "Umfrageinstitute im Vergleich")
  
ggsave("03_Sonntagsfrage-Landtagswahl-Bayern_Umfrageinstitute-im-Vergleich.png", 
       plot = last_plot(),
       width = 12, height = 12)
