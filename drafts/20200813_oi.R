#' Author: Nicole Luduvice
#' Subject:

# library(tidyverse)
library(magrittr)
library(flow)
# Import -----------------------------------------------------------------------
flow::flow_view(median.default)

a <- function(vetor){
  b <- mean(vetor)
  if(b>3){
    return("UHULL")
  } else{
    return("BLEHH")}
}
build_nomnoml_code()

flow_view(build_nomnoml_code)

vec <- c(1:3, NA)

# Tidy -------------------------------------------------------------------------

# Visualize --------------------------------------------------------------------

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
