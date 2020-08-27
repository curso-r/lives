#' Author: Julio Trecenti
#' Subject: Scraper da Sabesp

library(tidyverse)
# library(magrittr)


# Import -----------------------------------------------------------------------

r <- httr::GET(u)

## Equivalentes!
# httr::content(r, "text") %>%
#   jsonlite::fromJSON(simplifyDataFrame = TRUE)
#
# httr::content(r, "parsed", simplifyDataFrame = TRUE)

#' Baixar um dia da sabesp
#'
#' @param dia dia em YYYY-MM-DD
#'
sabesp_baixar_dia <- function(dia) {

  # download
  u <- paste0(
    "http://mananciais.sabesp.com.br/api/Mananciais/ResumoSistemas/",
    dia
  )
  r <- httr::GET(u)

  # parse
  da <- httr::content(r, "text") %>%
    jsonlite::fromJSON(simplifyDataFrame = TRUE) %>%
    purrr::pluck("ReturnObj", "sistemas") %>%
    tibble::as_tibble() %>%
    janitor::clean_names()

  da
}

dias <- purrr::set_names(Sys.Date() - 0:30)
da_sabesp <- purrr::map_dfr(dias, sabesp_baixar_dia, .id = "dia")

# Tidy -------------------------------------------------------------------------

xml2::read_html("<table><tr><td>1.3</td></tr></table>") %>%
  xml2::xml_find_first("//table") %>%
  rvest::html_table() %>%
  tibble::as_tibble()

# Visualize --------------------------------------------------------------------

da_sabesp %>%
  mutate(dia = as.Date(dia)) %>%
  ggplot(aes(x = dia, y = volume_porcentagem, colour = nome)) +
  geom_line() +
  theme_minimal()

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

readr::write_rds(da_sabesp, "data-raw/da_sabesp.rds", compress = "xz")
