#' Author: FeWi
#' Subject: ggplot2 do wilson

# library(tidyverse)
library(magrittr)
library(ggplot2)
#library(rbmfbovespa)
# library(rb3)

devtools::install_github('wilsonfreitas/transmute')
devtools::install_github('wilsonfreitas/rb3')
devtools::install_github("")

library(dplyr)
library(tidyr)
library(xts)

# Import -----------------------------------------------------------------------

# Primeira tentativa não conseguimos pegar os dados

# ch_2016 <- read_marketdata('datasets/COTAHIST_A2016.TXT', 'COTAHIST')
# etfs <- ch_2016[[2]] %>% filter(especificacao == 'CI',
#                                 tipo_mercado == 10,
#                                 stringr::str_detect(nome_empresa,
#                                                     "^(BB ETF|CAIXAETF|ISHARE|IT NOW)"))

poluicao <- basesCursoR::pegar_base("cetesb")

# Tidy -------------------------------------------------------------------------

poluicao_tidy <- poluicao %>%
  filter(poluente == "CO",
         lubridate::year(data) == "2018") %>%
  group_by(estacao_cetesb, data) %>%
  summarise(
    concentracao = mean(concentracao, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  mutate(
    semana = lubridate::week(data),
    dia_da_semana = forcats::fct_rev(lubridate::wday(data, label = TRUE)),
    mes = lubridate::month(data, label = TRUE)
  ) %>%
  group_by(dia_da_semana, mes, estacao_cetesb) %>%
  mutate(id_semana = 1:n()) %>%
  ungroup()



poluicao_tidy %>%
  dplyr::group_by(mes, estacao_cetesb) %>%
  dplyr::mutate(semana = dplyr::case_when(

  ))


poluicao_tidy %>%
  dplyr::group_by(dia_da_semana, mes, estacao_cetesb) %>%
  dplyr::mutate(id_semana = 1:n()) %>%
  ungroup()


# Visualize --------------------------------------------------------------------

poluicao_tidy %>%
  #filter(estacao_cetesb %in% c("Pinheiros", "Parque D.Pedro II")) %>%
  ggplot(aes(x = id_semana, y = dia_da_semana, fill = concentracao)) +
  geom_tile() +
  facet_grid(estacao_cetesb~mes, scales = 'free_x') +
  theme_minimal() +
  scale_fill_gradient(low = "white", high = "black")





# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
