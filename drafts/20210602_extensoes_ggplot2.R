# Extensões de ggplo2 -----------------------------------------------------

# O que é uma extensão de ggplot2?

# um pacote que não está nos imports do ggplot2 e que realça o funcionamento
# dele

# scales, grid, gtable, glue são pacotes legais para usar junto ao ggplot2,
# mas são imports do pacote


# conexões---- ----------------------------------------------------------------

library(tidyverse)
library(bigrquery)

conexao_ideb <- dbConnect(
  bigrquery::bigquery(),
  project = "basedosdados",
  dataset = "br_inep_ideb",
  billing = "live-curso-r-bd-2"
)

conexao_covid <- dbConnect(
  bigrquery::bigquery(),
  project = "basedosdados",
  dataset = "br_ms_vacinacao_covid19",
  billing = "live-curso-r-bd-2"
)

conexao_populacao <- dbConnect(
  bigrquery::bigquery(),
  project = "basedosdados",
  dataset = "br_ibge_populacao",
  billing = "live-curso-r-bd-2"
)

# ggridges -----------------------------------------------------------------

escola <- tbl(conexao_ideb, "escola") %>%
  group_by(ano, estado_abrev, municipio) %>%
  summarise(ideb = mean(ideb, na.rm = TRUE)) %>%
  ungroup() %>%
  collect()

escola %>%
  mutate(
    estado_abrev = fct_reorder(estado_abrev, ideb, .fun = median, na.rm = TRUE)
  ) %>%
  #filter(ano %in% c("2005", "2019")) %>%
  #mutate(ano = as_factor(ano)) %>%
  ggplot(aes(x = ideb, y = estado_abrev, fill = estado_abrev)) +
  ggridges::geom_density_ridges(color = 'transparent', alpha = .6) +
  scale_fill_viridis_d() +
  theme_minimal() +
  labs(
    x = "IDEB",
    y = "Estado"
  ) +
  theme(
    legend.position = 'none') +
  geom_vline(xintercept = 4)


# gganimate ---------------------------------------------------------------

vacinacao_base <- tbl(conexao_covid, "microdados_vacinacao") %>%
  count(sigla_uf, data_aplicacao, dose) %>%
  collect() %>%
  mutate(
    data_aplicacao = as.Date(data_aplicacao)
  )

populacao_estados <- tbl(conexao_populacao, "municipios") %>%
  filter(ano == 2020) %>%
  collect() %>%
  mutate(
    id_estado = str_sub(id_municipio, 1, 2),
    sigla_uf = case_when(
      id_estado == "12" ~ "AC",
      id_estado == "27" ~ "AL",
      id_estado == "16" ~ "AP",
      id_estado == "13" ~ "AM",
      id_estado == "29" ~ "BA",
      id_estado == "53" ~ "DF",
      id_estado == "23" ~ "CE",
      id_estado == "32" ~ "ES",
      id_estado == "52" ~ "GO",
      id_estado == "21" ~ "MA",
      id_estado == "51" ~ "MT",
      id_estado == "50" ~ "MS",
      id_estado == "31" ~ "MG",
      id_estado == "15" ~ "PA",
      id_estado == "25" ~ "PB",
      id_estado == "41" ~ "PR",
      id_estado == "26" ~ "PE",
      id_estado == "22" ~ "PI",
      id_estado == "33" ~ "RJ",
      id_estado == "24" ~ "RN",
      id_estado == "43" ~ "RS",
      id_estado == "11" ~ "RO",
      id_estado == "14" ~ "RR",
      id_estado == "42" ~ "SC",
      id_estado == "35" ~ "SP",
      id_estado == "28" ~ "SE",
      id_estado == "17" ~ "TO"
    )
  ) %>%
  group_by(sigla_uf) %>%
  summarise(
    populacao = sum(populacao)
  )

populacao_regiao <- vacinacao_base_2 %>%
  group_by(regiao) %>%
  summarise(
    populacao = sum(unique(populacao))
  )

vacinacao_base_2 <- vacinacao_base %>%
  ungroup() %>%
  mutate(
    regiao = case_when(
      sigla_uf %in% c("SP", "RJ", "MG", "ES") ~ "Sudeste",
      sigla_uf %in% c("SC", "PR", "RS") ~ "Sul",
      sigla_uf %in% c("MT", "DF", "GO", "MS") ~ "Centro-Oeste",
      sigla_uf %in% c("AC", "AM", "RO", "RR", "PA", "AP", "TO") ~ "Norte",
      TRUE ~ "Nordeste"
    )
  ) %>%
  filter(dose == "2") %>%
  group_by(regiao, sigla_uf) %>%
  arrange(regiao, sigla_uf, data_aplicacao) %>%
  mutate(
    n_acum = cumsum(n),
  ) %>%
  filter(data_aplicacao >= as.Date("2021-01-01")) %>%
  left_join(
    populacao_estados
  ) %>%
  mutate(
    percentual_vacinado = n_acum/populacao
  )

vacinacao_base_por_regiao <-  vacinacao_base %>%
  ungroup() %>%
  mutate(
    regiao = case_when(
      sigla_uf %in% c("SP", "RJ", "MG", "ES") ~ "Sudeste",
      sigla_uf %in% c("SC", "PR", "RS") ~ "Sul",
      sigla_uf %in% c("MT", "DF", "GO", "MS") ~ "Centro-Oeste",
      sigla_uf %in% c("AC", "AM", "RO", "RR", "PA", "AP", "TO") ~ "Norte",
      TRUE ~ "Nordeste"
    )
  ) %>%
  filter(dose == "2") %>%
  group_by(regiao, data_aplicacao) %>%
  summarise(
    n = sum(n)
  ) %>%
  group_by(regiao) %>%
  arrange(regiao, data_aplicacao) %>%
  mutate(
    n_acum = cumsum(n),
  ) %>%
  filter(data_aplicacao >= as.Date("2021-02-01")) %>%
  left_join(
    populacao_regiao
  ) %>%
  mutate(
    percentual_vacinado = n_acum/populacao
  )

library(gganimate)

grafico_por_estado <- vacinacao_base_2 %>%
  ungroup() %>%
  arrange(data_aplicacao) %>%
  #mutate(data_aplicacao = as.numeric(data_aplicacao)) %>%
  ggplot(aes(x = data_aplicacao, y = percentual_vacinado, color = sigla_uf)) +
  geom_line() +
  transition_reveal(data_aplicacao) +
  facet_wrap(~regiao) +
  scale_color_viridis_d() +
  theme_bw()

grafico_por_regiao <- vacinacao_base_por_regiao %>%
  ungroup() %>%
  arrange(data_aplicacao) %>%
  #mutate(data_aplicacao = as.numeric(data_aplicacao)) %>%
  ggplot(aes(x = data_aplicacao, y = percentual_vacinado, color = regiao)) +
  #geom_col() +
  geom_line(size = 1.2) +
  #geom_point() +
  transition_reveal(data_aplicacao) +
  scale_color_viridis_d() +
  theme_bw()

# https://ugoproto.github.io/ugo_r_doc/pdf/gganimate.pdf

animate(grafico_por_regiao, height = 600, width =800)

anim_save("animacao.gif", animation = grafico)

