## RPS Map
source('theme_fig.R')
library(maptools)
library(mapproj)
library(rgeos)
library(rgdal)
library(RColorBrewer)
library(tidyverse)
library(sf)
library(svglite)
#devtools::install_github('tidyverse/ggplot2')

# for theme_map
devtools::source_gist("33baa3a79c5cfef0f6df")

# https://www.census.gov/geo/maps-data/data/cbf/cbf_counties.html
# read U.S. counties moderately-simplified GeoJSON file
us <- st_read('geo_data/cb_2016_us_county_20m/cb_2016_us_county_20m.shp')
st_write(us, 'geo_data/cb_2016_us_county_20m/cb_2016_us_county_20m.geojson')



#blending hrbrmstr's sp adjustments within the context of a sf

# convert it to Albers equal area
us_aea <- st_transform(us, "+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs")

# extract, then rotate, shrink & move alaska (and reset projection)
# need to use state IDs via # https://www.census.gov/geo/reference/ansi_statetables.html
alaska <- as(us_aea[us_aea$STATEFP=="02",], 'Spatial')
alaska <- elide(alaska, rotate=-50)
alaska <- elide(alaska, scale=max(apply(bbox(alaska), 1, diff)) / 2.3)
alaska <- elide(alaska, shift=c(-2100000, -2500000))
proj4string(alaska) <- proj4string(as(us_aea, 'Spatial'))
alaska <- st_as_sf(alaska)

# extract, then rotate & shift hawaii
hawaii <- as(us_aea[us_aea$STATEFP=="15",], 'Spatial')
hawaii <- elide(hawaii, rotate=-35)
hawaii <- elide(hawaii, shift=c(5400000, -1400000))
proj4string(hawaii) <- proj4string(as(us_aea, 'Spatial'))
hawaii <- st_as_sf(hawaii)

# remove old states and put new ones back in; note the different order
# we're also removing puerto rico in this example but you can move it
# between texas and florida via similar methods to the ones we just used
us_aea <- us_aea[!us_aea$STATEFP %in% c("02", "15", "72"),]
us_aea <- rbind(us_aea, alaska, hawaii)

us_aea$STATEFP <- as.character(us_aea$STATEFP) #fix factors

map <- fortify(us_aea, region="GEOID")

st_write(us_aea, 'geo_data/us_elided.geojson')

# plot which states have RPS
rps_by_state <- read_csv('rps-by-state.csv')
fips <- read_delim('data/fips_code.txt', delim = '|')
rps_by_state <- rps_by_state %>%
  left_join(fips %>% select(STATE, STUSAB), by=c("State_2_code" = "STUSAB"))

us_aea_state <- us_aea %>%
  group_by(STATEFP) %>%
  st_union(by_feature = TRUE)

#assign data to geometry


us_rps <- us_aea %>%
  left_join(rps_by_state, by= c("STATEFP" = "STATE"))

# plotting
rp_type_scale <- c('None' = '#cccccc',
                   'Repealed' = '#d01c8b',
                   'RPG' = '#b8e186',
                   'RPS' = '#4dac26')
rps_plot <- us_rps %>%
  ggplot() +
  geom_sf(aes(fill = RP_Goal, color = RP_Goal)) +
  scale_fill_manual(values = rp_type_scale
  )+
  scale_color_manual(values = rp_type_scale) +
  theme_fig()

rps_plot

ggsave(rps_plot, filename = 'rps_plot.svg', width = 5, height = 3, units = 'in')

