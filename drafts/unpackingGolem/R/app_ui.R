#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  shinydashboard::dashboardPage(
    header = shinydashboard::dashboardHeader(title = "Live"),
    sidebar = shinydashboard::dashboardSidebar(
      shinydashboard::sidebarMenu(
        shinydashboard::menuItem(
          "Teste", tabName = "Aba_1"
        )
      )
    ),
    body = shinydashboard::dashboardBody(
      fresh::use_theme(tema()),
      shinydashboard::tabItems(
        shinydashboard::tabItem(
          "vamos ver se fiz certo",
          tabName = "Aba_1",
          plotOutput("grafico"),
          shinydashboard::infoBoxOutput("infobox"),
          shinydashboard::valueBoxOutput("valuebox")
        )
      )
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'unpackingGolem'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

