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



get_drug <- function(drug) {
  url <- "https://api.who-umc.org/vigibase/icsrstatistics/dimensions/drug"
  query <- list(tradename = drug)

  headers <- httr::add_headers(
    "Authorization" = "Basic VmlnaUJhc2VBY2Nlc3NDbGllbnQ6cHN3ZDRWaUE=",
    "umc-client-key" = "6d851d41-f558-4805-a9a6-08df0e0e414b"
  )

  info <- url %>%
    httr::GET(query = query, httr::accept_json(), headers) %>%
    xml2::read_html() %>%
    xml2::xml_find_first("//p") %>%
    xml2::xml_text() %>%
    jsonlite::fromJSON()

  url <- "https://api.who-umc.org/vigibase/icsrstatistics/distributions"
  query <- list(
    agegroupFilter = "",
    continentFilter = "",
    reactionFilter = "",
    sexFilter = "",
    substanceFilter = info[[1]]
  )

  url %>%
    httr::GET(query = query, httr::accept_json(), headers) %>%
    xml2::read_html() %>%
    xml2::xml_find_first("//p") %>%
    xml2::xml_text() %>%
    jsonlite::fromJSON() %>%
    utils::tail(-1) %>%
    purrr::map(dplyr::as_tibble) %>%
    purrr::map(janitor::clean_names) %>%
    purrr::map(list) %>%
    dplyr::as_tibble() %>%
    janitor::clean_names() %>%
    dplyr::mutate(
      tradename = drug,
      substrance_id = info[[1]]
    ) %>%
    dplyr::relocate(substrance_id, tradename)
}

dplyr::glimpse(get_drug("tylenol"))
