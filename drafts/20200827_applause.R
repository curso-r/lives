#' Author:
#' Subject:

# library(tidyverse)
library(magrittr)

library(shiny)

ui <- fluidPage(
  h2("My Awesome Shiny App"),
  applause::button(width = "500px")
)

server <- function(input, output, session) {
  # ...
}

shinyApp(ui, server)

# Import -----------------------------------------------------------------------

# Tidy -------------------------------------------------------------------------

# Visualize --------------------------------------------------------------------

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
