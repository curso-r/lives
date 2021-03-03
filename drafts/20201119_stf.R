#' Author:
#' Subject:

# library(tidyverse)
library(magrittr)

api_stf <- "https://jurisprudencia.stf.jus.br/api/search/search"
body <- jsonlite::read_json("payload.json")
teste <- httr::POST(api_stf, body = body, encode = "json",
                    httr::config(ssl_verifypeer = FALSE))

httr::content(teste)


# Import -----------------------------------------------------------------------

# Tidy -------------------------------------------------------------------------

# Visualize --------------------------------------------------------------------

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
