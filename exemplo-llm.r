# curl https://api.openai.com/v1/chat/completions \
#   -H "Content-Type: application/json" \
#   -H "Authorization: Bearer $OPENAI_API_KEY" \
#   -d '{
#   "model": "gpt-4o",
#   "messages": [],
#   "temperature": 0,
#   "max_tokens": 1861,
#   "top_p": 1,
#   "frequency_penalty": 0,
#   "presence_penalty": 0
# }'

tjsp::baixar_cjpg(
  assunto = 3608,
  diretorio = "live_llm",
  paginas = 1:20
)

dados_processos <- fs::dir_ls("live_llm") |>
  tjsp::tjsp_ler_cjpg()

View(dados_processos)



analise_gpt <- function(txt) {

  u_openai <- "https://api.openai.com/v1/chat/completions"

  messages <- list(
    list(
      role = "system",
      content = readr::read_file("prompt_drogas.md")
    ),
    list(
      role = "user",
      content = txt
    )
  )

  body <- list(
    model = "gpt-4o",
    messages = messages,
    temperature = 0,
    response_format = list("type" = "json_object")
  )

  # usethis::edit_r_environ()
  api_key <- Sys.getenv("OPENAI_API_KEY")

  headers <- httr::add_headers(
    "Authorization" = paste("Bearer", api_key)
  )

  res <- httr::POST(
    u_openai,
    body = body,
    headers,
    encode = "json"
  )

  res |>
    httr::content() |>
    purrr::pluck("choices", 1, "message", "content") |>
    jsonlite::fromJSON(simplifyDataFrame = TRUE) |>
    tibble::as_tibble()

}

dim(dados_processos)

set.seed(42)

dados_processos_amostra <- dados_processos |>
  dplyr::distinct(processo, .keep_all = TRUE) |>
  dplyr::slice_sample(n = 30)

safe_analise_gpt <- purrr::possibly(
  analise_gpt, tibble::tibble(erro = "erro")
)

resultado <- purrr::map(
  dados_processos_amostra$julgado |>
    purrr::set_names(dados_processos_amostra$processo),
  safe_analise_gpt,
  .progress = TRUE
)

base_final <- resultado |>
  purrr::map(\(x) {
    if (!is.null(x$outras_drogas)) {
      x |>
        tidyr::unnest(outras_drogas) |>
       dplyr::mutate(dplyr::across(dplyr::everything(), as.character))
    }
  }) |>
  purrr::list_rbind(names_to = "processo")

View(base_final)

base_tidy <- base_final |>
  dplyr::select(processo, dplyr::ends_with("em_g"), decisao, pena) |>
  tidyr::pivot_longer(dplyr::ends_with("em_g")) |>
  dplyr::filter(
    !value %in% "não especificado"
  ) |>
  dplyr::mutate(
    tipo_droga = stringr::str_extract(name, "[a-z]+"),
    value = readr::parse_number(value),
    pena = readr::parse_number(pena),
  )

base_tidy |>
  dplyr::filter(value < 4000) |>
  ggplot2::ggplot(ggplot2::aes(x = value, y = pena)) +
  ggplot2::geom_point()
