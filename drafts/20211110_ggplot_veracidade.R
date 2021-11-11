#' Author:
#' Subject:

# library(tidyverse)
library(magrittr)

# Import -----------------------------------------------------------------------

id_planilha <- "1sJDpzYH_sMYuYHqkmZeJGIq_TEXGDjboYdSoew7UjZ8"
da_br <- googlesheets4::read_sheet(
  id_planilha, sheet = "Bohemian Rhapsody"
)

# Tidy -------------------------------------------------------------------------

da_br |>
  dplyr::glimpse()

da_tidy <- da_br |>
  janitor::clean_names() |>
  dplyr::transmute(
    id,
    start = as.numeric(start),
    end = as.numeric(end),
    truth_level = as.character(truth_level)
  )

# Visualize --------------------------------------------------------------------

library(ggplot2)
# install.packages("mdthemes")




faz_grafico <- function(filme) {

  id_planilha <- "1sJDpzYH_sMYuYHqkmZeJGIq_TEXGDjboYdSoew7UjZ8"

  da_raw <- googlesheets4::read_sheet(
    id_planilha, sheet = filme
  )

  da_tidy <- da_raw |>
    janitor::clean_names() |>
    dplyr::transmute(
      id,
      start = as.numeric(start),
      end = as.numeric(end),
      truth_level = as.character(truth_level)
    )

  percentual <- da_tidy |>
    dplyr::filter(
      !truth_level %in% c("-", "UNKNOWN")
    ) |>
    dplyr::summarise(
      res = mean(truth_level %in% c("TRUE", "TRUE-ISH"))
    ) |>
    dplyr::pull(res) |>
    scales::percent(accuracy = .1)

  da_tidy |>
    dplyr::filter(truth_level != "-") |>
    dplyr::mutate(truth_level = forcats::lvls_reorder(
      truth_level, c(3, 4, 2, 1, 5)
    )) |>
    ggplot() +
    geom_rect(
      mapping = aes(
        xmin = start, xmax = end,
        ymin = 0, ymax = 1,
        fill = truth_level
      ),
      colour = "white",
      size = .05,
      show.legend = FALSE
    ) +
    scale_fill_manual(values = c(
      "#42A5F5","#8BC8F9","#F386AA",
      "#EC407A","#D3D3D3"
    )) +
    labs(
      title = stringr::str_glue(
        "<strong style='color:#6D8Cd6;'>{percentual}</strong>",
        " <strong style='color:black;'>{filme}</strong>",
        " <span style='color:#444444;font-size:10px'>2018</span>"
      )
    ) +
    mdthemes::md_theme_classic() +
    theme(
      axis.line = element_blank(),
      axis.ticks = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_blank()
    )

}


dois_filmes <- c(
  "Bohemian Rhapsody",
  "The Imitation Game"
)

faz_grafico(outro_filme)

lista_graficos <- purrr::map(dois_filmes, faz_grafico)

patchwork::wrap_plots(lista_graficos, ncol = 1)


# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
