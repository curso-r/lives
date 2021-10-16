#' Author:
#' Subject:

# library(tidyverse)
library(magrittr)

# acesso

baixa_camara <- function(camara) {
  u <- "http://internet-consultapublica.apps.sefaz.ce.gov.br/contencioso/consultar"

  body <- list(
    "numano" = "",
    "descricaocamara" = camara
  )

  r <- httr::POST(u, body = body, encode = "form")

  tag_tabela <- r %>%
    xml2::read_html() %>%
    xml2::xml_find_first("//table[@id='resolucoes']")

  links <- tag_tabela %>%
    xml2::xml_find_all(".//a") %>%
    xml2::xml_attr("href")

  da_tabela <- tag_tabela %>%
    rvest::html_table() %>%
    tibble::as_tibble() %>%
    dplyr::mutate(link = links) %>%
    janitor::clean_names()


  da_tabela
}

dados_resultado <- purrr::map_dfr(
  1:5,
  baixa_camara,
  .id = "id_camara"
)

tag_camaras <- "http://internet-consultapublica.apps.sefaz.ce.gov.br/contencioso/preparar-consultar?numano=2015&descricaocamara=" %>%
  httr::GET() %>%
  xml2::read_html() %>%
  xml2::xml_find_all("//*[@id='descricaocamara']/option")

ids_camaras <- tag_camaras %>%
  xml2::xml_attr("value")

nomes_camaras <- tag_camaras %>%
  xml2::xml_text()

tab_camaras <- tibble::tibble(
  id_camara = ids_camaras,
  nm_camara = nomes_camaras
) %>%
  dplyr::filter(id_camara != "")

da_sefaz <- dados_resultado %>%
  dplyr::inner_join(tab_camaras, c("id_camara")) %>%
  dplyr::select(-acoes) %>%
  dplyr::mutate(
    ementas = stringr::str_squish(ementas),
    ementas = abjutils::rm_accent(ementas)
  )


# Tidy -------------------------------------------------------------------------

# Visualize --------------------------------------------------------------------

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
