library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Parte mtcars", tabName = "parte_mtcars"),
      menuItem("Parte penguins", tabName = "parte_penguins")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        "parte_mtcars",
        mod_mtcars_UI("mod_mtcars")
      ),
      tabItem(
        "parte_penguins",
        mod_penguins_UI("mod_penguins")
      )
    )
  )
)

server <- function(input, output, session) {
  
  mod_mtcars_server("mod_mtcars", base = mtcars)
  
  mod_penguins_server("mod_penguins")

}

shinyApp(ui, server)