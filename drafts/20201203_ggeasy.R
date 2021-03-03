

install.packages("ggeasy")

library(ggplot2)
library(ggeasy)
# rotate y axis labels
ggplot(mtcars, aes(hp, mpg, colour = factor(am))) +
  geom_point() +
  easy_remove_legend(teach = TRUE)

library(tidyverse)
dados::arremesadores %>%
  tibble::as_tibble() %>%
  dplyr::select(fly.sacrificio = fly_sacrificio,
                jogos.ganhados = jogos_ganhados) %>%
  ggplot(aes(fly.sacrificio, jogos.ganhados)) +
  geom_point()




