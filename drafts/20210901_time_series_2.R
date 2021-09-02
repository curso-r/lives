
# Pacotes -----------------------------------------------------------------

remotes::install_github("abjur/falrec")
remotes::install_github("beatrizmilz/mananciais")

library(tidyverse)
library(falrec)
library(modeltime)
library(timetk)
library(mananciais)


# Carregando bases --------------------------------------------------------

# Carregando base vacinação -----------------------------------------------

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

primeira_dose <- vacinacao_base %>%
  filter(dose == "1a Dose")

segunda_dose <- vacinacao_base %>%
  filter(dose == "2a Dose")

# Carregando base de recuperações -----------------------------------------

recuperacoes <- falrec::falrec %>%
  dplyr::filter(
    tamanho == "total",
    tipo == "rec",
    evento == "req",
    data >= as.Date("2006-01-01")
  )


# Carregando base mananciais ----------------------------------------------

mananciais_guarapiranga <- mananciais %>%
  filter(sistema == "Guarapiranga")

# Analises descritivas ----------------------------------------------------


# Analise descritiva recuperacoes -----------------------------------------

recuperacoes %>%
  plot_time_series(.date_var = data,
                   .value = n)

recuperacoes %>%
  plot_seasonal_diagnostics(.date_var = data,
                            .value = n)

# Analise descritiva mananciais -------------------------------------------

mananciais_guarapiranga %>%
  select(data, volume_operacional, pluviometria_dia) %>%
  pivot_longer(c(volume_operacional,
                 pluviometria_dia),
               names_to = "tipo",
               values_to = "valor") %>%
  plot_time_series(.date_var = data,
                   .value = valor,
                   .facet_vars = tipo)

mananciais_guarapiranga %>%
  plot_seasonal_diagnostics(
    .date_var = data,
    .value = volume_operacional,
    .feature_set = c("week", "quarter", "year",
                     "month.lbl")
  )

# Analise descritiva vacina -----------------------------------------------

primeira_dose %>%
  ungroup() %>%
  plot_time_series(
    .date_var = data_aplicacao,
    .value = n,
  )

segunda_dose %>%
  ungroup() %>%
  #filter(data_aplicacao < as.Date("2021-08-01")) %>%
  plot_seasonal_diagnostics(
    .date_var = data_aplicacao,
    .value = n,
    .feature_set = c("week", "wday.lbl")
  )

# Modelagem ---------------------------------------------------------------


# split -------------------------------------------------------------------

split_inicial <- initial_time_split(
  recuperacoes,
  prop = .8)

split <- time_series_cv(
  recuperacoes,
  #mutate(recuperacoes, n = log(n)),
  cumulative = TRUE, initial = 90, skip = 20, assess = 30)

split %>%
  tk_time_series_cv_plan() %>%
  plot_time_series_cv_plan(.date_var = data,
                           .value = n)

# Ajuste prophet ----------------------------------------------------------

espec_prophet <- prophet_reg(
    changepoint_num = tune::tune(),
    growth = tune::tune(),
    logistic_floor = 30
) %>%
  set_engine(engine = "prophet")

receita_prophet <- recipe(n ~ data, data = recuperacoes)

workflow_prophet <- workflow() %>%
  add_recipe(receita_prophet) %>%
  add_model(espec_prophet)

profeta_malhando <- workflow_prophet %>%
  tune_grid(split,
            grid = expand.grid(
              growth = c("linear", "logistic"),
              changepoint_num = seq(5, 15, by = 10)))

autoplot(profeta_malhando)

melhor_modelo <- profeta_malhando %>%
  select_best()

modelo_profeta <- workflow_prophet %>%
  finalize_workflow(melhor_modelo) %>%
  fit(training(split_inicial))

# Ajuste arima ------------------------------------------------------------

espec_arima <- arima_reg() %>%
  set_engine(engine = "auto_arima")

modelo_arima <- espec_arima %>%
  fit(n ~ data, data = training(split))

# Ajuste ETS --------------------------------------------------------------

espec_ets <- exp_smoothing() %>%
  set_engine(engine = "ets")

modelo_ets <- espec_ets %>%
  fit(n ~ data, data = training(split))

# Cria modeltime_table ----------------------------------------------------

tabelas <- modeltime_table(
  modelo_profeta,
  modelo_arima,
  modelo_ets
)

tabelas_calibradas <- tabelas %>%
  modeltime_calibrate(quiet = FALSE,
    new_data = testing(split)
  )

tabelas_calibradas %>%
  modeltime_accuracy() %>%
  table_modeltime_accuracy(
    .interactive = FALSE)

tabelas_calibradas %>%
  modeltime_forecast(new_data = testing(split),
                     actual_data = training(split)) %>%
  plot_modeltime_forecast()

