#' Author: Athos
#' Subject: gtsummary

library(tidyverse)
library(magrittr)

# Import -----------------------------------------------------------------------
library(gtsummary)
theme_gtsummary_language("pt")

trial %>%
  select(trt, response) %>%
  gtsummary::tbl_summary(by = trt) %>%
  gtsummary::add_p()

trial %>%
  pivot_longer(where(is.numeric)) %>%
  ggplot(aes(x = value)) +
  facet_wrap(~name, scale = "free_x") +
  geom_histogram()

modelinho <- survival::coxph(survival::Surv(marker, event = death) ~ stage, data = trial)

modelinho %>% tbl_regression(exponentiate = TRUE)
modelinho %>% tbl_regression(exponentiate = FALSE)

remotes::install_github("cienciadedatos/dados")
iqr <- function(x) { mean(x)}
library(dados)
pinguins %>%
  select(massa_corporal, especies, ilha) %>%
  gtsummary::tbl_summary(by = all_categorical(), statistic = list(all_continuous() ~ "{mean} ({sd}) ({iqr})"))


pinguins %>%
  select(massa_corporal, especies) %>%
  group_by(especies) %>%
  summarise(
    media = mean(massa_corporal, na.rm = TRUE),
    median = median(massa_corporal, na.rm = TRUE)
  )

pinguins %>%
  lm(massa_corporal ~ ilha + especies, data = .) %>%
  gtsummary::tbl_regression()

pinguins %>%
  lm(massa_corporal ~ ilha + especies, data = .) %>%
  summary()
# Tidy -------------------------------------------------------------------------

# Visualize --------------------------------------------------------------------

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
