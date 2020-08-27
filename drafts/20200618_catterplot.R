#' Author: Julio Trecenti
#' Subject:

# library(tidyverse)
library(magrittr)
library(CatterPlots)
library(ggplot2)

# Import -----------------------------------------------------------------------
x <- -10:10
y <- -x^2 + 10
rainbowCats(x, y, yspread=0.05, xspread=0.05, ptsize=2, catshiftx=0.5, catshifty=-0.2, canvas=c(-0.5,1.5,-1,1.5))

png::writePNG(x[[1]]/max(x[[1]]), target = "teste.png")

palmerpenguins::penguins %>%
  mutate(img = "teste.png") %>%
  ggplot(aes(bill_length_mm, bill_depth_mm)) +
  ggimage::geom_image(aes(image = img), size = 0.03)


# Tidy -------------------------------------------------------------------------

# Visualize --------------------------------------------------------------------

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
