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

as <- "https://www.saude.gov.br/contratos-coronavirus" %>%
  httr::GET() %>%
  httr::content("parsed") %>%
  xml2::xml_find_all("//div[@class='su-table']/table//a")

arqs <- dplyr::tibble(
  href = xml2::xml_attr(as, "href"),
  n_contrato = xml2::xml_text(as)
) %>%
  dplyr::mutate(
    href = dplyr::if_else(stringr::str_detect(href, "http"), href, paste0("https://www.saude.gov.br", href)),
    file = paste0("~/Downloads/", fs::path_file(href))
  )

purrr::walk2(arqs$href, arqs$file, ~httr::GET(.x, httr::write_disk(.y)))

df <- df %>%
  dplyr::left_join(arqs)

readr::write_rds(df, "~/Documents/lives/data-raw/df_contratos_covid.rds")
