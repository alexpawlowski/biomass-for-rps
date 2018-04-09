library(tidyverse)
library(raster)
#source('load_forest_raster.R')


#forest_raster <- setMinMax(forest_raster)
#writeRaster(forest_raster, filename = 'forests.tif', by_layer = TRUE, suffix='numbers')
forest_raster <- raster('forests.tif')
library(rasterVis)

hist(forest_raster, main = 'Distribution of values',
     col = 'purple',
     maxpixels = 22e6)
forested <- forest_raster == 1

project_raster <- projectRaster(forested, crs = '+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs ')

forested_agg <- aggregate(forested, 10)
plot(forested_agg)
#image(forest_raster, zlim = c(1,2))

forest_df <- as.data.frame(as(forested, 'SpatialPixelsDataFrame'))

forest_df <- c('value', 'x', 'y')
ggplot() +
  geom_tile