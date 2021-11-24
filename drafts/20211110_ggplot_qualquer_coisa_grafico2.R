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

funcao_para_iterar <- function(tipo_painel, dados = da_tidy) {
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

tab <- da_visualizar %>%
  mutate(
    realce = factor(realce),
    numero = ifelse(
      (ano == min(ano) | ano == max(ano)) & realce == 1, 1, 0
    ),
    hjust = case_when(
      ano == min(ano) ~ 1.2,
      ano == max(ano) ~ -0.3,
      TRUE ~ NA_real_
    ),
    painel = stringr::str_wrap(painel, 5)
  )

tab %>%
  filter(realce == 0) |>
  ggplot(aes(x = ano, y = perc_funders)) +
  geom_line(size = 1.3, color = "grey", aes(group = category)) +
  geom_line(
    data = filter(tab, realce == 1),
    size = 1.3,
    color = "royal blue"
  ) +
  geom_point(
    data = filter(tab, numero == 1),
    aes(x = ano, y = perc_funders),
    color = "black"
  ) +
  geom_text(
    data = filter(tab, numero == 1),
    aes(
      x = ano,
      y = perc_funders,
      label = scales::percent(perc_funders, accuracy = 1),
      hjust = hjust
    ),
    color = "black"
  ) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    axis.text.y = element_blank()
  ) +
  # sugestão do BRUNO MIOTO
  scale_x_continuous(position = 'top') +
  #scale_x_continuous(guide = guide_axis(position = 'top')) +
  labs(x = "", y = "") +
  facet_wrap(vars(painel), nrow = 5,  strip.position = "left") +
  theme(
    # panel.background = element_rect(fill = 'black'),
    strip.text.y.left = element_text(angle = 0, hjust = 0),
    plot.margin = unit(c(0.3, 1, 1, 0.1), "cm"),
    axis.line.x = element_line()
  ) +
  scale_color_viridis_d(begin = .5) +
  coord_cartesian(clip = "off")

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
