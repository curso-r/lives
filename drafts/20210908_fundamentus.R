
# Entra no site e lista ações ---------------------------------------------

library(rvest)
library(tidyverse)
library(httr)

cabecalho_que_finge_que_e_browser <- add_headers(
  `User-Agent` = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36'
)

sessao <- session("https://fundamentus.com.br/detalhes.php",
                  add_headers(
                    `User-Agent` = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36'
                  ))

# PLANO B
# tentativa_get <- GET(
#   "https://fundamentus.com.br/detalhes.php?&interface=classic",
#     add_headers(
#       `User-Agent` = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36'
#     )
#   )

tabela_de_papel <- sessao %>%
  html_table() %>%
  first()

vetor_de_papeis <- tabela_de_papel$Papel

# Baixa as tabelas de um único papel --------------------------------------

arrumar_tabela <- function(tabela){

  n_pares <- ncol(tabela)/2

  nomes <- tabela[,seq(1, n_pares*2-1, 2)] %>%
    unlist()

  valores <- tabela[,seq(2, n_pares*2, 2)] %>%
    unlist()

  tibble(nomes = nomes, valores = valores)

}

baixa_tabela_de_um_papel <- function(papel){

  message(papel)

  url_de_um_papel <- str_glue(
    'https://fundamentus.com.br/detalhes.php?papel={papel}')

  sessao_de_um_papel <- session(url_de_um_papel,
                              cabecalho_que_finge_que_e_browser)

  lista_de_tabelas <- sessao_de_um_papel %>%
    html_table()

  tabelao_de_nomes_e_valores <- lista_de_tabelas %>%
    purrr::map_dfr(arrumar_tabela)

  tabelao_de_nomes_e_valores %>%
    filter(nomes != valores) %>%
    mutate(
      nomes = janitor::make_clean_names(nomes) %>%
        str_replace_all("^x", "oscilacoes_"),
      nomes = case_when(
      str_detect(nomes, "receita_liquida$|ebit$|lucro_liquido$") ~ paste0(nomes, "_12_meses"),
      str_detect(nomes, "receita_liquida_2$|ebit_2$|lucro_liquido_2$") ~ paste0(str_remove(nomes, "_2$"), "_3_meses"),
      TRUE ~ nomes
    )) %>%
    mutate(id = papel)

  #%>%
    #pivot_wider(names_from = 'nomes', values_from = 'valores')
}

# Itera em todos os papeis ------------------------------------------------

library(furrr)

tabela_de_papeis <- tibble(papel = vetor_de_papeis) %>%
  sample_frac(size = .1) %>%
  with(papel) %>%
  purrr::map_dfr(baixa_tabela_de_um_papel) %>%
  pivot_wider(id_cols = 'id', names_from = 'nomes', values_from = 'valores')

plan(multisession)

tabela_de_papeis <- tibble(papel = vetor_de_papeis) %>%
  #sample_frac(size = ) %>%
  with(papel) %>%
  furrr::future_map_dfr(baixa_tabela_de_um_papel) %>%
  pivot_wider(id_cols = 'id', names_from = 'nomes', values_from = 'valores')

# Arrumacao final ---------------------------------------------------------

final <- tabela_de_papeis %>%
  mutate(
    across(c("ult_balanco_processado", "data_ult_cot"),
    lubridate::dmy)
  ) %>%
  #filter(year(ult_balanco_processado) < 2021 & year(data_ult_cot) == 2021)
  #filter(data_ult_cot > as.Date("2002-01-01")) %>%
  #filter(data_ult_cot < as.Date("2019-01-01")) %>%
  ggplot(aes(x = data_ult_cot)) +
  geom_histogram()

final <- tabela_de_papeis %>%
  mutate(
    across(c("ult_balanco_processado", "data_ult_cot"),
           lubridate::dmy)
  ) %>%
  mutate(
    across(c("p_l", "oscilacoes_12_meses"),
           readr::parse_number, locale = locale(decimal_mark = ",", grouping_mark = "."))
  ) %>%
  mutate(
    oscilacoes_12_meses = oscilacoes_12_meses/100
  )

# final %>%
#   filter(ult_balanco_processado >= as.Date("2021-06-01")) %>%
#   filter(p_l < 30000) %>%
#   ggplot(aes(x = p_l, y = oscilacoes_12_meses)) +
#   geom_point() +
#   scale_x_continuous(trans = 'log1p')

saveRDS(final, "final_fundamentus.rds")
