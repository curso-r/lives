#' Author: Athos Damiani
#' Subject: dplyr1.0.0

# remotes::install_github("allisonhorst/palmerpenguins")

library(tidyverse)

# Import -----------------------------------------------------------------------
library(palmerpenguins)

# Tidy -------------------------------------------------------------------------
penguins %>%
  mutate(
    across(starts_with("bill"), ~.^2)
  )

penguins %>%
  mutate_at(vars(starts_with("bill")), ~ .^2) %>%
  mutate(
    is_Adelie = species == "Adelie"
  )

# media de todas as colunas numericas
penguins %>%
  summarise(
    across(where(is.numeric), mean, na.rm = TRUE),
    first_species = first(species)
  )

# dlpyr < 1.0.0
penguins %>%
  summarise(
    first_species = first(species)
  ) %>%
  summarise_if(is.numeric, mean, na.rm = TRUE)




penguins %>% select(where(is.numeric))



penguins %>%
  mutate(
    across(where(is.factor), forcats::fct_explicit_na, na_level = "athos"),
    across(where(is.not.factor), tidyr::replace_na, "athos")
  )


penguins %>%
  relocate(starts_with("bill"))

# Visualize --------------------------------------------------------------------

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
