#' Author:
#' Subject: base dos dados

# install.packages("basedosdados")
library(basedosdados)

# Geral -------------------------------------------------------------------

# O pacote só tem 4 funções exportadas

basedosdados::download
basedosdados::read_sql
basedosdados::get_billing_id
basedosdados::set_billing_id

?basedosdados::download

# Import -----------------------------------------------------------------------

# Vamos tentar do jeito que parece mais fácil, com a função "download"

# Esse código não funciona:

dir <- tempdir()

query <- "SELECT
pib.id_municipio,
pop.ano,
pib.PIB / pop.populacao * 1000 as pib_per_capita
FROM `basedosdados.br_ibge_pib.municipios` as pib
JOIN `basedosdados.br_ibge_populacao.municipios` as pop
ON pib.id_municipio = pop.id_municipio
LIMIT 5 "

data <- download(query, file.path(dir, "pib_per_capita.csv"))

?set_billing_id

# A gente precisa configurar o billing_id

# Entra lá no https://console.cloud.google.com/

basedosdados::set_billing_id("live-curso-r-bd-2")

# Agora vai

dir <- tempdir()

query <- "SELECT
pib.id_municipio,
pop.ano,
pib.PIB / pop.populacao * 1000 as pib_per_capita
FROM `basedosdados.br_ibge_pib.municipios` as pib
JOIN `basedosdados.br_ibge_populacao.municipios` as pop
ON pib.id_municipio = pop.id_municipio
LIMIT 20 "

data <- download(query, file.path(dir, "pib_per_capita.csv"))

pib_per_capita <- readr::read_csv(file.path(dir, "pib_per_capita.csv"))

# usando o read_sql seria sussa tb:

pib_per_capita_2 <- read_sql(query)

# ele consumiu 0 bytes dessa vez que a gente rodou a query!!!
# isso acontece pq o bigquery tem um sistema de cache por 24h, quase sempre
# https://cloud.google.com/bigquery/docs/cached-results#cache-exceptions

# Como eu posso ver tudo que dá pra baixar no base_dos_dados?
# https://basedosdados.org/dataset/

query <- "SELECT * FROM `basedosdados.br_ibge_censo_demografico.setor_censitario_basico_2010`"

df <- read_sql(query)

# Fazendo uma conexão diretona e se aproveitar de DBI+dbplyr etc

library(bigrquery)

con <- dbConnect(
  bigrquery::bigquery(),
  project = "basedosdados",
  dataset = "br_ibge_censo_demografico",
  billing = "live-curso-r-bd-2"
)

DBI::dbListTables(con)

library(tidyverse)
library(bit64)

basico <- tbl(con, "setor_censitario_basico_2010")

dplyr::glimpse(basico)

tbl(con, "setor_censitario_idade_total_2010") %>%
  left_join(basico) %>%
  mutate(id_setor_censitario = as.character(id_setor_censitario)) %>%
  #mutate(id_setor_censitario = as.numeric(id_setor_censitario)) %>%
  select(id_setor_censitario) %>%
  head(50) %>%
  collect()

# Vamos brincar com os dados do INEP

conexao_ideb <- dbConnect(
  bigrquery::bigquery(),
  project = "basedosdados",
  dataset = "br_inep_ideb",
  billing = "live-curso-r-bd-2"
)

# Tidy -------------------------------------------------------------------------

escola <- tbl(conexao_ideb, "escola") %>%
  group_by(ano, estado_abrev, municipio) %>%
  summarise(ideb = mean(ideb, na.rm = TRUE)) %>%
  ungroup() %>%
  collect()

# Visualize --------------------------------------------------------------------

library(tidytext)

escola %>%
  mutate(
    municipio = reorder_within(municipio, ideb, estado_abrev)
  ) %>%
  mutate(
    municipio2 = as.numeric(municipio)
  ) %>%
  ggplot(aes(x = municipio2, y = ideb, fill = estado_abrev)) +
  geom_col() +
  coord_flip() +
  scale_x_reordered() +
  facet_wrap(~estado_abrev, nrow = 6, scales = 'free_y')

escola %>%
  #mutate(
  #  estado_abrev = reorder_within(estado_abrev, ideb, ano, fun = median)
  #) %>%
  filter(ano %in% c("2013", "2015", "2017")) %>%
  mutate(ano = as_factor(ano)) %>%
  ggplot(aes(x = ideb, y = ano, fill = estado_abrev)) +
  ggridges::geom_density_ridges(color = 'transparent', alpha = .6) +
  scale_fill_viridis_d() +
  theme_minimal() +
  labs(
    x = "IDEB",
    y = "Estado"
  ) +
  theme(
    legend.position = 'none') +
  facet_wrap(~estado_abrev, nrow = 5) +
  geom_vline(xintercept = 4)

# Export -----------------------------------------------------------------------

readr::write_rds(escola, "analise.rds")


# Análise final -----------------------------------------------------------

query <- "SELECT
pib.id_municipio,
pop.ano,
pib.PIB / pop.populacao * 1000 as pib_per_capita
FROM `basedosdados.br_ibge_pib.municipios` as pib
JOIN `basedosdados.br_ibge_populacao.municipios` as pop
ON pib.id_municipio = pop.id_municipio
LIMIT 20 "

conexao_ideb <- dbConnect(
  bigrquery::bigquery(),
  project = "basedosdados",
  dataset = "br_ibge_pib",
  billing = "live-curso-r-bd-2"
)

conexao_ideb2 <- dbConnect(
  bigrquery::bigquery(),
  project = "basedosdados",
  dataset = "br_ibge_populacao",
  billing = "live-curso-r-bd-2"
)

d1 <- tbl(conexao_ideb, "municipios") %>%
  select(everything()) %>%
  collect()

d2 <- tbl(conexao_ideb2, "municipios") %>%
  select(everything()) %>%
  collect()

d1 %>%
  inner_join(d2)
