mod_mtcars_UI <- function(id) {
  ns <- NS(id)
  tagList(
    h1("Base mtcars"),
    fluidRow(
      column(
        width = 4,
        selectInput(
          inputId = ns("variavel"),
          label = "Selecione uma variável",
          choices = names(mtcars)
        )
      ),
      column(
        width = 8,
        plotOutput(ns("grafico"))
      )
    )
  )
}

mod_mtcars_server <- function(id, base) {
  shiny::moduleServer(
    id,
    function(input, output, session) {
      
      output$grafico <- renderPlot({
        
        hist(base[,input$variavel])
        
      })
      
    }
  )
}
