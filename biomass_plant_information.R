library(tidyverse)
library(sf)
library(maptools)
library(mapproj)
plant_info <- read_csv('data/plant_description.csv',
                       skip = 4)

plant_locations <- read_csv('data/plant_locations.csv',
                            skip = 0)

plant_info <- plant_info %>%
  left_join(plant_locations %>% select(c(`Utility ID`:Longitude)),
            by = "Plant Code")
names(plant_info) <- gsub(" ", ".", names(plant_info))

write_csv(plant_info, path = 'plant_info.csv')
plant_loc_sf <- st_as_sf(plant_info, coords = c("Longitude",
                                                "Latitude"),
                         crs = "+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs",
                         agr = "constant")
plant_loc_sf <- st_transform(plant_loc_sf, "+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs")



hawaii <- as(plant_loc_sf[plant_loc_sf$State.x == "HI",], 'Spatial')
hawaii <- elide(hawaii, rotate = -35)
hawaii <- elide(hawaii, shift = c(5400000, -1400000))
proj4string(hawaii) <- proj4string(as(plant_loc_sf, 'Spatial'))
hawaii <- st_as_sf(hawaii)


plant_loc_sf <- plant_loc_sf[!plant_loc_sf$State.x %in% c("AK", "HI"),]
plant_loc_sf <- rbind(plant_loc_sf, hawaii)

plant_loc_plot <- plant_loc_sf %>%
  ggplot() +
  geom_sf(aes(fill = Sector), color = 'grey90') +
  coord_sf(datum = NA) +
  # scale_color_distiller(palette = 'YlGnBu', direction = 1,
  #                       na.value = 'grey90',
  #                       guide = legend_mill) +
  # scale_fill_distiller(palette = 'YlGnBu', direction = 1,
  #                      na.value = 'white',
  #                      guide = legend_mill,
  #                      breaks = c(100, 800, 1400)) +
  # scale_fill_manual(values = rp_type_scale
  # )+
  # scale_color_manual(values = rp_type_scale) +
  # +
  labs(
    caption = "(2012) USDA, Forest Service's Timber Product Output"
  ) +
  theme_fig() +
  theme(
    panel.border = element_blank(),
    legend.key.width = unit(2, 'lines')
  )

plant_loc_plot
