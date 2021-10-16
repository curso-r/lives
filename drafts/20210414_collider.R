#' Author: Julio Trecenti
#' Subject: Exemplo de collider

# https://rpubs.com/georgeberry/collider-bias

library(tidyverse)
set.seed(42)
N = 10000
# X and D cause Y
# X -> Y <- D

D = rnorm(N)
X = rnorm(N)
Y = 1/2 * D + 1/2 * X + rnorm(N)

df = data.frame(D = D, X = X, Y = Y) %>%
  sample_n(1000)

summary(lm(X ~ D, data = df))

collider_df = filter(df, Y > 1)
summary(lm(X ~ D, data = collider_df))




set.seed(1)
da <- purrr::cross_df(list(A = c(0,1),
                      B = c(0,1),
                      C = c(0,1),
                      D = c(0,1))) %>%
dplyr::mutate(p = runif(16), p = p/sum(p))


da %>%
  dplyr::filter(B == 0) %>%
  dplyr::mutate(p = p/sum(p)) %>%
  dplyr::filter(A == 1) %>%
  with(sum(p))

da %>%
  dplyr::filter(A == 1) %>%
  with(sum(p))


