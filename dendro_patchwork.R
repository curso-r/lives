library(tidyverse)
library(ggside)
library(ggdendro)
library(dendsort)

model <- hclust(dist(t(mtcars)), "single")
dendro <- as.dendrogram(model)
dendro <- dendsort(dendro)

p2 <- ggdendrogram(dendro) + theme_void()
p1 <- mtcars[,order.dendrogram(dendro)] %>%
  rownames_to_column() %>%
  pivot_longer(-rowname) %>%
  mutate(
    name = fct_inorder(name)
  ) %>%
  group_by(name) %>%
  mutate(
    value = (value - mean(value))/sd(value)
  ) %>%
  ggplot() +
  geom_tile(aes(x = name, y = rowname, fill = value))

library(patchwork)
p2/p1
