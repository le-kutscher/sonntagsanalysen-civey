### dawum scrapen


url <- "https://dawum.de/Bayern/Civey/#Umfrageverlauf"
polls_by_civey <- url %>% 
  read_html() %>%                               #downloads the entire html code
  html_nodes(xpath = "/html/body/main/article/section[8]/div/div[2]") %>%  #selects the table
  html_table() %>%    #extracts table, fill used for combined cells
  as.data.frame()
