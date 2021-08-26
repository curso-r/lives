#' Author: Athos e Fernando
#' Subject: reactable

library(tidyverse)
library(magrittr)

# reactable -----------------------------------------------------------------------
library(reactable)
library(reactablefmtr)
library(sparkline)

# um data.frame
reactable(mtcars,
          sortable = TRUE,
          resizable = TRUE,
          filterable = TRUE)

a <- viridis::magma(5)

a <- c("#ffffff", "#000000", "#ffffff")

mtcars %>%
  reactable(
    defaultPageSize = 15,
    wrap = FALSE,
    defaultColDef = colDef(resizable = TRUE, maxWidth = 50),
    details = function(i) {
      i
    },
    columns = list(
      .rownames = colDef(maxWidth = 180),
      mpg = colDef(style = color_scales(mtcars, colors = a), format = colFormat(percent = TRUE)),
      cyl = colDef(cell = icon_assign(mtcars)),
      disp = colDef(cell = data_bars(
        mtcars,
        fill_color = c("#d7191c", "#1a9641", "#d7191c"))
      )
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
      shiny::tagList(
        shiny::h1("OPA"),
        reactable(iris),
        plotly::ggplotly(qplot(tabela_transposta$valores[[i]], bins = 10))
      )
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
    groupBy = c("Species", "Sepal.Length"),
    defaultColDef = colDef(
      aggregate = "sum"
    )
  )


