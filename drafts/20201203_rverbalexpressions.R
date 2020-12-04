#' Author:
#' Subject:

# library(tidyverse)
library(magrittr)

library(RVerbalExpressions)

cpf <- "123.354.546-22"
cpf_limpo <- "12335454622"
cpf_cagado <- "123.354..546/22"
cpf_tel <- "1199999-2222"

rx() %>%
  rx_multiple(rx_digit(), 3, 3) %>%
  rx_maybe(".") %>%
  rx_multiple(rx_digit(), 3, 3) %>%
  rx_maybe(".") %>%
  rx_multiple(rx_digit(), 3, 3) %>%
  rx_maybe("-") %>%
  rx_multiple(rx_digit(), 2, 2)


rx_anything_but()

# Import -----------------------------------------------------------------------

# Tidy -------------------------------------------------------------------------

# Visualize --------------------------------------------------------------------

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
