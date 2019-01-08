#CTA Data
library(tidyverse)
library(ggmap)
library(sf)
library(rgdal)
library(rmapshaper)
library(spdplyr)

#GeoJson prep
cpd_geojson <- file.path("~/Dropbox (Personal)/Coding Projects/javascript/simple_json/json/CPD districts.geojson")
cpd_districts <- readOGR(cpd_geojson) #spatial polygons data frame
cpd_districts <- cpd_districts  %>%
  mutate(region = map_chr(1:length(cpd_districts@polygons), function(i){
    cpd_districts@polygons[[i]]@ID
  }))

shapefile <- cpd_districts %>% broom::tidy()

cpd_districts_sf <- cpd_districts %>% st_as_sf() #Polygon



#GGMap
Sys.chmod("api_key.txt", mode = "0400")
con <- system.file("\api_key.txt", "r")
key <- readLines("api_key.txt", n = 1, ok = TRUE)
register_google(key)

#CTA Data
cta_l <- read_csv("CTA_-_System_Information_-_List_of__L__Stops.csv")
cta_bus <- read_csv("CTA_-_System_Information_-_Bus_Stop_Locations_in_Digital_Sign_Project.csv")

#"\\(([^,]+), ([^)]+)\\)" <- remove between parens
cta_l_LatLong <- cta_l %>%
  select(STOP_ID, Location) 

chicago_map <- get_map(location = "chicago", zoom = 10)

cta_bus_stops <- cta_bus %>%
  select(Stop_ID, Direction, CTA_Stop_Name = `CTA Stop Name`, Location) %>% 
  mutate(Type = "Bus")

cta_l_stops <- cta_l %>%
  select(Stop_ID = STOP_ID, `CTA Stop Name` = STOP_NAME, 
         Red = RED , Blue =BLUE,
         Green = G, Brown = BRN, 
         Purple = P, Pexp, 
         Pink = Pnk, Orange = O, 
         Yellow = Y, Location) %>% 
  mutate(Type = "Train") %>%
  arrange(desc(Stop_ID))

cta_stops <- cta_l_stops %>%
  full_join(cta_bus_stops, by = c("Stop_ID" = "Stop_ID", 
                                  "Type" = "Type",
                                  "Location" = "Location")) %>%
  extract(Location, c("lat", "lng"), "\\(([^,]+), ([^)]+)\\)") %>%
  mutate(lat = as.numeric(lat), lng = as.numeric(lng))

cta_stops_sf <- cta_stops %>%
  st_as_sf(coords = c("lng", "lat"),
           crs = "+proj=longlat +datum=WGS84")

#https://stackoverflow.com/questions/45891034/create-choropleth-map-from-coordinate-points

#counts cta stops in police districts
total_stops <- cta_stops_sf %>%
  st_within(cpd_districts_sf, sparse = FALSE, prepared = TRUE)

#add counts column to CPD df
cpd_districts_df <- cpd_districts_sf %>%
  mutate(Count = apply(total_stops, 2, sum))

chicago_transit_map <- chicago_map %>%
  ggmap() +
  geom_point(data = cta_stops, aes(x = lng, y = lat, col =  Type))




chicago_with_districts_ggmap <- ggmap(chicago_map, extent = "normal",
                                      maprange = FALSE) + 
  geom_polygon(aes(x = long, y = lat, group = group), 
               data = shapefile, 
               color = "black", fill = "grey",
               size = .4,
               alpha = .4)


#CPD Data
chicago_with_districts <- ggmap(chicago_map, extent = "normal",
                                      maprange = FALSE) + 
  geom_polygon(aes(x = long, y = lat, group = group), 
               data = shapefile, 
               color = "black", fill = "grey",
               size = .4,
               alpha = .6)

#CTA + CPD
div_cta <- chicago_with_districts_ggmap + 
  geom_point(data = cta_stops, aes(x = lng, y = lat, col =  Type))

cpd_districts_df %>%
  ggplot() +
  geom_sf(size = 1)

heat_map_CTA <- ggplot(cpd_districts_df) + 
  geom_sf(aes(fill = Count), size = .5, 
          col = "white") +
  scale_fill_viridis_c(name = "Number of CTA Stops") +
  labs(title = "CTA Stops within Police Districts")
