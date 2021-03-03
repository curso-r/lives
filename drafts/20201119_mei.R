#' Author:
#' Subject:

library(magrittr)
url_home <- "http://www22.receita.fazenda.gov.br/inscricaomei/private/pages/relatorios/opcoesRelatorio.jsf"
res_home <- httr::GET(url_home)
view_state <- . %>%
  xml2::read_html() %>%
  xml2::xml_find_first("//input[@id='javax.faces.ViewState']") %>%
  xml2::xml_attr("value")
bod_mes <- list(
  "form" = "form",
  "autoScroll" = "",
  "javax.faces.ViewState" = view_state(res_home),
  "form:j_id14:0:j_id16" = "form:j_id14:0:j_id16",
  "tipoRelatorio" = 13
)
res_mes <- httr::POST(url_home, body = bod_mes, encode = "form")
view_state_mes <- view_state(res_mes)
ano_mes <- res_mes %>%
  xml2::read_html() %>%
  xml2::xml_find_all("//select") %>%
  purrr::map(xml2::xml_find_all, "./option") %>%
  purrr::map(xml2::xml_attr, "value") %>%
  purrr::map(utils::tail, -1) %>%
  purrr::set_names("ano", "mes") %>%
  purrr::cross_df()
bod_inscritos <- function(ano, mes, view_state) {
  list(
    "form:relatorioMB_relatorio_ano" = ano,
    "form:relatorioMB_relatorio_mes" = mes,
    "form:botaoConsultar" = "Consultar",
    "form" = "form",
    "autoScroll" = "",
    "javax.faces.ViewState" = view_state
  )
}
get_inscritos <- function(ano, mes, view_state,
                          path = "~/Downloads/mei") {
  fs::dir_create(path)
  url_inscritos <- "http://www22.receita.fazenda.gov.br/inscricaomei/private/pages/relatorios/relatorioMesDia.jsf"
  httr::POST(
    url_inscritos,
    body = bod_inscritos(ano, mes, view_state),
    httr::write_disk(paste0(path, "/", ano, mes, ".html"), TRUE)
  )
}
library(future)
plan(sequential)
furrr::future_walk2(
  ano_mes$ano,
  ano_mes$mes,
  purrr::possibly(get_inscritos, NULL),
  view_state_mes,
  .progress = TRUE
)
parse_inscritos <- function(file) {
  ano <- as.numeric(stringr::str_extract(file, "[0-9]{4}"))
  mes <- as.numeric(stringr::str_extract(file, "(?<=[0-9]{4})[0-9]+"))
  file %>%
    xml2::read_html() %>%
    xml2::xml_find_all("//table") %>%
    rvest::html_table() %>%
    purrr::pluck(1) %>%
    dplyr::as_tibble() %>%
    janitor::clean_names() %>%
    dplyr::mutate(
      ano = ano,
      mes = mes,
      total_optantes = total_optantes %>%
        stringr::str_remove_all("\\.") %>%
        base::as.numeric()
    ) %>%
    dplyr::relocate(ano, mes)
}
df_inscritos <- "~/Downloads/mei/" %>%
  fs::dir_ls() %>%
  purrr::map_dfr(purrr::possibly(parse_inscritos, dplyr::tibble()))
