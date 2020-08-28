#' Author:
#' Subject:

# library(tidyverse)
library(magrittr)

# Import -----------------------------------------------------------------------

rstereogram


demo_image <- png::readPNG("data-raw/cursor1-4131.png")

plot(as.raster(demo_image))

magick::image_read("data-raw/cursor1-413.png") %>%
  magick::image_quantize(colorspace = "gray")

library(rstereogram)
"data-raw/cursor1-413.png" %>%
  png::readPNG() %>%
  image_to_magiceye() %>%
  plot()

df <- data.frame(
  group = c("Dog", "Cat", "Mouse"),
  value = c(25, 30, 50)
)

library(ggplot2)

ggplot(df, aes(x="", y=value, fill=group))+
  geom_bar(width = 1, stat = "identity") +
  coord_polar(theta="y") -> pp

pp

pp %>%
  ggplot_to_magiceye(colors = c("#FF69B4", "#449999", "#010101")) %>%
  plot()

# Tidy -------------------------------------------------------------------------

# Visualize --------------------------------------------------------------------

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
