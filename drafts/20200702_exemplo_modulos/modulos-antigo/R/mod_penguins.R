mod_penguins_UI <- function(id) {
  
  ns <- NS(id)
  
  variaveis_numericas <- palmerpenguins::penguins %>% 
    select(where(is.numeric)) %>% 
    names()
  
  tagList(
    h1("Base penguins"),
    fluidRow(
      column(
        width = 4,
        selectInput(
          inputId = ns("variavel"),
          label = "Selecione uma variável",
          choices = variaveis_numericas
        )
      ),
      column(
        width = 8,
        plotOutput(ns("grafico"))
      )
    )
  )
  
}

mod_penguins_server <- function(input, output, session,
                                base) {
  
  output$grafico <- renderPlot({
    
    hist(
      base[,input$variavel, drop = TRUE]
    )
    
  })
  
  return(base[,1])
  
}