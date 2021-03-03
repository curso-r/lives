#' Author: Julio Trecenti
#' Subject:

 library(tidyverse)
library(magrittr)
library(feather)
# Import -----------------------------------------------------------------------
feather <- read_feather("data-raw/sabesp.feather")
# Tidy -------------------------------------------------------------------------
feather %>%
  mutate(
    prec_hist = readr::parse_number(prec_hist, locale = readr::locale(decimal_mark = ",")) ,
    mes = lubridate::month(dia, label = TRUE, abbr = FALSE)
  ) %>%
  group_by(mes, nome) %>%
  summarise(
    n = n(),
    media = prec_hist
  )
# Visualize --------------------------------------------------------------------

diamante <- read_feather("data-raw/diamante.feather")
diamante %>%
  filter(preco > 2000) %>%
  group_by(
    corte, transparencia
  ) %>%
  summarise(media = mean(quilate)) %>%
  tidyr::pivot_wider(names_from = corte, values_from = media) %>%
  arrange(desc(Ideal))
# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
