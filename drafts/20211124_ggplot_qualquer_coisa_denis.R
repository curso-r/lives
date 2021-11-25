#' Author:
#' Subject:

# library(tidyverse)
library(magrittr)
library(ggplot2)

# Import -----------------------------------------------------------------------

banco1 <- data.frame(
  atividade = rep(c(
    "Trabalho rodoviário de carga, exceto produtos perigosos e \n mudanças, intermunicipal, interstadual e internacional",
    "Condomínios prediais",
    "Comércio varejista de mercadorias em geral, com predominância \n de produtos alimentícios - supermercados",
    "Construção de edifícios",
    "Limpeza em prédios e em domicílios",
    "Atividades de atendimento hospitalar, exceto pronto socorro e \n unidades para atendimento a urgências",
    "Administração pública em geral",
    "Restaurantes e similares",
    "Atividades de vigilância e segurança privada",
    "Transporte rodoviário coletivo de passageiros, com itinerário \n fixo, municipal",
    "Criação de bovinos para corte",
    "Fabricação de açúcar bruto",
    "Comércio varejista de combustíveis para veículos automotores",
    "Atividades de associações de defesa de direitos sociais",
    "Lanchonetes, casas de chá, sucos e similares"
  ), 2),
  ano = c(rep(2019,15),rep(2020,15)),
  count = c(
    1487,1388,1276,1222,
    1216,986,974,940,917,909,695,618,574,482,470,2166,1552,1548,1665,
    1479,1395,1228,1065,1388,1242,543,602,761,523,506
  )
)

# Tidy -------------------------------------------------------------------------

base_tidy <- banco1 %>%
  tibble::as_tibble() %>%
  dplyr::arrange(ano) %>%
  dplyr::group_by(atividade) %>%
  dplyr::mutate(
    variacao = count[2] / count[1] - 1,
    lab = scales::percent(variacao, accuracy = .01),
    nudge = dplyr::case_when(
      count[2] > count[1] ~ c(1.5, -.5),
      TRUE ~ c(-.5, 1.5)
    )
  ) %>%
  dplyr::ungroup() %>%
  dplyr::mutate(
    # atividade = stringr::str_wrap(atividade, 60),
    atividade = forcats::fct_reorder(
      atividade, count, dplyr::first
    )
  )

# Visualize --------------------------------------------------------------------

library(mdthemes)
base_tidy %>%
  ggplot() +
  aes(count, atividade, colour = factor(ano)) +
  geom_vline(
    xintercept = 2:11 * 200,
    linetype = 2,
    size = .3,
    colour = "gray80"
  ) +
  geom_path(
    aes(group = atividade, colour = NULL),
    colour = "#dedede",
    size = 2
  ) +
  scale_colour_manual(values = c("#f59300", "#974602")) +
  geom_point(
    size = 3,
    show.legend = FALSE
  ) +
  labs(
    title = "<strong style='color:#25588d;'>Os 15 setores com mais desligamentos por morte em 2019 e 2020</strong>",
    subtitle = "Transporte, serviços prediais, comércio e saúde tiveram fortes aumentos nas mortes de funcionários com emprego formal",
    x = ""
  ) +
  mdthemes::md_theme_minimal() +
  scale_x_continuous(breaks = 2:11 * 200) +
  geom_text(
    aes(x = 2400, label = lab),
    data = dplyr::distinct(base_tidy, atividade, .keep_all = TRUE),
    colour = "black"
  ) +
  geom_text(
    aes(label = count, hjust = nudge),
    show.legend = FALSE
  ) +
  theme(
    axis.title.x = element_blank(),
    plot.title.position = "plot",
    title = element_text(hjust = -2),
    panel.grid = element_blank()
  ) +
  annotate(
    "text", x = 1400, y = 16,
    size = 3,
    label = "desligamentos por\nmorte em 2019",
    colour = c("#f59300")
  ) +
  annotate(
    "text", x = 2100, y = 16,
    size = 3,
    label = "desligamentos por\nmorte em 2020",
    colour = "#974602"
  ) +
  annotate(
    "text", x = 2400, y = 16,
    size = 3,
    label = "Variação\n(%)",
    colour = "black"
  ) +
  coord_cartesian(
    xlim = c(400, 2600),
    ylim = c(1, 16),
    clip = "off"
  )


# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
