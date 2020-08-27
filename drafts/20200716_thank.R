#' Author: Julio Trecenti
#' Subject:

# library(tidyverse)
library(magrittr)

library(tidyverse)
library(thankr)

shoulders() %>%
  as_tibble()

shoulders("package", "auth0",
          include_dependencies = TRUE)

# AH NAO

remotes::install_github("jimhester/thank@792e7b6d3864")
library(thank)
thank::you()

# Import -----------------------------------------------------------------------

# Tidy -------------------------------------------------------------------------

# Visualize --------------------------------------------------------------------

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
