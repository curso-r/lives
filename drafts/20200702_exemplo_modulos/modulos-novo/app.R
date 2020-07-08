library(shiny)
library(dplyr)

ui <- fluidPage(
  mod_mtcars_UI("parte_mtcars"),
  mod_penguins_UI("parte_penguins")
)

server <- function(input, output, session) {
  
  base_mtcars <- mtcars
  
  mod_mtcars_server("parte_mtcars", base = base_mtcars)
  mod_penguins_server("parte_penguins")

  
}

shinyApp(ui, server)