#' Author:
#' Subject: Site do flamengo

# install.packages("basedosdados")
library(basedosdados)


# Geral -------------------------------------------------------------------

# O pacote só tem 4 funções exportadas

basedosdados::download
basedosdados::get_billing_id
basedosdados::read_sql
basedosdados::set_billing_id

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

# A gente precisa configurar o billing_id

# Entra lá no https://console.cloud.google.com/

basedosdados::set_billing_id("live-curso-r-bd")

# Agora vai

dir <- tempdir()

query <- "SELECT
pib.id_municipio,
pop.ano,
pib.PIB / pop.populacao * 1000 as pib_per_capita
FROM `basedosdados.br_ibge_pib.municipios` as pib
JOIN `basedosdados.br_ibge_populacao.municipios` as pop
ON pib.id_municipio = pop.id_municipio
LIMIT 10 "

data <- download(query, file.path(dir, "pib_per_capita.csv"))

pib_per_capita <- readr::read_csv(file.path(dir, "pib_per_capita.csv"))

# usando o read_sql seria sussa tb:

pib_per_capita_2 <- read_sql(query)
# ele consumiu 0 bytes dessa vez que a gente rodou a query!!!
# isso acontece pq o bigquery tem um sistema de cache por 24h, quase sempre
# https://cloud.google.com/bigquery/docs/cached-results#cache-exceptions

# Como eu posso ver tudo que dá pra baixar no base_dos_dados?
# https://basedosdados.org/dataset/br-ibge-censo-demografico

query <- "SELECT * FROM `basedosdados.br_ibge_censo_demografico.setor_censitario_basico_2010`"
df <- read_sql(query)

# Fazendo uma conexão diretona e se aproveitar de DBI+dbplyr etc

library(bigrquery)

con <- dbConnect(
  bigrquery::bigquery(),
  project = "basedosdados",
  dataset = "br_ibge_censo_demografico",
  billing = "live-curso-r-bd"
)

DBI::dbListTables(con)

library(tidyverse)

tabelona <- tbl(con, "setor_censitario_idade_homens_2010") %>%
  mutate(id_setor_censitario = as.character(id_setor_censitario)) %>%
  select(id_setor_censitario, sigla_uf) %>%
  head(50) %>%
  collect()

# Vamos brincar com os dados do INEP

conexao <- dbConnect(
  bigrquery::bigquery(),
  project = "basedosdados",
  dataset = "br_inep_ideb",
  billing = "live-curso-r-bd"
)

# Tidy -------------------------------------------------------------------------



escola <- tbl(conexao, "escola") %>%
  group_by(estado, municipio) %>%
  summarise(ideb = mean(ideb)) %>%
  collect()

# Visualize --------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
