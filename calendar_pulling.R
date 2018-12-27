#pull out indvidiual calendars

monthly_stats <- function(month, ...){
  month <- month %>% set_PO_stats()
  
  cal1 <- month[1:18, ] %>% unit_only_tidy() #bufano
  cal2 <- month[41:58, ] %>% unit_only_tidy()#flanagan
  cal3 <- month[61:78, ] %>% unit_only_tidy()
  cal4 <- month[101:118, ] %>% unit_only_tidy()
  cal5 <- month[121:138, ] %>% unit_only_tidy()
  cal6 <- month[141:158, ] %>% unit_only_tidy()
  cal7 <- month[161:178, ] %>% unit_only_tidy()
  cal8 <- month[181:198, ] %>% unit_only_tidy()
  cal9 <- month[201:218, ] %>% unit_only_tidy()
  cal10 <- month[221:238, ] %>% unit_only_tidy()
  cal11 <- month[241:258, ] %>% unit_only_tidy()
  cal12 <- month[261:278, ] %>% unit_only_tidy()
  cal13 <- month[281:298, ] %>% unit_only_tidy()
  cal14 <- month[301:318, ] %>% unit_only_tidy()
  cal15 <- month[321:338, ] %>% unit_only_tidy()
  cal16 <- month[341:358, ] %>% unit_only_tidy()
  cal17 <- month[361:378, ] %>% unit_only_tidy()
  cal18 <- month[381:398, ] %>% unit_only_tidy()
  cal19 <- month[401:418, ] %>% unit_only_tidy()
  cal20 <- month[423:440, ] %>% unit_only_tidy()
  cal21 <- month[463:480, ] %>% unit_only_tidy()
  adminstrative <- month %>% 
    filter(AOIC_Stat == "Anderson") %>% unit_only_tidy()
  
  
  calendars <- cal1 %>%
    bind_rows(cal2) %>%
    bind_rows(cal3) %>%
    bind_rows(cal4) %>%
    bind_rows(cal5) %>%
    bind_rows(cal6) %>%
    bind_rows(cal7) %>%
    bind_rows(cal8) %>%
    bind_rows(cal9) %>%
    bind_rows(cal10) %>%
    bind_rows(cal11) %>%
    bind_rows(cal12) %>%
    bind_rows(cal13) %>%
    bind_rows(cal14) %>%
    bind_rows(cal15) %>%
    bind_rows(cal16) %>%
    bind_rows(cal17) %>%
    bind_rows(cal18) %>%
    bind_rows(cal19) %>%
    bind_rows(cal20) %>%
    bind_rows(cal21) %>%
    bind_rows(adminstrative)
}

View(June[1:18, ] %>% set_PO_stats()  %>% unit_only_tidy())
