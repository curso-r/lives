# conversationId:
# dadosConsulta.pesquisaLivre: league of legends
# tipoNumero: UNIFICADO
# numeroDigitoAnoUnificado:
# foroNumeroUnificado:
# dadosConsulta.nuProcesso:
# dadosConsulta.nuProcessoAntigo:
# classeTreeSelection.values:
# classeTreeSelection.text:
# assuntoTreeSelection.values:
# assuntoTreeSelection.text:
# agenteSelectedEntitiesList:
# contadoragente: 0
# contadorMaioragente: 0
# cdAgente:
# nmAgente:
# dadosConsulta.dtInicio:
# dadosConsulta.dtFim: 13/03/2024
# varasTreeSelection.values:
# varasTreeSelection.text:
# dadosConsulta.ordenacao: DESC

parametros <- list(
  dadosConsulta.pesquisaLivre = "league of legends",
  dadosConsulta.dtFim = "13/03/2024",
  dadosConsulta.ordenacao = "DESC",
  tipoNumero = "UNIFICADO",
  numeroDigitoAnoUnificado = "",
  foroNumeroUnificado = "",
  dadosConsulta.nuProcesso = "",
  dadosConsulta.nuProcessoAntigo = "",
  classeTreeSelection.values = "",
  classeTreeSelection.text = "",
  assuntoTreeSelection.values = "",
  assuntoTreeSelection.text = "",
  agenteSelectedEntitiesList = "",
  contadoragente = 0,
  contadorMaioragente = 0,
  cdAgente = "",
  nmAgente = "",
  dadosConsulta.dtInicio = "",
  varasTreeSelection.values = "",
  varasTreeSelection.text = ""
)

r <- httr::GET(
  url = "https://esaj.tjsp.jus.br/cjpg/pesquisar.do",
  query = parametros,
  httr::write_disk("exemplo-tjsp.html")
)

paginas <- 3

#pagina: 2
#conversationId:

baixar_pagina <- function(pag) {
  parametros_pagina <- list(
    pagina = pag, conversationId = ""
  )
  fs::dir_create("livetjsp/httr")
  f <- glue::glue("livetjsp/httr/exemplo-tjsp-{pag}.html")
  httr::GET(
    "https://esaj.tjsp.jus.br/cjpg/trocarDePagina.do",
    query = c(parametros, parametros_pagina),
    httr::write_disk(f, overwrite = TRUE)
  )
}

purrr::walk(1:3, baixar_pagina)

## USANDO O HTTR2, COMO FICA?

req <- httr2::request("https://esaj.tjsp.jus.br/cjpg/pesquisar.do")

path <- tempfile()

readr::read_file(path)

resp <- req |>
  httr2::req_url_query(!!!parametros) |>
  httr2::req_cookie_preserve(path) |>
  httr2::req_perform()

# vou ficar devendo uma forma bonitinha de salvar
resp$body |>
  writeBin("exemplo-tjsp-httr2.html")

# httr2::req_cookie_preserve(path)

baixar_pagina_httr2 <- function(pag) {
  parametros_pagina <- list(
    pagina = pag, conversationId = ""
  )
  fs::dir_create("livetjsp/httr2")
  f <- glue::glue("livetjsp/httr2/exemplo-tjsp-{pag}.html")

  resp <- httr2::request("https://esaj.tjsp.jus.br/cjpg/trocarDePagina.do") |>
    httr2::req_cookie_preserve(path) |>
    httr2::req_url_query(!!!parametros_pagina) |>
    httr2::req_perform()

  writeBin(resp$body, f)

}

purrr::walk(1:3, baixar_pagina_httr2)

# funcao <- function(...) {
#   args <- list(...)
#   args$a + args$b
# }
# lista <- list(a = 1, b = 2)
# funcao(lista)
# funcao(!!!lista)

