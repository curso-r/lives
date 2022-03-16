#' Author:
#' Subject:

library(tidyverse)

# Import -----------------------------------------------------------------------

url_dados <- "https://raw.githubusercontent.com/adamribaudo/storytelling-with-data-ggplot/master/data/FIG0206-7.csv"
dados <- readr::read_csv(url_dados)

# Tidy -------------------------------------------------------------------------

dados_tidy <- dados %>%
  janitor::clean_names() %>%
  mutate(cost_per_mile_num = parse_number(cost_per_mile))

media_y <- mean(dados_tidy$cost_per_mile_num)
media_x <- mean(dados_tidy$miles_driven)

dados_tidy <- dados_tidy %>%
  mutate(
    acima_abaixo = cost_per_mile_num > media_y
  )

# Visualize --------------------------------------------------------------------

ggplot(dados_tidy) +
  aes(
    x = miles_driven,
    y = cost_per_mile_num
  ) +
  geom_point(
    aes(colour = acima_abaixo),
    size = 3,
    show.legend = FALSE
  ) +
  geom_hline(
    yintercept = media_y,
    linetype = "longdash"
  ) +
  annotate(
    "point", x = media_x, y = media_y,
    size = 4
  ) +
  annotate(
    "label", x = media_x, y = media_y,
    label = "AVG",
    label.size = 0,
    hjust = 1.2,
    size = 4
  ) +
  scale_x_continuous(
    limits = c(0, 4000),
    labels = scales::comma
  ) +
  scale_y_continuous(
    limits = c(0, 3),
    breaks = seq(0, 3, .5),
    labels = scales::dollar
  ) +
  scale_colour_manual(
    values = c("lightgray", "orange")
  ) +
  labs(
    title = "Cost per mile by miles driven",
    x = "Miles driven per month",
    y = "Cost per mile"
  ) +
  theme_classic() +
  theme(
    title = element_text(
      colour = "gray60",
      family = "Rowdies"
    ),
    axis.title.x = element_text(
      hjust = 0,
      colour = "gray60"
    ),
    axis.title.y = element_text(
      hjust = 1,
      colour = "gray60"
    ),
    axis.line = element_line(colour = "gray60"),
    axis.ticks = element_line(colour = "gray60")
  )

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
