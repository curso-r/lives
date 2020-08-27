#' Author: Julio Trecenti
#' Subject:

# library(tidyverse)
library(magrittr)

install.packages("shinydisconnect")

?shinydisconnect::disconnectMessage()


# remotes::install_github("datathonbr/moanr")
library(shiny)
library(shinydisconnect)
shinyApp(
  ui = fluidPage(
    disconnectMessage(),
    actionButton("disconnect", "Disconnect the app")
  ),
  server = function(input, output, session) {
    observeEvent(input$disconnect, {
      session$close()
    })
  }
)

# Import -----------------------------------------------------------------------

# Tidy -------------------------------------------------------------------------

# Visualize --------------------------------------------------------------------

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
