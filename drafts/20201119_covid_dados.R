#' Author:
#' Subject:

# library(tidyverse)
library(magrittr)

# Import -----------------------------------------------------------------------

u_base <- "https://data.humdata.org/dataset/e1a91ae0-292d-4434-bc75-bf863d4608ba"
r0 <- httr::GET(u_base)

endpoint <- r0 %>%
  xml2::read_html() %>%
  xml2::xml_find_first("//a[contains(@href, 'xlsx')]") %>%
  xml2::xml_attr("href")

u <- paste0("https://data.humdata.org", endpoint)
r <- httr::GET(u, httr::write_disk("arquivo.xlsx", TRUE))



# Tidy -------------------------------------------------------------------------

# Visualize --------------------------------------------------------------------

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
