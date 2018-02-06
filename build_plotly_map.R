devtools::install_github('ropensci/plotly')

library(plotly)

#map is from hrmstr alberusa package. since I'm only planning to use the map, I wanted to reduce a package dependency. No hard feelings @hrbmstr!
us_map <- st_read('geo_data/composite_us_counties.geojson') #'geo_data/us_elided.geojson')

us_map2 <- us_map %>%
  st_transform("+proj=lcc +lat_1=33 +lat_2=45 +lat_0=39 +lon_0=-96 +x_0=0 +y_0=0 +datum=NAD83 +units=m +no_defs") %>%
  st_simplify(TRUE, dTolerance = 1000)
p <- ggplot(us_map2) + geom_sf()
ggplotly(p)

