#function to change column names ot PO Names
# This is the base function
#names(cal58_60)[2] <- cal58_60[1 , 2]
require(tidyverse)

#Create a data frame of each sheet and load into environment
seperate_calendars <- function(xlsx, ...){
  sheet_names <- excel_sheets(xlsx)
  months <- lapply(sheet_names, function(X) read_excel(xlsx, sheet = X))
  lapply(months, as.data.frame)
  names(months) <- sheet_names
  list2env(months, .GlobalEnv)
}

#Brute force remove the standad 8 columns
set_PO_stats <- function(df, ...){
  df <- df %>%
    select(AOIC_Stat = X__1,
           PO_Stat = X__2:X__8)
}


#takes lenght of DF, then, assuming second row is the header, replaces column name with name of PO
po_name_col <- function(df, ...){
  df <- df %>% 
    mutate_all(funs(replace(., is.na(.),0)))
  for(i in 1:length(df)){
    if(!is.na(df[4, i])){
      names(df)[i] <- df[4, i]
    } else {
      next(is.na(df[4, i]))
    }
  }

  df <- df[2:nrow(df), 1:ncol(df)]
  df <- df[5:nrow(df), ]
  names(df)[1] <- "AOIC_Stat" #remember, index goes outside of name function call
  return(df)
}

pull_unit_info <- function(df, ...){
  dcpo <- df[1, 1]
  police_district <- df[2, 1]
  SPO <- df[3, 1]
  info <- c(dcpo, police_district, SPO)
  unlist(info)
}

#this one. This one is awesome. Take only columns with data, craete PO names, then make tidy with gather/spread
tidy_up <- function(df, ...){
  unit_info <- df %>% 
    pull_unit_info()
  
  tidy_unit <- df %>% 
  select_if(~!all(is.na(.))) %>% # essary line, investigat select if. This has to do with negation. 
  po_name_col() %>%
  gather(2:ncol(.), key = PO_Name, 
         value = Totals) %>% 
  spread(key = AOIC_Stat, 
         value = Totals) %>%
    mutate_at(c(2:ncol(.)), as.numeric) %>%
    mutate(Unit = unit_info[[2]], SPO = unit_info[[3]], DCPO = unit_info[[1]])

  tidy_unit
}

unit_only_tidy <- function(df, ...){
 df %>% 
    select_if(~!all(is.na(.))) %>% # essary line, investigat select if. This has to do with negation. 
    po_name_col() %>%
    gather(2:ncol(.), key = PO_Name, 
           value = Totals) %>% 
    spread(key = AOIC_Stat, 
           value = Totals)
}
