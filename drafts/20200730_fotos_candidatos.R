#' Author: Julio Trecenti
#' Subject:

# library(tidyverse)
library(magrittr)

u <- "http://divulgacandcontas.tse.jus.br/divulga/#/candidato/2018/2022802018/BR/280000614517"
r <- httr::GET(u)

r %>%
  xml2::read_html() %>%
  xml2::xml_find_all("//img[@class='img-thumbnail img-responsive dvg-cand-foto ng-scope']")

# pjs <- webdriver::run_phantomjs()
# sess <- webdriver::Session$new(port = pjs$port)
# sess$go(u)
# sess$takeScreenshot()

"RSelenium"

library(reticulate)
link <- xml2::read_html(py$obj) %>%
  xml2::xml_find_first("//img[@class='img-thumbnail img-responsive dvg-cand-foto ng-scope']") %>%
  xml2::xml_attr("src")

httr::GET(link, httr::write_disk("data-raw/candidato.jpg"))

# Import -----------------------------------------------------------------------

# Tidy -------------------------------------------------------------------------

# Visualize --------------------------------------------------------------------

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
