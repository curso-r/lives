library(magrittr)

df <- "https://www.saude.gov.br/contratos-coronavirus" %>%
  httr::GET() %>%
  httr::content("parsed") %>%
  xml2::xml_find_all("//div[@class='su-table']/table") %>%
  rvest::html_table() %>%
  purrr::pluck(1) %>%
  dplyr::as_tibble() %>%
  janitor::clean_names() %>%
  purrr::set_names(stringr::str_remove, "º")

readr::write_rds(df, "~/Documents/lives/data-raw/df_contratos_covid.rds")


as <- "https://www.saude.gov.br/contratos-coronavirus" %>%
  httr::GET() %>%
  httr::content("parsed") %>%
  xml2::xml_find_all("//div[@class='su-table']/table//a")

dplyr::tibble(
         href = xml2::xml_attr(as, "href"),
         n_contrato = xml2::xml_text(as)
)
