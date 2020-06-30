library(shiny)
library(tidyverse)

source("customDateInput.R")

ui <- fluidPage(
  customDateInput(
    inputId = "data",
    label = "Selecione uma data",
    min = "2013-01-01",
    max = "2013-12-31",
    value = "2013-01-01",
    format = "yyyy-mm"
  ),
  shiny::dateRangeInput(
    inputId = "datarange",
    label = "Selecione um intervalo",
    min = "2013-01-01",
    max = "2013-12-31",
    start = "2013-01-01",
    end = "2013-01-31"
  ),
  plotOutput("grafico"),
  plotOutput("grafico2")
)

server <- function(input, output, session) {

  output$grafico <- renderPlot({
    browser()
    nycflights13::flights %>%
      mutate(data = lubridate::make_date(year, month, day)) %>%
      filter(
        data >= input$datarange[1],
        data <= input$datarange[2]
      ) %>%
      group_by(data) %>%
      summarise(num_voos = n()) %>%
      ggplot(aes(x = data, y = num_voos)) +
      geom_line()
  })

  output$grafico2 <- renderPlot({
    nycflights13::flights %>%
      mutate(data = lubridate::make_date(year, month, day)) %>%
      filter(data == input$data) %>%
      ggplot(aes(x = carrier)) +
      geom_bar()
  })
}

shinyApp(ui, server)
