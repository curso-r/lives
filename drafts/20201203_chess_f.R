#' Author: Fernando
#' Subject: XADREZ PORRA

# devtools::install_github("curso-r/chess")
# library(tidyverse)

# install.packages("rsvg")
# chess::install_chess()
library(chess)

chess::can_claim_draw()

# Import -----------------------------------------------------------------------

# Read first game from My 60 Memorable Games
file <- system.file("m60mg.pgn", package = "chess")
fischer_sherwin <- read_game(file, n_max = 1)

plot(fischer_sherwin)

for(i in 1:20){
fischer_sherwin %>%
  forward(63)
  plot()
}

# Tidy -------------------------------------------------------------------------

# Visualize --------------------------------------------------------------------

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
