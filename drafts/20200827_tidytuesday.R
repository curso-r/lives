#' Author: Daniel
#' Subject: tidytuesday

# library(tidyverse)
library(magrittr)

# Import -----------------------------------------------------------------------

url <- 'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-08-25/chopped.tsv'
chopped <- readr::read_tsv(url)

# DataExplorer::create_report(chopped)

# Visualize --------------------------------------------------------------------

# os jurados se repetem:
chopped %>%
  pivot_longer(
    starts_with("judge"),
    values_to = "nome_jurado",
    names_to = "coluna_jurado"
  ) %>%
  count(nome_jurado) %>%
  top_n(15, wt = n) %>%
  ggplot(aes(y = fct_reorder(nome_jurado, n), x = n)) +
  geom_col()

# cluster dos ingredientes

chopped %>%
  pivot_longer(
    c(entree, appetizer, dessert),
    names_to = "prato", values_to = "ingredientes"
  ) %>%
  mutate(
    ingredientes = stringr::str_split(ingredientes, ", ?")
  ) %>%
  unnest(ingredientes) %>%
  select(season, season_episode, prato, ingredientes) %>%
  count(ingredientes, sort = TRUE)


usa <- st_as_sf(maps::map("state", fill=TRUE, plot =FALSE))


# Model ------------------------------------------------------------------------



# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
