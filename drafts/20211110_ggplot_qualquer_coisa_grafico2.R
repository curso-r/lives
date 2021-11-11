#' Author: FeJu
#' Subject: Gráfico do Storytelling with data

library(tidyverse)
library(magrittr)

# Import -----------------------------------------------------------------------

url0 <- "https://raw.githubusercontent.com/adamribaudo/storytelling-with-data-ggplot/master/data/FIG0921-26.csv"

da_raw <- read_csv(url0)

# Tidy -------------------------------------------------------------------------

# queremos chegar em uma tabela que tem as seguintes colunas
# categoria, ano,

da_tidy <- da_raw %>%
  pivot_longer(
    -Category,
    names_to = "ano",
    values_to = "perc_funders") %>%
  janitor::clean_names() %>%
  mutate(
    ano = as.integer(ano),
    perc_funders = readr::parse_number(perc_funders)/100
  )

funcao_para_iterar <- function(tipo_painel, dados = da_tidy){
  da_tidy %>%
    mutate(
      realce = if_else(category == tipo_painel, 1, 0),
      painel = tipo_painel
    )
}
#
# realce_health <- da_tidy %>%
#   mutate(
#     realce = if_else(category == "Health", 1, 0),
#     painel = "Health"
#   )
#
# realce_education <- da_tidy %>%
#   mutate(
#     realce = if_else(category == "Education", 1, 0),
#     painel = "Education"
#   )

# Visualize --------------------------------------------------------------------

da_visualizar <- purrr::map_dfr(unique(da_tidy$category),
                                funcao_para_iterar)

da_visualizar %>%
  mutate(
    realce = factor(realce)
  ) %>%
  ggplot(aes(x = ano, y = perc_funders, group = category,
             color = realce)) +
  geom_line(size = 1.3) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    axis.text.y = element_blank()
  ) +
  # sugestão do BRUNO MIOTO
  scale_x_continuous(position = 'top') +
  #scale_x_continuous(guide = guide_axis(position = 'top')) +
  labs(x = "", y = "") +
  facet_grid(painel~1) +
  theme(
    panel.background = element_rect(fill = 'black'),
    strip.text.x = element_blank()
  ) +
  scale_color_viridis_d(begin = .5)

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
