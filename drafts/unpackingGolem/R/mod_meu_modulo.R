#' meu_modulo UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_meu_modulo_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' meu_modulo Server Function
#'
#' @noRd 
mod_meu_modulo_server <- function(input, output, session){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_meu_modulo_ui("meu_modulo_ui_1")
    
## To be copied in the server
# callModule(mod_meu_modulo_server, "meu_modulo_ui_1")
 
