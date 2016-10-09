# packages ####
library(tidyverse)
library(magrittr)
library(dataViewer)
library(ggmap)
library(png)

# functions we will use ###
# Function to convert date
ms.to.date <- function(x, timezone) {
  as.POSIXct(x/1000, origin = "1970-01-01", tz=timezone)
}

# read in datasets
pokemonGo <- read.csv('data/pokemon-spawns.csv', stringsAsFactors = F) %>%
  filter(., encounter_ms != -1) %>%
  mutate(., date = ms.to.date(encounter_ms, timezone = "America/Los_Angeles"))

pokestats <- read.csv('data/pokemonGO.csv', stringsAsFactors = F)

pokemon_names <- unique(pokestats$Name)

# download all files
save_poke_png <- function(x){
  pokemon <- pokestats[pokestats$Name == x,]
  download.file(pokemon$Image.URL, destfile = paste('data/pokepics/', pokemon$Name, '.png', sep =''))
}

plyr::l_ply(pokemon_names, save_poke_png)


lapply(pokemon_names, function(x){paste('data/pokepics/', pokestats$Name, '.png', sep ='')})



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
