library(magrittr)

tocar_som <- function(url) {
  url %>%
    httr::GET() %>%
    xml2::read_html() %>%
    xml2::xml_find_first("//*[@id='instant-page-button']") %>%
    xml2::xml_attr("onmousedown") %>%
    stringr::str_extract("/media[^']+") %>%
    paste0("https://www.myinstants.com", .) %>%
    stringr::str_replace("https", "http") %>%
    beepr::beep()
}
tiktok <- "https://www.myinstants.com/instant/tik-tok-india-5164/?utm_source=copy&utm_medium=share"
seinfield <- "https://www.myinstants.com/instant/funny-seinfeld/?utm_source=copy&utm_medium=share"
tocar_som("https://www.myinstants.com/instant/goat/?utm_source=copy&utm_medium=share")

