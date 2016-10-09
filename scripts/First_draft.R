# packages ####
library(tidyverse)
library(magrittr)
library(dataViewer)
library(ggmap)
library(png)
library(lubridate)

# functions we will use ###
# Function to convert date
ms.to.date <- function(x, timezone) {
  as.POSIXct(x/1000, origin = "1970-01-01", tz=timezone)
}

# read in datasets
pokemonGo <- read.csv('data/pokemon-spawns.csv', stringsAsFactors = F) %>%
  filter(., encounter_ms != -1) %>%
  mutate(., date = ms.to.date(encounter_ms, timezone = "America/Los_Angeles")) %>%
  group_by(., time = cut(date, breaks = '15 mins')) %>%
  mutate(hour = time) %>%
  data.frame()

first_15_mins <- filter(pokemonGo, time == time[1])





head(pokemonGo)

Bulbasaur <- select(pokemonGo, c(num, name, lat, lng)) %>%
  filter(., name == "Bulbasaur")

BulbPic <- readPNG('data/pokepics/Bulbasaur.png')
g <- grid::rasterGrob(BulbPic, interpolate=TRUE)

Bulbasaur_map <- get_map(location = 'San Francisco')
map <- suppressWarnings(suppressMessages(ggmap::get_map(Weedle_bbox)))
pbase <- ggmap::ggmap(Bulbasaur_map) +
  ggplot2::coord_fixed(ratio = 1) +
  ggplot2::theme(axis.title = ggplot2::element_blank()) +
  mapply(function(xx, yy) 
    annotation_custom(g, xmin=xx-0.01, xmax=xx+0.01, ymin=yy-0.01, ymax=yy+0.01),
    Bulbasaur$lng[1:200], Bulbasaur$lat[1:200])

# filter for one hour
data <- filter(pokemonGo, date < as.POSIXct('2016-07-26 02:00:00'))
