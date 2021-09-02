library(tidyverse)
library(bigrquery)
library(tidymodels)
library(modeltime)

remotes::install_

conexao_covid <- dbConnect(
  bigrquery::bigquery(),
  project = "basedosdados",
  dataset = "br_ms_vacinacao_covid19",
  billing = "live-curso-r-bd"
)

vacinacao_base <- tbl(conexao_covid, "microdados_vacinacao") %>%
  filter(sigla_uf == "SP") %>%
  count(sigla_uf, data_aplicacao, dose) %>%
  collect() %>%
  mutate(
    data_aplicacao = as.Date(data_aplicacao)
  )

segunda_dose <- vacinacao_base %>%
  filter(dose == "2a Dose",
         data_aplicacao > as.Date("2021-03-01")) %>%
  arrange(data_aplicacao)

splits <- initial_time_split(segunda_dose, prop = .8)

model_spec <- arima_reg() %>%
  set_engine("auto_arima")

model_fit <- model_spec %>%
  fit(log(n) ~ data_aplicacao, data = training(splits))

testing(splits) %>%
  add_column(
    n_predito = exp(predict(model_fit, new_data = testing(splits))$.pred)) %>%
  pivot_longer(c(n, n_predito), names_to = "tipo", values_to = "valor") %>%
  bind_rows(training(splits) %>% mutate(tipo = "n", valor = n)) %>%
  ggplot(aes(x = data_aplicacao, y = valor, color = tipo)) +
  geom_line()

