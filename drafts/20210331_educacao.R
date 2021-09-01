#' Author:
#' Subject:

# library(tidyverse)
library(magrittr)

# Import -----------------------------------------------------------------------

u <- "http://educacaoconectada.mec.gov.br/consulta-pdde"

uf <- "AC"


baixar_uf <- function(uf) {
  body <- list(
    "draw" = "1",
    "columns[0][data]" = "0",
    "columns[0][name]" = "",
    "columns[0][searchable]" = "true",
    "columns[0][orderable]" = "true",
    "columns[0][search][value]" = "",
    "columns[0][search][regex]" = "false",
    "columns[1][data]" = "1",
    "columns[1][name]" = "",
    "columns[1][searchable]" = "true",
    "columns[1][orderable]" = "true",
    "columns[1][search][value]" = "",
    "columns[1][search][regex]" = "false",
    "columns[2][data]" = "2",
    "columns[2][name]" = "",
    "columns[2][searchable]" = "true",
    "columns[2][orderable]" = "true",
    "columns[2][search][value]" = "",
    "columns[2][search][regex]" = "false",
    "columns[3][data]" = "3",
    "columns[3][name]" = "",
    "columns[3][searchable]" = "true",
    "columns[3][orderable]" = "true",
    "columns[3][search][value]" = "",
    "columns[3][search][regex]" = "false",
    "columns[4][data]" = "4",
    "columns[4][name]" = "",
    "columns[4][searchable]" = "true",
    "columns[4][orderable]" = "true",
    "columns[4][search][value]" = "",
    "columns[4][search][regex]" = "false",
    "columns[5][data]" = "5",
    "columns[5][name]" = "",
    "columns[5][searchable]" = "true",
    "columns[5][orderable]" = "true",
    "columns[5][search][value]" = "",
    "columns[5][search][regex]" = "false",
    "columns[6][data]" = "6",
    "columns[6][name]" = "",
    "columns[6][searchable]" = "true",
    "columns[6][orderable]" = "true",
    "columns[6][search][value]" = "",
    "columns[6][search][regex]" = "false",
    "columns[7][data]" = "7",
    "columns[7][name]" = "",
    "columns[7][searchable]" = "true",
    "columns[7][orderable]" = "true",
    "columns[7][search][value]" = "",
    "columns[7][search][regex]" = "false",
    "start" = "0",
    "length" = "12",
    "search[value]" = "",
    "search[regex]" = "false",
    "filter_uf" = uf,
    "filter_municipio" = "",
    "filter_inep" = "",
    "filter_escola" = "",
    "filter_ano" = ""
  )

  u_busca <- "http://educacaoconectada.mec.gov.br/modules/mod_datamapa/tmpl/default_fetch.php"
  r <- httr::POST(u_busca, body = body, encode = "form")
  parsed <- r %>%
    httr::content("text") %>%
    jsonlite::fromJSON(simplifyDataFrame = TRUE)
  tamanho <- parsed$recordsFiltered
  body$start <- 0
  body$length <- parsed$recordsFiltered
  r_completa <- httr::POST(u_busca, body = body, encode = "form")
  da_uf <- r_completa %>%
    httr::content("text") %>%
    jsonlite::fromJSON(simplifyDataFrame = TRUE) %>%
    purrr::pluck("data") %>%
    as.data.frame() %>%
    tibble::as_tibble()
  da_uf
}

todas_ufs <- sort(unique(abjData::muni$uf_sigla))

dados_brutos <- todas_ufs %>%
  purrr::set_names() %>%
  purrr::map_dfr(~{
    message(.x)
    baixar_uf(.x)
  }, .id = "uf")


dim(dados_brutos)
# write_rds(dados_brutos, "dados_brutos_educacao.rds")

mapa_estados <- geobr::read_state()


escolas <- geobr::read_schools()



# Tidy -------------------------------------------------------------------------

loc <- readr::locale(decimal_mark = ",", grouping_mark = ".")
pegar_coord <- function(x, coord) {
  if (length(x[,coord]) > 0) x[,coord] else NA_real_
}

da <- dados_brutos %>%
  dplyr::mutate(V8 = readr::parse_number(V8, locale = loc)) %>%
  dplyr::mutate(V1 = toupper(V1)) %>%
  dplyr::inner_join(escolas, c("V1" = "name_school")) %>%
  sf::st_as_sf() %>%
  dplyr::mutate(
    points = purrr::map(geom, sf::st_coordinates),
    lng = purrr::map_dbl(points, pegar_coord, "X"),
    lat = purrr::map_dbl(points, pegar_coord, "Y")
  )


# Visualize --------------------------------------------------------------------

da %>%
  tidyr::drop_na() %>%
  leaflet::leaflet() %>%
  leaflet::addTiles() %>%
  leaflet.extras::addHeatmap(
    ~lng, ~lat, intensity = .001,
    radius = 20,
    blur = 10
  )

library(ggplot2)
mapa_estados <- dados_brutos %>%
  dplyr::count(uf) %>%
  dplyr::mutate(uf = factor(uf)) %>%
  dplyr::inner_join(mapa_estados, c("uf" = "abbrev_state")) %>%
  sf::st_as_sf() %>%
  ggplot() +
  geom_sf(aes(fill = n), colour = "black", size = .2) +
  scale_fill_viridis_c(option = "A", begin = .1, end = .8) +
  theme_void()

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
