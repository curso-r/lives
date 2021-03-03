#' Author:
#' Subject:

# library(tidyverse)
library(magrittr)

# Import -----------------------------------------------------------------------

u_fund <- "https://fundamentus.com.br/detalhes.php"

ua <- httr::add_headers(
  "User-Agent" = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.112 Safari/537.36"
)

r <- httr::GET(u_fund, ua)

## acho que nao precisa
# u_opcoes <- "https://fundamentus.com.br/script/cmplte.php"
# r_opcoes <- httr::GET(u_opcoes, ua)
# httr::content(r, "text") %>%
#   stringr::str_squish() %>%
#   stringr::str_extract("(?<=(tokens)).+")

links <- r %>%
  xml2::read_html() %>%
  xml2::xml_find_all("//a[contains(@href, 'detalhes.php?')]") %>%
  xml2::xml_attr("href") %>%
  paste0("https://fundamentus.com.br/", .)

baixar_link <- function(.x, p) {
  p()
  nome <- stringr::str_extract(.x, "(?<==).*$")
  caminho <- paste0("data-raw/fundamentus/", nome, ".html")
  httr::GET(.x, ua, httr::write_disk(caminho, TRUE))
}

# progressr::handler_progress()

future::plan(future::multisession)

progressr::with_progress({
  p <- progressr::progressor(length(links))
  furrr::future_walk(links, baixar_link, p)
})

# arqs <- fs::dir_ls("data-raw/fundamentus")
# head(arqs)

tabelas <- arqs[2] %>%
  xml2::read_html() %>%
  xml2::xml_find_all("//table") %>%
  purrr::map(rvest::html_table) %>%
  purrr::map(tibble::as_tibble)

# tibble::tibble(
#   x = 1:5,
#   tabela = tabelas
# ) %>%
#   tidyr::unnest(tabela)

# Tidy -------------------------------------------------------------------------

# Visualize --------------------------------------------------------------------

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
