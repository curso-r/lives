library(shiny)
library(dplyr)

ui <- fluidPage(
  mod_mtcars_UI("parte_mtcars"),
  mod_penguins_UI("parte_penguins"),
  hr(),
  tableOutput("tabela")
)

server <- function(input, output, session) {
  
  callModule(
    module = mod_mtcars_server,
    id = "parte_mtcars"
  )
  
  base_penguins <- palmerpenguins::penguins
  
  coluna <- callModule(
    module = mod_penguins_server,
    id = "parte_penguins",
    base = base_penguins
  )
  
  output$tabela <- renderTable({
    coluna %>% 
      count()
  })
  
}

shinyApp(ui, server)