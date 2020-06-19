#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here
  
  output$grafico <- renderPlot({
    
    palmerpenguins::penguins %>% 
      ggplot2::ggplot(ggplot2::aes(
        x = culmen_length_mm, 
        y = culmen_depth_mm, 
        color = species)
      ) +
      ggplot2::geom_point()
    
  })
  
  output$valuebox <- shinydashboard::renderValueBox({
    shinydashboard::valueBox(
      value = nrow(palmerpenguins::penguins),
      subtitle = "Número de pinguins"
    )
  })
  
  output$infobox <- shinydashboard::renderInfoBox({
    shinydashboard::infoBox(
      title = "Número de espécies",
      value = length(unique(as.character(palmerpenguins::penguins$species)))
    )
  })

}
