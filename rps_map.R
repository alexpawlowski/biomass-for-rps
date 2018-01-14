## RPS Map

library(maptools)
library(mapproj)
library(rgeos)
library(rgdal)
library(RColorBrewer)
library(ggplot2)

# for theme_map
devtools::source_gist("33baa3a79c5cfef0f6df")

# https://www.census.gov/geo/maps-data/data/cbf/cbf_counties.html
# read U.S. counties moderately-simplified GeoJSON file
us <- readOGR(dsn="data/us.geojson", layer="OGRGeoJSON")