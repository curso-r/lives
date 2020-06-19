#' Run the Shiny Application
#'
#' @param ... A series of options to be used inside the app.
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(
  ...
) {
  
  tema <- fresh::create_theme(
    fresh::adminlte_color(
      light_blue = "#434C5E"
    ),
    fresh::adminlte_sidebar(
      width = "400px",
      dark_bg = "#D8DEE9",
      dark_hover_bg = "#81A1C1",
      dark_color = "#2E3440"
    ),
    fresh::adminlte_global(
      content_bg = "#FFF",
      box_bg = "#D8DEE9", 
      info_box_bg = "#D8DEE9"
    )
  )
  
  with_golem_options(
    app = shinyApp(
      ui = app_ui, 
      server = app_server
    ), 
    golem_opts = list(...)
  )
}
