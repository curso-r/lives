customInputDate <- function (inputId, label, value = NULL, min = NULL, max = NULL,
          format = "yyyy-mm-dd", startview = "month", weekstart = 0,
          language = "en", width = NULL, autoclose = TRUE, datesdisabled = NULL,
          daysofweekdisabled = NULL, minview = "months")
{
  value <- shiny:::dateYMD(value, "value")
  min <- shiny:::dateYMD(min, "min")
  max <- shiny:::dateYMD(max, "max")
  datesdisabled <- shiny:::dateYMD(datesdisabled, "datesdisabled")
  value <- shiny:::restoreInput(id = inputId, default = value)
  tags$div(id = inputId, class = "shiny-date-input form-group shiny-input-container",
           style = if (!is.null(width))
             paste0("width: ", validateCssUnit(width), ";"), shinyInputLabel(inputId,
                                                                             label), tags$input(type = "text", class = "form-control",
                                                                                                `data-date-language` = language, `data-date-week-start` = weekstart,
                                                                                                `data-date-format` = format, `data-date-start-view` = startview,
                                                                                                `data-date-min-view-mode` = minview,
                                                                                                `data-min-date` = min, `data-max-date` = max, `data-initial-date` = value,
                                                                                                `data-date-autoclose` = if (autoclose)
                                                                                                  "true"
                                                                                                else "false", `data-date-dates-disabled` = jsonlite::toJSON(datesdisabled,
                                                                                                                                                            null = "null"), `data-date-days-of-week-disabled` = jsonlite::toJSON(daysofweekdisabled,
                                                                                                                                                                                                                                 null = "null")), shiny:::datePickerDependency)
}
