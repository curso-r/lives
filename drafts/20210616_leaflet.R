#' Author: Athos
#' Subject: leaflet

library(tidyverse)
library(magrittr)

# Import -----------------------------------------------------------------------
library(leaflet)

dados_brutos <- read_rds("dados_brutos_educacao.rds")
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
  ) %>%
  tidyr::drop_na()

# Visualize --------------------------------------------------------------------
library(leaflet)
library(leaflet.providers)
library(leaflet.extras)

providers <- get_providers()
leaflet_map <- da %>%
  leaflet() %>%
  addTiles(urlTemplate = providers$providers_details$OpenTopoMap$url) %>%
  addTiles(urlTemplate = providers$providers_details$OpenRailwayMap$url) %>%
  setView(-55,-13, 5) %>%
  addHeatmap(~lng, ~lat, intensity = .001, radius = 20, blur = 10) %>%
  addMarkers(~lng, ~lat, data = sample_n(da, 100)) %>%
  addDrawToolbar() %>%
  addMeasurePathToolbar() %>%
  addControlGPS(
    options = gpsOptions(
      position = "topleft",
      activate = TRUE,
      autoCenter = TRUE,
      maxZoom = 60,
      setView = TRUE
    )
  )
leaflet_map

# shinyzinho ----------------------
library(shiny)

ui <- fluidPage(
  leafletOutput('map'),
  verbatimTextOutput("input")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet_map
  })

  output$input <- renderPrint({
    shiny::reactiveValuesToList(input)
  })
}

shinyApp(ui, server)
