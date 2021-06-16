#' Author:
#' Subject:

library(tidyverse)
library(magrittr)
library(listviewer)

# Import -----------------------------------------------------------------------
reactjson(
  list(
    array = c(1,2,3)
    ,boolean = TRUE
    ,null = NULL
    ,number = 123
    ,object = list( a="b", c="d" )
    ,string = "Hello World"
  )
)


# shinyzinho ----------------------
library(shiny)

ui <- fluidPage(
  leafletOutput('map'),
  reactjsonOutput("input")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet_map
  })

  output$input <- renderReactjson({
    reactjson(shiny::reactiveValuesToList(input))
  })
}

shinyApp(ui, server)
