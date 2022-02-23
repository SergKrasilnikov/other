#===============================================================================
# 2021-06-19 -- MPIDR dataviz
# Dataviz challenge
# Sergey Krasilnikov, krasilnikovruss@gmail.com
#===============================================================================

# 1. MAP ------------------------------------------------------------------

# Choose any European country and create a choropleth map of it's regions using any Eurostat indicator

# http://ec.europa.eu/eurostat/web/regions/data/database

#===============================================================================

library(tidyverse)
library(janitor)
library(sf)
library(ggthemes)

library(eurostat)

library(rmapshaper)

# the built-in dataset of EU boundaries
gd <- eurostat_geodata_60_2016 %>% 
  clean_names()

# transform the projection for the one suitable for EU (spatially for Sweden)
gdtr <- gd %>% 
  st_transform(crs = 3006)

# filter out North Europe (except Iceland and Greenland)
gd_se <- gdtr %>% 
  filter(cntr_code %in% c("SE", "NO", "DK", "FI"), levl_code == 2) 

# the basic map
gd_se %>%
  ggplot()+
  geom_sf()

# get rid of the grid
gd_se %>% 
  ggplot()+
  geom_sf()+
  coord_sf(crs = 3006, datum = NA)+
  theme_map()

# create inner boundaries as lines
bord <- gdtr %>% 
  filter(cntr_code %in% c("SE", "NO", "DK", "FI"), levl_code == 0) %>% 
  ms_innerlines()

# download the dataset found manually HRST
df <- get_eurostat("hrst_st_rcat")

# if the automated download does not work, the data can be grabbed manually at
# http://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing

# time series length
df$time %>% unique()

# ages
df$category %>% unique()

# now we filter out HRSTO for Sweden regions, NUTS2 only, let's keep all the years for now
df_se <- df %>% 
  filter(
    category == "HRSTO",
    geo %>% str_sub(1,2) %in% c("SE", "NO", "DK", "FI"), # only Sweden
    geo %>% paste %>% nchar == 4 # only NUTS-2 
  ) %>% 
  transmute(
    id = geo %>% paste,
    year = time %>% lubridate::year(),
    HRSTO = values
  )

# the last thing is to join stat and spatial datasets
dj_se <- left_join(gd_se, df_se, "id")

# now let's use viridis colors and add boundaries
dj_se %>% 
  ggplot()+
  geom_sf(aes(fill = HRSTO), color = NA)+
  geom_sf(data = bord, color = "gray92")+
  scale_fill_viridis_c(option = "B")+
  coord_sf(datum = NA)+
  theme_map()+
  theme(legend.position = c(.9, .1))
  labs(fill = "HRSTO")
  
# plot as p
p <- ggplot2::last_plot()

# add labs and set them
p + labs(title = "Human resources in Science and Technology Occupation \n (mean for 1991 to 2020)",
    caption = "Data source: Eurostat \n Produced by: SKrasilnikov")+
  theme(
    plot.title = element_text(hjust = 0.5, size = 12, face = "bold"),    # Center title position and size
)

# save
ggsave ("out/NorthEurope_HRSTO_2.png", width = 5, height = 6, dpi = 300)


