#' Author: Athos Damiani
#' Subject:

library(tidyverse)
library(magrittr)
library(rtweet)

# Import -----------------------------------------------------------------------
get_followers(user = "athos_damiani")

get_timeline(user = "athos_damiani")

rt <- search_tweets(
  "#curso-r", n = 1800, include_rts = FALSE, geocode = "37.78,-122.40,100mi"
)

rt$text[2] %>% cat

hashtags <- c("#curso-r", "#rstats", "#tidytuesday")
map(hashtags, search_tweets)
get_favorites()
# Tidy -------------------------------------------------------------------------

# Visualize --------------------------------------------------------------------

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
