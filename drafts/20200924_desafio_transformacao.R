#' Author:
#' Subject:

# library(tidyverse)
library(magrittr)

# Import -----------------------------------------------------------------------

# Tidy -------------------------------------------------------------------------

diamonds %>%
  mutate(across(where(is.factor), as.character)) %>%
  filter(price > 2000) %>%
  group_by(cut, clarity) %>%
  summarise(media = mean(carat)) %>%
  pivot_wider(names_from = cut, values_from = media) %>%
  arrange(desc(Ideal)) %>%
  knitr::kable()

diamonds %>%
  mutate(across(where(is.factor), as.character)) %>%
  feather::write_feather("data-raw/diamonds.feather")

sabesp <- feather::read_feather("data-raw/sabesp.feather")


glimpse(sabesp)

sabesp %>%
  mutate(
    dia = as.Date(dia),
    mes = lubridate::floor_date(dia, "month"),
    mes = format(mes, "%B"),
    prec_hist = parse_number(prec_hist, locale = locale(decimal_mark = ","))
  ) %>%
  group_by(mes, nome) %>%
  summarise(
    n = n(),
    media = mean(prec_hist),
    .groups = "drop"
  ) %>%
  arrange(desc(mes)) %>%
  knitr::kable()

contratos_covid <- feather::read_feather("data-raw/contratos_covid.feather")

contratos_covid %>%
  filter(valor_total_contrato != "Zero") %>%
  mutate(valor_total_contrato = parse_number(
    valor_total_contrato, locale = locale(decimal_mark = ",", grouping_mark = ".")),
    prazo_180_dias = lubridate::dmy(prazo_180_dias),
    prazo_180_dias = lubridate::floor_date(prazo_180_dias, "month"),
    mes = format(prazo_180_dias, "%B")
  ) %>%
  group_by(mes) %>%
  summarise(
    n = n(),
    soma = scales::dollar(sum(valor_total_contrato),
                          accuracy = 0.01,
                          prefix = "R$", big.mark = ".",
                          decimal.mark = ","),
    .groups = "drop"
  ) %>%
  slice(c(1, 4, 3, 2)) %>%
  knitr::kable()


varas_min <- abjData::dados_aj %>%
  select(cod, tipo, nome_vara, municipio_uf, lat, long)

feather::write_feather(varas_min, "data-raw/varas.feather")
varas <- feather::read_feather("data-raw/varas.feather")

idhm <- abjData::pnud_muni %>%
  filter(ano == "2010") %>%
  select(ufn, municipio, codmun6, idhm, popt)

readr::write_csv(idhm, "data-raw/idhm.csv")
feather::write_feather(idhm, "data-raw/idhm.feather")
idhm_pa <- idhm %>%
  filter(ufn == "Rio Grande do Sul") %>%
  mutate(municipio = abjutils::rm_accent(municipio))

varas %>%
  filter(uf == "RS") %>%
  mutate(
    municipio = abjutils::rm_accent(municipio),
    municipio = toupper(municipio),
    municipio = case_when(
      municipio == "SANTANA DO LIVRAMENTO" ~ "SANT'ANA DO LIVRAMENTO",
      TRUE ~ municipio
    )
  ) %>%
  inner_join(idhm_pa, c("municipio")) %>%
  group_by(municipio, codmun6) %>%
  summarise(n = n(), idhm = first(idhm)) %>%
  arrange(desc(n)) %>%
  head(10) %>%
  knitr::kable()


# Visualize --------------------------------------------------------------------

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
