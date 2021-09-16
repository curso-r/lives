#' Author: Athos e Fernando
#' Subject: Search Eschmeyer's Catalog

library(tidyverse)
library(magrittr)
library(httr)
library(rvest)
# Import -----------------------------------------------------------------------
url <- "https://researcharchive.calacademy.org/research/ichthyology/catalog/fishcatmain.asp"


# tentativa RVEST ---------------------------------------------------------
sessao_inicial <- rvest::session(url)
form_da_busca <- sessao_inicial %>% html_form() %>% first()

form_da_busca_submited <- form_da_busca %>%
  html_form_set(
    "tbl" = "Species",
    "contains" = "Salmo"
  )

sessao_busca <- sessao_inicial %>%
  session_submit(form_da_busca_submited)

xml2::write_html(content(sessao_busca$response), file = "teste2.html")
BROWSE("teste2.html")



# cabeçalho ---------------------------------------------------------------
# add_headers(
#   # ":authority" = "researcharchive.calacademy.org",
#   # ":method" = "POST",
#   # ":path" = "/research/ichthyology/catalog/fishcatmain.asp",
#   # ":scheme" = "https",
#   "accept" = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
#   "accept-encoding" = "gzip, deflate, br",
#   "accept-language" = "pt,en-US;q=0.9,en;q=0.8",
#   "cache-control" = "max-age=0",
#   "content-length" = "47",
#   # "content-type" = "application/x-www-form-urlencoded",
#   "cookie" = "_ga=GA1.2.911969377.1629991684; _gid=GA1.2.1427546200.1631745341; ASPSESSIONIDSECCCDTC=FMDGMIDBLKPBHMFNJLNGDINF",
#   "origin: https" = "//researcharchive.calacademy.org",
#   "referer: https" = "//researcharchive.calacademy.org/research/ichthyology/catalog/fishcatmain.asp",
#   "sec-ch-ua" = 'Google Chrome";v="93", " Not;A Brand";v="99", "Chromium";v="93"',
#   "sec-ch-ua-mobile" = "?0",
#   "sec-ch-ua-platform" = '"Windows"',
#   "sec-fetch-dest" = "document",
#   "sec-fetch-mode" = "navigate",
#   "sec-fetch-site" = "same-origin",
#   "sec-fetch-user" = "?1",
#   "upgrade-insecure-requests" = "1",
#   "user-agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36"),



# tentativa HTTR ----------------------------------------------------------
inicial_pagina <- GET(url)
inicial_conteudo <- content(inicial_pagina)

# "cichla kelberi"

POST_safe <- purrr::safely(POST)

lista_respostas <- function(especie, path = getwd()) {

  dados <- list(
    "tbl" = "Species",
    "contains" = especie,
    "Submit" = "Search"
  )

  if(!dir.exists(path)) dir.create(path)

  especie_tratado <- stringr::str_replace_all(especie, '[:blank:]', '_')
  nome_do_html <- glue::glue("{especie_tratado}.html")
  caminho_do_html <- file.path(path, nome_do_html)

  search_pagina <- POST_safe(
    url = url,
    body = dados,
    encode = "form",
    write_disk(caminho_do_html, overwrite = TRUE)
  )

  return(caminho_do_html)
}

respostas <- lista_respostas("cichla kelberi")
respostas <- lista_respostas("Salmo", path = "peixes")


html <- respostas %>%
  read_html() %>%
  xml2::xml_find_all(".//p[@class='result']") %>%
  `[`(-1) %>%
  `[`(c(FALSE, TRUE))

tabela <- tibble(
  resposta = xml2::xml_text(html),
  current_status = str_extract(resposta, "Current status.+$"),
  especie = html %>% xml2::xml_find_first("b") %>% xml2::xml_text()
)





BROWSE(respostas)


# Tidy -------------------------------------------------------------------------

# Visualize --------------------------------------------------------------------

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
