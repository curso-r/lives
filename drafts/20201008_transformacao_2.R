#' Author:
#' Subject:

# Import -----------------------------------------------------------------------

da_contratos <- feather::read_feather("data-raw/contratos_covid.feather")



# contratos covid ---------------------------------------------------------



da_contratos$valor <- gsub(
  "R\\$ ?|\\.|Zero|US\\$ ", "",
  da_contratos$valor_total_contrato
)

da_contratos$valor[length(da_contratos$valor)] <- "57000000,00"

da_contratos$valor <- gsub(
  ",", ".",
  da_contratos$valor
)
da_contratos$valor <- as.numeric(da_contratos$valor)

# attach() NUNCA

da_contratos$mes <- with(da_contratos, ifelse(
  grepl("/08/", prazo_180_dias), "agosto",
  ifelse(grepl("/09/|/set/", prazo_180_dias),
         "setembro",
         ifelse(grepl("/10/|/out/", prazo_180_dias),
                "outubro",
                "novembro"))
))

d1 <- aggregate(valor ~ mes, data = da_contratos, FUN = length)
d2 <- aggregate(valor ~ mes, data = da_contratos, FUN = sum)

d2$valor <- paste("R$", format(d2$valor, big.mark = ".",
                   decimal.mark = ","))
knitr::kable(cbind(d1, d2[,-1]))


# idhm --------------------------------------------------------------------

idhm <- feather::read_feather("data-raw/idhm.feather")
idhm <- idhm[idhm$ufn == "Rio Grande do Sul", ]

varas <- feather::read_feather("data-raw/varas.feather")
varas$uf <- sapply(strsplit(varas$municipio_uf, " - "), function(x) x[2])
varas <- varas[varas$uf == "RS", ]
varas$muni <- sapply(strsplit(varas$municipio_uf, " - "), function(x) x[1])
varas$muni <- toupper(varas$muni)
varas_agg <- aggregate(cod ~ muni, FUN = length, data = varas)


## idhm$municipio[grepl("LIVRAM", idhm$municipio)]
idhm$municipio <- ifelse(idhm$municipio == "MAÇAMBARÁ", "MAÇAMBARA",
                         idhm$municipio)
idhm$municipio <- ifelse(idhm$municipio == "SANT'ANA DO LIVRAMENTO",
                         "SANTANA DO LIVRAMENTO",
                         idhm$municipio)

merged <- merge(varas_agg, idhm, by.x = "muni", by.y = "municipio")
merged <- merged[, c("muni", "codmun6", "cod", "idhm")]
knitr::kable(head(merged[order(merged$cod, decreasing = TRUE), ], 10))


