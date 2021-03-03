#' Author:
#' Subject:

# library(tidyverse)
library(magrittr)

# Import -----------------------------------------------------------------------

da_sabesp <- feather::read_feather("data-raw/sabesp.feather")
da_sabesp$prec_hist <- as.numeric(gsub(",", ".", da_sabesp$prec_hist))
da_sabesp$mes <- sapply(
  strsplit(da_sabesp$dia, "-"), function(x) x[2]
)
da_sabesp$mes <- ifelse(da_sabesp$mes == "06", "junho", "julho")

medias <- aggregate(
  prec_hist ~ mes + nome,
  data = da_sabesp,
  FUN = mean
)
contagens <- aggregate(
  prec_hist ~ mes + nome,
  data = da_sabesp,
  FUN = length
)
result <- merge(medias, contagens, by = c("mes", "nome"))
names(result) <- c("nome", "mes", "media", "contagem")

resultado_final <- result[order(result$mes, decreasing = TRUE),]

# Tidy -------------------------------------------------------------------------

diamante <- dados::diamante

# feather::write_feather(diamante, "data-raw/diamante.feather")
# readr::write_csv(diamante, "data-raw/diamante.csv")

diamante <- diamante[diamante$preco > 2000,]

medias <- aggregate(
  quilate ~ corte + transparencia,
  data = diamante,
  FUN = mean
)

tabela <- reshape(
  medias,
  timevar = "corte",
  idvar = "transparencia",
  direction = "wide"
)

names(tabela) <- gsub("quilate\\.", "", names(tabela))

tabela <- tabela[order(tabela$Ideal, decreasing = TRUE),]


# Visualize --------------------------------------------------------------------

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
