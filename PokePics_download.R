# download pokemon pictures

pokestats <- read.csv('data/pokemonGO.csv', stringsAsFactors = F)

pokemon_names <- unique(pokestats$Name)

# download all files
save_poke_png <- function(x){
  pokemon <- pokestats[pokestats$Name == x,]
  download.file(pokemon$Image.URL, destfile = paste('data/pokepics/', pokemon$Name, '.png', sep =''))
}

plyr::l_ply(pokemon_names, save_poke_png)