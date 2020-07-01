library(shiny)
library(shinydashboard)
library(fresh)

meu_tema <- create_theme(
  adminlte_color(
    aqua = "#71c1c2",
    blue = "#3474b0",
    red = "#37a75c",
    light_blue = "#4813bb",
    yellow = "#5a512f"
  ),
  adminlte_sidebar(
    dark_bg = "#9064f0"
  ),
  adminlte_global(
    content_bg = "#e1d7f7"
  )
)

ui <- dashboardPage(
  dashboardHeader(title = "Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem(
        "Aba 1",
        tabName = "aba1",
        menuSubItem(
          "Subitem 1",
          tabName = "subitem1"
        ),
        menuSubItem(
          "Subitem 2",
          tabName = "subitem2"
        )
      ),
      menuItem("Aba 2", tabName = "aba2")
    )
  ),
  dashboardBody(
    use_theme(meu_tema),
    tags$link(
      rel = "stylesheet",
      type = "text/css",
      href = "custom.css"
    ),
    tags$link(
      rel = "stylesheet",
      href = "https://fonts.googleapis.com/css2?family=Yellowtail&display=swap"
    ),
    tabItems(
      tabItem(
        "subitem1",
        fluidRow(
          box(
            width = 12,
            title = "Meu box",
            status = "primary",
            solidHeader = TRUE,
            height = 500,
            tags$div(
              class = "colorido",
              actionButton("botao1", label = "Botão 1")
            )

          )
        )
      ),
      tabItem(
        "subitem2",
        fluidRow(
          box(
            width = 12,
            title = "Meu box",
            status = "warning",
            solidHeader = TRUE,
            height = 500,
            actionButton("botao2", label = "Botão 2")
          )
        )
      ),
      tabItem(
        "aba2",
        fluidRow(
          column(
            width = 4,
            valueBoxOutput("valuebox1", width = 12)
          ),
          column(
            width = 4,
            valueBoxOutput("valuebox2", width = 12)
          ),
          column(
            width = 4,
            infoBoxOutput("infobox", width = 12)
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {

  output$valuebox1 <- renderValueBox({
    valueBox(
      200,
      subtitle = "unidades",
      color = "aqua",
      icon = icon("hamburger")
    )
  })

  output$valuebox2 <- renderValueBox({
    valueBox(
      300,
      subtitle = "unidades",
      color = "blue",
      icon = icon("gamepad")
    )
  })

  output$infobox <- renderInfoBox({
    infoBox(
      400,
      subtitle = "unidades",
      color = "red",
      icon = icon("headset")
    )
  })

}

shinyApp(ui, server)
