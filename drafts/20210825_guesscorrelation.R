#' Author:
#' Subject:

# library(tidyverse)
library(magrittr)
library(RSelenium)

firefox <- rsDriver(browser = "firefox")

sess <- firefox$client

sess$navigate("http://guessthecorrelation.com")

el <- sess$findElement(
  "xpath",
  "//table[@class='menu-table']"
)

el$clickElement()
el$screenshot(display = TRUE)

# sess$sendKeysToActiveElement(list(value = "testejubsathos"))
# sess$switchToFrame(3)

# sess$getAlertText()

# preenche nosso usuario
sess$sendKeysToAlert("testejubsathos")
# aceita
sess$acceptAlert()
# aceita novamente
sess$acceptAlert()

# agora começa o jogo mesmo!!!
el$clickElement()

# achar o svg não rolou.....
# svg <- sess$findElement(
#   "xpath",
#   "//rect"
# )

library(torch)
modelo <- luz::luz_load("modelo_guess_the_correlation")
modelo <- torch::torch_load("modelo_sem_luz")

prever <- function() {
  imagem <- sess$screenshot()


  printscreen <- imagem[[1]] %>%
    base64enc::base64decode() %>%
    magick::image_read() %>%
    magick::image_crop("370x320+80+120")

  printscreen_torch <- printscreen %>%
    torchvision::transform_to_tensor() %>%
    torchvision::transform_rgb_to_grayscale() %>%
    torch::torch_unsqueeze(1) %>%
    torch::torch_unsqueeze(1)


  predicao <- modelo(printscreen_torch)
  predicao <- as.numeric(predicao)

}

for (ii in 1:10) {
  predicao <- prever()
  resposta <- sess$findElement("id", "guess-input")
  resposta$clickElement()
  resposta$clearElement()
  resposta$sendKeysToElement(
    list(as.character(abs(round(predicao, 4))))
  )

  enter <- RSelenium::selKeys$enter
  resposta$sendKeysToElement(list(enter))
  resposta$sendKeysToElement(list(enter))

}



# Import -----------------------------------------------------------------------

# Tidy -------------------------------------------------------------------------

# Visualize --------------------------------------------------------------------

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
