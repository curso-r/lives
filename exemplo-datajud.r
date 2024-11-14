api_key <- "cDZHYzlZa0JadVREZDJCendQbXY6SkJlTzNjLV9TRENyQk1RdnFKZGRQdw=="

endpoint <- "https://api-publica.datajud.cnj.jus.br/api_publica_{tribunal}/_search"

# remotes::install_github("abjur/forosCNJ")
forosCNJ::da_justica

tribunais_estaduais <- forosCNJ::da_tribunal |>
  tibble::as_tibble() |>
  dplyr::filter(id_justica == 8) |>
  dplyr::pull(sigla) |>
  stringr::str_to_lower()

links <- glue::glue(endpoint, tribunal = tribunais_estaduais)

id_processo <- "10219161720228260224"

# exemplo básico de uso ----------------------------------------------

library(httr)

#Substituir <API Key> pela Chave Pública
headers <- httr::add_headers(
  "Authorization" = paste("ApiKey", api_key)
)

payload <- list(
  query = list(
    match = list(
      numeroProcesso = id_processo
    )
  )
)

res <- httr::POST(
  links[25],
  body = payload,
  headers,
  encode = "json"
)

dados_resultantes <- httr::content(res, "parsed", simplifyDataFrame = TRUE) |>
  purrr::pluck("hits", "hits", "_source") |>
  tibble::as_tibble()

dplyr::glimpse(dados_resultantes)

dados_resultantes$movimentos

cat(content(res, 'text'))

dados_resultantes$orgaoJulgador

# exemplo de busca por assunto do processo.

codigo_assunto <- "4829"

body <- list(
  query = list(
    bool = list(
      must = list(
        match = list(
          "assuntos.codigo" = codigo_assunto
        )
      )
    )
  ),
  size = 10000,
  sort = list(
    list(
      "@timestamp" = list(
        order = "asc"
      )
    )
  )
)


res <- httr::POST(
  links[19],
  body = body,
  headers,
  encode = "json"
)

res
dados_resultantes <- httr::content(res, "parsed", simplifyDataFrame = TRUE) |>
  purrr::pluck("hits", "hits")

dados_resultantes |>
  str()

dados_resultantes[["_source"]] |>
  tibble::tibble()

dplyr::glimpse(dados_resultantes)


# RVEST
## remotes::install_github("tidyverse/rvest")

library(rvest)
sess <- read_html_live(
  "https://www.google.com/search?q=ibovespa"
)
sess$view()

sess$html_elements(xpath=".//a")
