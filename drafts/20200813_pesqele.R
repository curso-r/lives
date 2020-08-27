#' Author: Julio Trecenti
#' Subject:

# library(tidyverse)
library(magrittr)

remotes::install_github("conre3/pesqEle")

shiny::runGitHub("pesqEle", username = "conre3", subdir = "inst/app/")

pesqEle::pe_2018(path = "data-raw/pesqEle")


# Import -----------------------------------------------------------------------

# Tidy -------------------------------------------------------------------------

# Visualize --------------------------------------------------------------------

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
