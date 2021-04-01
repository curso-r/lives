#' Author:
#' Subject: Site do flamengo

# library(tidyverse)
library(magrittr)

# Import -----------------------------------------------------------------------

u <- "https://www.flamengo.com.br/titulosdoflamengo"
r <- httr::GET(u)

ul <- r %>%
  rvest::read_html() %>%
  rvest::html_elements(xpath = "//ul[not(@*)]") %>%
  magrittr::extract(-1)

primeiro_titulo <- ul[[1]] %>%
  rvest::html_element(xpath = ".//preceding-sibling::span") %>%
  rvest::html_text()

outros_titulos <- ul %>%
  rvest::html_elements(xpath = ".//preceding-sibling::p/span") %>%
  rvest::html_text()


parse_ul <- function(ul_one, titulo) {
  ul_one %>%
    rvest::html_elements(xpath = ".//li") %>%
    rvest::html_text() %>%
    tibble::enframe() %>%
    dplyr::mutate(titulo = titulo, .before = 1)
}

todos_titulos <- c(primeiro_titulo, outros_titulos)

dados_brutos <- purrr::map2_dfr(ul, todos_titulos, parse_ul)

dados_flamengo <- dados_brutos %>%
  tidyr::separate(value, c("campeonato", "anos"), sep = " - ", extra = "merge") %>%
  dplyr::mutate(anos = stringr::str_split(anos, ", | e |o\\) |\\), ")) %>%
  tidyr::unnest(anos) %>%
  dplyr::mutate(invicto = stringr::str_detect(anos, "invict")) %>%
  dplyr::mutate(anos = as.numeric(stringr::str_extract(anos, "(19|20)[0-9]{2}")))


# "<html><p>texto</p><br><p>texto</p></html>" %>%
#   rvest::read_html() %>%
#   xml2::xml_find_all("//p") %>%
#   xml2::xml_contents() %>%
#   xml2::xml_text()


# Tidy -------------------------------------------------------------------------

# Visualize --------------------------------------------------------------------
library(ggplot2)

dados_modelo <- dados_flamengo %>%
  dplyr::mutate(titulo = dplyr::case_when(
    stringr::str_detect(titulo, "INTERNACIO") ~ "INTERNACIONAL",
    TRUE ~ titulo
  )) %>%
  dplyr::filter(anos >= 1950) %>%
  dplyr::mutate(ganhou = 1) %>%
  tidyr::complete(
    anos = tidyr::full_seq(anos, 1),
    fill = list(ganhou = 0)
  ) %>%
  dplyr::arrange(dplyr::desc(ganhou)) %>%
  dplyr::distinct(anos, .keep_all = TRUE)

m <- mgcv::gam(
  ganhou ~ s(anos), family = "binomial",
  data = dados_modelo
)

plot(m, trans = binomial()$linkinv)

dados_modelo %>%
  dplyr::count(titulo, anos) %>%
  dplyr::group_by(titulo) %>%
  dplyr::mutate(acu = cumsum(n)) %>%
  dplyr::ungroup() %>%
  ggplot(aes(anos, acu)) +
  geom_step() +
  facet_wrap(~titulo) +
  theme_bw() +
  theme(panel.border = element_blank())


dados_modelo %>%
  ggplot(aes(anos, ganhou)) +
  geom_point() +
  geom_smooth(
    method = mgcv::gam, formula = y ~ s(x),
    method.args	= list(family = "binomial")
  )

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
