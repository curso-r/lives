library(shiny)
library(magrittr)

dados <- readr::read_rds("data-raw/da_sabesp.rds")

ui <- fluidPage(
  titlePanel("Dados Sabesp"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "sistema",
        label = "Selecione um sistema",
        choices = unique(dados$nome),
        multiple = TRUE,
        selected = dplyr::first(dados$nome)
      ),
      tags$img(src = "curso-r.png", width = "40%")
    ),
    mainPanel(
      highcharter::highchartOutput("grafico")
    )
  )
)

server <- function(input, output, session) {

  output$grafico <- highcharter::renderHighchart({

    dados %>%
      dplyr::filter(nome %in% input$sistema) %>%
      dplyr::mutate(dia = as.Date(dia)) %>%
      highcharter::hchart(
        "line",
        highcharter::hcaes(x = dia, y = volume_porcentagem, group = nome)
      )

  })


}

shinyApp(ui, server)
