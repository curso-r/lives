#' Author:
#' Subject:

# library(tidyverse)
library(magrittr)

# obter uma base de bandeiras dos estados do brasil
# [ok] obter uma base de informações para plotar

abjData::pnud_uf |>
  dplyr::glimpse()

# Import -----------------------------------------------------------------------

h <- httr::GET("https://pt.wikipedia.org/wiki/Categoria:Bandeiras_estaduais_do_Brasil") |>
  xml2::read_html()


links <- h |>
  xml2::xml_find_all("//a[contains(@title, 'Bandeira')]") |>
  xml2::xml_attr("href") |>
  stringr::str_remove("Categoria:") |>
  stringr::str_replace("Bandeiras", "Bandeira")

links <- paste0("https://pt.wikipedia.org/", links)

links <- links[!stringr::str_detect(links, "Brasil|Rio_de_Janeiro|o_Paulo")]

link_df_bonitao <- "https://pt.wikipedia.org/wiki/Distrito_Federal_(Brasil)"
link_rj_bonitao <- "https://pt.wikipedia.org/wiki/Rio_de_Janeiro_(estado)"
link_sp_bonitao <- "https://pt.wikipedia.org/wiki/S%C3%A3o_Paulo_(estado)"

links <- c(links, link_df_bonitao, link_rj_bonitao, link_sp_bonitao)

pegar_imagem_bandeira <- function(link) {
  u_img <- link |>
    httr::GET() |>
    xml2::read_html() |>
    xml2::xml_find_first("//img[@class='thumbborder' and contains(@src, '.svg.png')]") |>
    xml2::xml_attr("src")
  u_img <- paste0("https:", u_img)

  f <- paste0(
    "drafts/bandeiras_ufs/",
    basename(u_img)
  )
  usethis::ui_info(f)

  if (!file.exists(f)) {
    httr::GET(
      u_img,
      httr::write_disk(f, overwrite = TRUE)
    )
  }

  f

}

fs::dir_create("drafts/bandeiras_ufs/")
# pegar_imagem_bandeira(links[1])
purrr::walk(links, pegar_imagem_bandeira)

length(fs::dir_ls("drafts/bandeiras_ufs/"))

# Tidy -------------------------------------------------------------------------

arrumar_nome <- function(name) {
  name |>
    basename() |>
    URLdecode() |>
    stringr::str_remove(".*(Bandeira_d[eoa]|Flag_of)(_estado_d[eo])?_") |>
    # fs::path_ext_remove() |>
    # fs::path_ext_remove() |>
    stringr::str_remove("\\..*") |>
    stringr::str_remove("_\\(.*$") |>
    stringr::str_replace_all("_", " ")
}

ufs <- abjData::muni |>
  dplyr::distinct(uf_nm, uf_sigla, uf_id) |>
  dplyr::mutate(uf_nm = dplyr::case_when(
    uf_nm == "Amazônas" ~ "Amazonas",
    TRUE ~ uf_nm
  ))


base_bandeiras <- fs::dir_ls("drafts/bandeiras_ufs/") |>
  tibble::enframe() |>
  dplyr::mutate(uf_nm = arrumar_nome(name)) |>
  dplyr::inner_join(ufs, "uf_nm") |>
  dplyr::select(-value)

# URLencode("á")
# URLdecode("%C3%A1")

variavel_interesse <- "idhm"

da_plot <- abjData::pnud_uf |>
  dplyr::filter(ano == "2010") |>
  dplyr::select(ufn, dplyr::all_of(variavel_interesse)) |>
  dplyr::inner_join(base_bandeiras, c("ufn" = "uf_nm"))

# Visualize --------------------------------------------------------------------

library(ggplot2)
library(ggtext)


redimensionar_img <- function(img) {
  # img <- "drafts/bandeiras_ufs/300px-Bandeira_de_Santa_Catarina.svg.png"
  magick::image_read(img) |>
    magick::image_resize("x30") |>
    magick::image_write(img)
}

purrr::walk(da_plot$name, redimensionar_img)

p <- da_plot |>
  dplyr::mutate(
    ufn = forcats::fct_reorder(ufn, idhm),
    lab = stringr::str_glue("<img src='{name}' style='max-width:50px;' />"),
    lab = forcats::fct_reorder(lab, idhm)
  ) |>
  ggplot(aes(x = idhm, y = lab)) +
  geom_col(fill = "royalblue") +
  theme_minimal() +
  theme(
    axis.text.y = element_markdown()
  )

# plotly::ggplotly(p)

plota_variavel <- function(variavel_interesse) {

  da_plot <- abjData::pnud_uf |>
    dplyr::filter(ano == "2010") |>
    dplyr::select(ufn, v = dplyr::all_of(variavel_interesse)) |>
    dplyr::inner_join(base_bandeiras, c("ufn" = "uf_nm"))

  da_plot |>
    dplyr::mutate(
      lab = stringr::str_glue("<img src='{name}' style='width:90px;' />"),
      lab = forcats::fct_reorder(lab, v)
    ) |>
    ggplot(aes(x = v, y = lab)) +
    geom_col(fill = "royalblue") +
    theme_minimal(18) +
    theme(
      axis.text.y = element_markdown()
    )

}

plota_variavel("idhm")

library(shiny)

variaveis <- abjData::pnud_uf |>
  dplyr::select(where(is.numeric)) |>
  dplyr::select(-ano, -uf) |>
  names()

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      selectInput("variavel", "Variável", variaveis, "idhm")
    ),
    mainPanel = mainPanel(
      plotOutput("grafico", height = "1000px")
    )
  )
)

server <- function(input, output, session) {

  output$grafico <- renderPlot({

    plota_variavel(input$variavel)

  })

}

shinyApp(ui, server)


# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
