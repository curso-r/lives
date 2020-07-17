#' Author: Caio
#' Subject:

# library(tidyverse)
library(magrittr)

# Import -----------------------------------------------------------------------

a <- c("a", "b", "e")
b <- c("a", "b", "c", "d", "e")
waldo::compare(a, b)

waldo::compare(iris, janitor::clean_names(iris))

waldo::compare(iris, head(iris))

waldo::compare(list(x = "x", y = "y"), list(y = "y", x = "x"))

a <- nycflights13::flights %>%
  dplyr::mutate(
    date = format(as.Date(time_hour), "%d/%m/%Y")
  )
b <- nycflights13::flights %>%
  dplyr::mutate(
    date = format(as.Date(time_hour), "%Y-%m-%d")
  )
waldo::compare(a, b)

janitor::compare_df_cols(a, b)

# Tidy -------------------------------------------------------------------------

# Visualize --------------------------------------------------------------------

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
