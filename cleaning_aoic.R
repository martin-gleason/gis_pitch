#pulling and cleaning data
library("tidyverse")
library("readxl")
source("cleaning_functions.R")

june_oct_2018_xlsx <- file.path("June-Sept AOIC per dept.xlsx")

june_oct_2018_xlsx %>% seperate_calendars()

June_Stats <- June %>% set_PO_stats()
July_Stats <- July %>% set_PO_stats() # the old way was not a function.
August_Stats <- Aug %>% set_PO_stats()
Sept_Stats <- Sept %>% set_PO_stats()



#Calendars
cal58_60 <- Sept_Stats[1:18, ] #spo bufano

cal_55_60_63 <- Sept_Stats[41:58, ] #spo flanagan

cal_52 <- Sept_Stats[61:78, ]

cal_52_5 <- Sept_Stats[101:118, ]

cal_64 <- Sept_Stats[121:138, ]

cal_53 <- Sept_Stats[141:158, ]

cal_63 <- Sept_Stats[161:178, ]

cal_53_8 <- Sept_Stats[181:198, ]

cal_57 <- Sept_Stats[201:218, ]

cal_61 <- Sept_Stats[221:238, ]

cal_16_dist <- Sept_Stats[241:258, ]

cal_mark_n <- Sept_Stats[261:278, ]

cal_mark_s <- Sept_Stats[281:298, ]

cal_76 <- Sept_Stats[301:318, ]

cal_72 <- Sept_Stats[321:338, ]

cal_73 <- Sept_Stats[341:358, ]

cal_68 <- Sept_Stats[361:378, ]

cal_55_7 <- Sept_Stats[381:398, ]

cal_55_2 <- Sept_Stats[401:418, ]

cal_75 <- Sept_Stats[423:440, ]

cal_maywood <- Sept_Stats[443:460, ]

cal_maywood2 <- Sept_Stats[463:480, ]

adminstrative <- Sept_Stats %>% 
  filter(AOIC_Stat == "Anderson")

tidy_16 <- cal_16_dist %>% tidy_up()

