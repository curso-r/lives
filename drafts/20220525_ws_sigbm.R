# Carregar pacotes --------------------------------------------------------

library(tidyverse)
library(httr)

# Extraindo tabela --------------------------------------------------------

u0 <- "https://app.anm.gov.br/SIGBM/Publico/GerenciarPublico"

params <- list(
  "startIndex" = 0,
  "pageSize" = 500,
  "orderProperty"= "TotalPontuacao",
  "orderAscending"= FALSE,
  "DTOGerenciarFiltroPublico[CodigoBarragem]" = 0,
  "DTOGerenciarFiltroPublico[NecessitaPAEBM]" = FALSE,
  "DTOGerenciarFiltroPublico[BarragemInseridaPNSB]" = 0,
  "DTOGerenciarFiltroPublico[PossuiBackUpDam]" = 0,
  "DTOGerenciarFiltroPublico[SituacaoDeclaracaoCondicaoEstabilidade]" = 0
)

resposta <- httr::POST(
  u0,
  body = params,
  encode = "form"
)

resposta_json <- jsonlite::fromJSON(content(resposta, "text"))

tabela_barragens <- as_tibble(resposta_json$Entities)

u1 <- "https://app.anm.gov.br/SIGBM/BarragemPublico/Detalhar/{id_barragem}"

detalhamento_barragem <- httr::GET(
  stringr::str_glue(u1, id_barragem = tabela_barragens$Chave[1]))

xpath_tipo_de_barragem <- '//*[@id="formBarragem"]/fieldset/div[1]/div'

detalhamento_barragem |>
  xml2::read_html() |>
  xml2::xml_find_all(xpath = xpath_tipo_de_barragem) |>
  xml2::xml_find_all('label') |>
  xml2::xml_find_all("input") |>
  xml2::xml_attrs()

xpath_tipo_de_barragem <- '//*[@id="existeBarragemInternaSelante"]/div/div'

detalhamento_barragem |>
  xml2::read_html() |>
  xml2::xml_find_all(xpath = xpath_tipo_de_barragem) |>
  xml2::xml_find_all('label') |>
  xml2::xml_find_all("input") |>
  xml2::xml_attrs()

