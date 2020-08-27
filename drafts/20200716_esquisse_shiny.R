ui <- fluidPage(
  
  titlePanel("Use esquisse as a Shiny module"),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons(
        inputId = "data", 
        label = "Data to use:", 
        choices = c("iris", "mtcars", "geo"),
        inline = TRUE
      )
    ),
    mainPanel(
      tabsetPanel(
        tabPanel(
          title = "esquisse",
          esquisserUI(
            id = "esquisse", 
            header = FALSE, # dont display gadget title
            choose_data = FALSE # dont display button to change data
          )
        ),
        tabPanel(
          title = "output",
          verbatimTextOutput("module_out")
        )
      )
    )
  )
)


server <- function(input, output, session) {
  
  data_r <- reactiveValues(data = iris, name = "iris")
  
  observeEvent(input$data, {
    if (input$data == "iris") {
      data_r$data <- iris
      data_r$name <- "iris"
    } else if (input$data == "mtcars") {
      data_r$data <- mtcars
      data_r$name <- "mtcars"
    } else {
      data_r$data <- da_map
      data_r$name <- "da_map"
    }
  })
  
  result <- callModule(
    module = esquisserServer,
    id = "esquisse",
    data = data_r
  )
  
  output$module_out <- renderPrint({
    str(reactiveValuesToList(result))
  })
  
}

shinyApp(ui, server)