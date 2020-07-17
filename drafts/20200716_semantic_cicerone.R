library(shiny)
library(cicerone)
library(semantic.dashboard)

guide <- Cicerone$
  new()$
  step(
    el = "text_inputId",
    title = "Text Input",
    description = "This is where you enter the text you want to print."
  )$
  step(
    "submit_inputId",
    "Send the Text",
    "Send the text to the server for printing"
  )

ui <- dashboardPage(
  header = dashboardHeader(),
  sidebar = dashboardSidebar(
    sidebarMenu()
  ),
  body = dashboardBody(
    use_cicerone(), # include dependencies
    textInput("text_inputId", "Enter some text"),
    actionButton("submit_inputId", "Submit text"),
    verbatimTextOutput("print")
  ),
  title = "oi"
)

server <- function(input, output){

  # initialise then start the guide
  guide$init()$start()

  txt <- eventReactive(input$submit_inputId, {
    input$text_inputId
  })

  output$print <- renderPrint(txt())
}

shinyApp(ui, server)
