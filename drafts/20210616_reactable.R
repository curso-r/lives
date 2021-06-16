#' Author: Athos e Fernando
#' Subject: reactable + highcharter

library(tidyverse)
library(magrittr)

# reactable -----------------------------------------------------------------------
library(reactable)
library(reactablefmtr)
library(sparkline)

# um data.frame
reactable(mtcars)

mtcars %>%
  reactable(
    wrap = FALSE,
    defaultColDef = colDef(resizable = TRUE, maxWidth = 70),
    details = function(i) {
      i
    },
    columns = list(
      .rownames = colDef(maxWidth = 180),
      mpg = colDef(style = color_scales(mtcars), format = colFormat(prefix = "R$")),
      cyl = colDef(style = color_tiles(mtcars))
    )
  )



# ideias mirabolantes
tabela_transposta <- mtcars %>%
  as.list() %>%
  enframe("variavel", "valores")

histograminha <- function(valores) {
  if (!is.numeric(valores)) return()
  contagens <- as.numeric(table(cut(valores, min(10, n_distinct(valores)))))
  sparkline(contagens, type = "bar")
}

tabela_transposta %>%
  mutate(
    media = map_dbl(valores, mean),
    sd = map_dbl(valores, sd)
  ) %>%
  reactable(
    columns = list(
      valores = colDef(show = TRUE, cell = histograminha),
      media = colDef(format = colFormat(digits = 2)),
      sd = colDef(format = colFormat(digits = 2))
    ),
    details = function(i) {
      # plotly::ggplotly(qplot(tabela_transposta$valores[[i]], bins = 10))
      reactable(iris)
    }
  )

# footer
mtcars %>%
  reactable(
    defaultColDef = colDef(
      footer = histograminha
    )
  )


# grouped
iris %>%
  reactable(
    groupBy = "Species",
    defaultColDef = colDef(
      aggregate = "mean"
    )
  )

# highcharter -------------------------------------------------------------

library(highcharter)
highcharter::hchart(mtcars$mpg)

mtcars %>%
  hchart("histogram", hcaes(x = "mpg"))
