source('theme_fig.R')
library(tidyverse)
library(sf)

# read Solid Biomass Data (we're going to just get the data from, forget the geospatial)
biomass_solid <- st_read('geo_data/solid_biomass/SolidBiomass.shp')
biomass_solid_df <- biomass_solid %>%
  st_set_geometry(NULL) %>%
  mutate(
    CNTY_NAME = as.character(CNTY_NAME)
    STATE_NAME = as.character(STATE_NAME)
    FIPS = as.n
  )

us_biomass <- us_aea %>%
  left_join(biomass_solid_df %>% select(-c(CNTY_NAME, STATE_NAME)),
            by = c('GEOID' = 'FIPS'))

legend_mill = guide_colorbar(title = "Primary Mill Residues 1000 tonnes/yr",
                             nbin = 6)

biomass_plot <- us_biomass %>%
  mutate(PrimMill = ifelse(PrimMill == 0, NA, PrimMill/1e3)) %>%
  ggplot() +
  geom_sf(aes(fill = PrimMill), color = 'grey90') +
  coord_sf(datum = NA) +
  # scale_color_distiller(palette = 'YlGnBu', direction = 1,
  #                       na.value = 'grey90',
  #                       guide = legend_mill) +
  scale_fill_distiller(palette = 'YlGnBu', direction = 1,
                       na.value = 'white',
                       guide = legend_mill,
                       breaks = c(100, 800, 1400)) +
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

biomass_plot

ggsave(biomass_plot, filename = 'biomass_plot.svg', width = 5, height = 3, units = 'in')