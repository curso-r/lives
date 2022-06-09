#' Author:
#' Subject:

library(tidyverse)

u <- "https://raw.githubusercontent.com/adamribaudo/storytelling-with-data-ggplot/master/data/FIG0902.csv"


dados_raw <- read_csv(u) |>
  janitor::clean_names()

dados_tidy <- dados_raw |>
  pivot_longer(-item) |>
  mutate(value = parse_number(value) / 100) |>
  mutate(
    label = if_else(
      name == "middle", "", scales::percent(value)
    ),
    hjust = runif(n()),
    cor = if_else(
      item == "Survey item A" & name == "bottom_box",
      "#c3514e", "white"
    )
  )

library(ggtext)
dados_tidy |>
  ggplot() +
  aes(value, fct_rev(item), fill = fct_rev(name)) +
  geom_col() +
  geom_text(
    aes(label = label),
    color = "white",
    position = position_stack(vjust = .5),
    data = filter(
      dados_tidy,
      !(item == "Survey item A" & name == "bottom_box")
    )
  ) +
  geom_text(
    aes(label = label),
    color = "#c3514e",
    nudge_x = .04,
    data = filter(
      dados_tidy,
      item == "Survey item A" & name == "bottom_box"
    )
  ) +
  scale_x_continuous(
    labels = scales::percent,
    breaks = seq(0, 1, .2),
    position = "top",
    expand = c(0,0)
  ) +
  annotate(
    "text", x = 1, y = 4.2, hjust = -.1,
    label = "Survey tem A",
    color = "#4bacc6"
  ) +
  annotate(
    "text", x = 1, y = 3.8, hjust = -.1,
    label = "ranked highest\n for team X",
    color = "#bfbebe"
  ) +
  annotate(
    "text", x = 1, y = 0.74, hjust = -.35,
    label = "Survey tem D", color = "#c3514e"
  ) +
  annotate(
    "text", x = 1, y = 1, hjust = -.1,
    label = "Dissatisfaction\nwas greatest\n for ",
    color = "#bfbebe"
  ) +
  coord_cartesian(clip = "off", xlim = c(0, 1.5)) +
  scale_fill_manual(
    values = c("#4bacc6", "#bfbebe", "#c3514e")
  ) +
  theme_minimal() +
  labs(
    title = "Survey Results: Team X",
    subtitle = "<strong><span style='color:#c3514e;'>Strongly Diagree</span><span style='color:#bfbebe;'> | Disagree | Neutral | </span><span style='color:#4bacc6;'>Strongly Agree</span></strong>"
  ) +
  theme(
    panel.grid = element_blank(),
    axis.line.x = element_blank(),
    axis.ticks.x.top = element_line(size = .1, colour = "gray20", lineend = "butt"),
    axis.text.y = element_text(colour = "black", size = 13),
    legend.position = "none",
    axis.title = element_blank(),
    plot.title.position = "plot",
    plot.subtitle = ggtext::element_markdown(size = 14, hjust = .5)
  ) +
  annotate(
    "segment",
    x = 0,
    xend = 1,
    y = 4.6,
    yend = 4.6,
    color = "gray20"
  )





