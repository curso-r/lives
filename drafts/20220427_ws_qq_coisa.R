
baixar_pagina_capes <- function(pag) {
  usethis::ui_info("Baixando página {pag}")
  u <- "https://catalogodeteses.capes.gov.br/catalogo-teses/rest/busca"

  # body <- '{"termo":"","filtros":[],"pagina":1,"registrosPorPagina":20}'

  body <- list(
    termo = "",
    filtros = list(
      list(
        campo = "Ano",
        valor = "2020"
      )
    ),
    pagina = pag,
    registrosPorPagina = 20
  )

  r <- httr::POST(
    u,
    body = body,
    httr::accept("application/json, text/plain, */*"),
    # httr::accept_json(),
    encode = "json"
  )

  httr::content(r, simplifyDataFrame = TRUE) |>
    purrr::pluck("tesesDissertacoes") |>
    tibble::as_tibble()
}

vetor_paginas <- sample(1:1000, 30)

dados_capes <- vetor_paginas |>
  purrr::map_dfr(baixar_pagina_capes, .id = "pagina")

dados_capes |>
  janitor::get_dupes(id)

library(ggplot2)
library(ggridges)

# with()
# sprintf()
# basename()
# tools::file_path_sans_ext()
# message()
# grepl()
# names()
# nchar()
#
#
# all()
# any()

dados_capes |>
  dplyr::mutate(
    paginas = as.numeric(paginas),
    nomePrograma = forcats::fct_lump_n(
      nomePrograma, 20
    ),
    nomePrograma = forcats::fct_reorder(
      nomePrograma, paginas
    )
  ) |>
  ggplot() +
  aes(x = paginas, y = nomePrograma) +
  ggridges::geom_density_ridges(
    fill = "royalblue", alpha = .6
  ) +
  theme_minimal()

dados_capes |>
  dplyr::count(grauAcademico)

unique(munifacil::depara_muni_codigo()$uf_join)

com_ibge <- dados_capes |>
  dplyr::count(municipioPrograma, sort = TRUE) |>
  dplyr::mutate(uf = "AC") |>
  tidyr::complete(
    municipioPrograma,
    uf = unique(munifacil::depara_muni_codigo()$uf_join)
  ) |>
  dplyr::arrange(municipioPrograma) |>
  tidyr::fill(n) |>
  munifacil::limpar_colunas(
    col_muni = municipioPrograma,
    col_uf = uf
  ) |>
  munifacil::incluir_codigo_ibge() |>
  dplyr::filter(!is.na(id_municipio))

dados_mapa <- geobr::read_state()

com_ibge |>
  dplyr::inner_join(
    abjData::muni,
    c("id_municipio" = "muni_id")
  ) |>
  ggplot() +
  geom_sf(data = dados_mapa) +
  geom_point(aes(lon, lat, size = n)) +
  coord_sf() +
  tvthemes::theme_spongeBob(
    text.font = "Some Time Later"
  ) +
  labs(
    # title = element_text(family = "Pokemon Hollow")#,
    title = "Duas horas depois..."
  ) +
  theme(
    text = element_text(family = "Pokemon Hollow")
  )

## install.packages("extrafont")
extrafont::font_import(
  "pasta/onde/estao/arquivos/ttf/",
  prompt = FALSE
)
extrafont::loadfonts("win")


# +
#   coord_cartesian(xlim = c(0, 500))

