library(tidyverse)
library(leaflet)
library(ggmap)
library(spdplyr)
library(geojsonio)
library(rgdal)
library(rmapshaper)
library(sf)

#GeoJson prep
cpd_geojson <- file.path("~/Dropbox (Personal)/Coding Projects/javascript/simple_json/json/CPD districts.geojson")
cpd_districts <- readOGR(cpd_geojson)

#Diversion data, geocoded.
location <- file.path("../Core Stats/gis_data_with_addresses.RDS")
data_for_gis <- read_rds(location)
diversion_table <- data_for_gis[[2]]
client_geo_coded <- data_for_gis[[1]]
client_geo_coded$JEMSID <- as.factor(client_geo_coded$JEMSID)
geo_coded_diversions <- diversion_table %>% full_join(client_geo_coded, by = "JEMSID")
geo_na <-  is.na(geo_coded_diversions)
geo_coded_diversions <- geo_coded_diversions %>%
  distinct(JEMSID, .keep_all = TRUE) %>%
  filter(!is.na(lat) | !is.na(lng))

geo_coded_diversions$ITVSTS <- as.factor(geo_coded_diversions$ITVSTS)

geo_coded_diversions_sf <- st_as_sf(x = geo_coded_diversions,
                                    coords = c("lng", "lat"),
                                    crs = "+proj=longlat +datum=WGS84")

#Color Palette for chloropeth

pal <- colorFactor(palette = "plasma",
                   domain = geo_coded_diversions$ITVSTS)

cpd_districts_map <- leaflet(cpd_districts) %>%
  addTiles() %>%
  setView(lng = -87.7, lat = 41.9, zoom = 9) %>%
  addPolygons(color = "black") 

#Leaflet
all_diversions <- leaflet(cpd_districts) %>%
  addTiles() %>%
  setView(lng = -87.7, lat = 41.9, zoom = 12) %>%
  addPolygons(color = "black") %>%
  addCircles(data = geo_coded_diversions_sf) %>%
  addScaleBar()

diversion_by_status <- leaflet(cpd_districts) %>%
addTiles() %>%
  setView(lng = -87.7, lat = 41.9, zoom = 12) %>%
  addPolygons(color = "black",
              fillColor = "#D3D3D3",
              fillOpacity = 0.1) %>%
  addCircles(data = geo_coded_diversions_sf,
             color = ~pal(ITVSTS)) %>%
  addLegend("bottomright", pal = pal,
            value= ~geo_coded_diversions_sf$ITVSTS,
            title = "Intervention Status")

## ggmap functions
Sys.chmod("api_key.txt", mode = "0400")

con <- system.file("\api_key.txt", "r")
key <- readLines("api_key.txt", n = 1, ok = TRUE)


register_google(key)

shapefile <- cpd_districts %>% broom::tidy()


chicago_map <- get_map("Chicago", zoom = 12)

chicago_with_districts_ggmap <- ggmap(chicago_map, extent = "normal",
                 maprange = FALSE) + geom_polygon(aes(x = long, 
                                                 y = lat, 
                                                 group = group), 
                                              data = shapefile, 
                                             color = "black", fill = "grey",
                                             size = .4,
                                             alpha = .4)

