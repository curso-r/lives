# Extensões de ggplot2 -----------------------------------------------------

# O que é uma extensão de ggplot2?

# um pacote que não está nos imports do ggplot2 e que realça o funcionamento
# dele

# scales, grid, gtable, glue são pacotes legais para usar junto ao ggplot2,
# mas são imports do pacote


# conexões--------------------------------------------------------------------

library(tidyverse)
library(bigrquery)

conexao_ideb <- dbConnect(
  bigrquery::bigquery(),
  project = "basedosdados",
  dataset = "br_inep_ideb",
  billing = "plumber-teste-1"
)

conexao_covid <- dbConnect(
  bigrquery::bigquery(),
  project = "basedosdados",
  dataset = "br_ms_vacinacao_covid19",
  billing = "plumber-teste-1"
)

conexao_populacao <- dbConnect(
  bigrquery::bigquery(),
  project = "basedosdados",
  dataset = "br_ibge_populacao",
  billing = "plumber-teste-1"
)


# ctrl shift R ------------------------------------------------------------


# ggridges -----------------------------------------------------------------

escola <- tbl(conexao_ideb, "escola") %>%
  group_by(ano, estado_abrev, municipio) %>%
  summarise(ideb = mean(ideb, na.rm = TRUE),
            saeb_matematica = mean(nota_saeb_matematica, na.rm = TRUE),
            saeb_portugues = mean(nota_saeb_lingua_portuguesa, na.rm = TRUE)
            ) %>%
  ungroup() %>%
  collect()


escola %>%
  mutate(
    estado_abrev = fct_reorder(estado_abrev, ideb, .fun = median, na.rm = TRUE)
  ) %>%
  ggplot(aes(x = ideb, y = estado_abrev, fill = estado_abrev)) +
  ggridges::geom_density_ridges(color = 'transparent', alpha = .6) +
  scale_fill_viridis_d(option = "A", begin = .2, end = .8) +
  labs(
    x = "IDEB",
    y = "Estado"
  ) +
  theme(
    legend.position = 'none',axis.text = element_text(size = 4)
    ) +
  geom_vline(xintercept = 4)

# gganimate ---------------------------------------------------------------

# https://ugoproto.github.io/ugo_r_doc/pdf/gganimate.pdf

ggplot2::theme_set(theme_minimal())

vacinacao_base <- tbl(conexao_covid, "microdados_vacinacao") %>%
  count(sigla_uf, data_aplicacao, dose) %>%
  collect() %>%
  mutate(
    data_aplicacao = as.Date(data_aplicacao)
  )

populacao_estados <- tbl(conexao_populacao, "municipios") %>%
  filter(ano == 2020) %>%
  collect() %>%
  mutate(
    id_estado = str_sub(id_municipio, 1, 2),
    sigla_uf = case_when(
      id_estado == "12" ~ "AC",
      id_estado == "27" ~ "AL",
      id_estado == "16" ~ "AP",
      id_estado == "13" ~ "AM",
      id_estado == "29" ~ "BA",
      id_estado == "53" ~ "DF",
      id_estado == "23" ~ "CE",
      id_estado == "32" ~ "ES",
      id_estado == "52" ~ "GO",
      id_estado == "21" ~ "MA",
      id_estado == "51" ~ "MT",
      id_estado == "50" ~ "MS",
      id_estado == "31" ~ "MG",
      id_estado == "15" ~ "PA",
      id_estado == "25" ~ "PB",
      id_estado == "41" ~ "PR",
      id_estado == "26" ~ "PE",
      id_estado == "22" ~ "PI",
      id_estado == "33" ~ "RJ",
      id_estado == "24" ~ "RN",
      id_estado == "43" ~ "RS",
      id_estado == "11" ~ "RO",
      id_estado == "14" ~ "RR",
      id_estado == "42" ~ "SC",
      id_estado == "35" ~ "SP",
      id_estado == "28" ~ "SE",
      id_estado == "17" ~ "TO"
    )
  ) %>%
  group_by(sigla_uf) %>%
  summarise(
    populacao = sum(populacao)
  )

vacinacao_base_por_estado <- vacinacao_base %>%
  ungroup() %>%
  mutate(
    regiao = case_when(
      sigla_uf %in% c("SP", "RJ", "MG", "ES") ~ "Sudeste",
      sigla_uf %in% c("SC", "PR", "RS") ~ "Sul",
      sigla_uf %in% c("MT", "DF", "GO", "MS") ~ "Centro-Oeste",
      sigla_uf %in% c("AC", "AM", "RO", "RR", "PA", "AP", "TO") ~ "Norte",
      TRUE ~ "Nordeste"
    )
  ) %>%
  filter(dose == "2") %>%
  group_by(regiao, sigla_uf) %>%
  arrange(regiao, sigla_uf, data_aplicacao) %>%
  mutate(
    n_acum = cumsum(n),
  ) %>%
  filter(data_aplicacao >= as.Date("2021-01-01")) %>%
  left_join(
    populacao_estados
  ) %>%
  mutate(
    percentual_vacinado = n_acum/populacao
  )

populacao_regiao <- vacinacao_base_por_estado %>%
  group_by(regiao) %>%
  summarise(
    populacao = sum(unique(populacao))
  )

vacinacao_base_por_regiao <-  vacinacao_base %>%
  ungroup() %>%
  mutate(
    regiao = case_when(
      sigla_uf %in% c("SP", "RJ", "MG", "ES") ~ "Sudeste",
      sigla_uf %in% c("SC", "PR", "RS") ~ "Sul",
      sigla_uf %in% c("MT", "DF", "GO", "MS") ~ "Centro-Oeste",
      sigla_uf %in% c("AC", "AM", "RO", "RR", "PA", "AP", "TO") ~ "Norte",
      TRUE ~ "Nordeste"
    )
  ) %>%
  filter(dose == "2") %>%
  group_by(regiao, data_aplicacao) %>%
  summarise(
    n = sum(n)
  ) %>%
  group_by(regiao) %>%
  arrange(regiao, data_aplicacao) %>%
  mutate(
    n_acum = cumsum(n),
  ) %>%
  filter(data_aplicacao >= as.Date("2021-02-01")) %>%
  left_join(
    populacao_regiao
  ) %>%
  mutate(
    percentual_vacinado = n_acum/populacao
  )

library(gganimate)

grafico_por_estado <- vacinacao_base_por_estado %>%
  ungroup() %>%
  arrange(data_aplicacao) %>%
  #mutate(data_aplicacao = as.numeric(data_aplicacao)) %>%
  ggplot(aes(x = data_aplicacao, y = percentual_vacinado, color = sigla_uf)) +
  geom_line() +
  transition_reveal(data_aplicacao) +
  facet_wrap(~regiao) +
  scale_color_viridis_d() +
  theme_bw()

grafico_por_regiao <- vacinacao_base_por_regiao %>%
  # filter(regiao %in% c("Sudeste", "Sul")) %>%
  ungroup() %>%
  arrange(data_aplicacao) %>%
  ggplot(aes(x = data_aplicacao, y = percentual_vacinado, color = regiao)) +
  geom_point(size = 6) +
  geom_line() +
  scale_color_viridis_d() +
  theme_bw(20) +
  transition_reveal(data_aplicacao) + # <<<
  # shadow_wake(wake_length = 0.5, size = 3) +  # <<<
  ease_aes("cubic-in") +  # <<<
  labs(x = "Data de referência", "% da população vacinado com a 2a dose")

animate(grafico_por_regiao, height = 600, width =800,end_pause = 10)

anim_save("animacao.gif", animation = grafico_por_regiao, height = 600, width =800)




iris %>%
  ggplot(aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point() +
  transition_states(Species)





# gganimate - exemplo do overfiting ---------------------------------------

library(purrr)
library(broom)
library(tidyverse)
library(gganimate)

set.seed(1)
theme_set(theme_minimal(20))

criar_amostra <- function(n) {
  tibble(
    x = runif(n, 0, 20),
    y = 500 + 0.4 * (x-10)^3 + rnorm(n, sd = 50)
  )
}

df_treino <- criar_amostra(10)
df_teste <- criar_amostra(10)

ggplot(df_treino, aes(x = x, y = y)) +
  geom_point()

ajusta_polinomio <- function(p, data) {
  lm(as.formula(paste0("y ~ poly(x, ", p, ")")), data = data)
}

grid_x <- tibble(x = seq(min(df_treino$x), max(df_treino$x),length.out = 500))

polinomios <- tibble(
  grau = 1:9
) %>%
  mutate(
    modelo_polinomial = map(grau, ajusta_polinomio, data = df_treino),
    dados_grafico = map(modelo_polinomial, ~ {
      grid_x %>% mutate(y = predict(.x, newdata = .))
    })
  ) %>%
  select(grau, dados_grafico) %>%
  unnest("dados_grafico")

gif <- polinomios %>%
  ggplot(aes(x = x, y = y)) +
  geom_line(show.legend = FALSE, colour = "purple", size = 1) +
  geom_point(aes( colour = "TREINO"), data = df_treino, size = 4) +
  geom_point(aes( colour = "TESTE"), data = df_teste, size = 3) +
  coord_cartesian(ylim = (c(-200,1300))) +
  labs(colour = "") +
  labs(title = 'Grau do polinômio: {closest_state}') +
  transition_states(grau,
                    transition_length = 2,
                    state_length = 2,
                    wrap = TRUE)

animate(gif, height = 400, width =650)
gganimate::save_animation(gganimate::last_animation(), file = "overfiting.gif")









# patchwork + grid --------------------------------------------------------

library(patchwork)
library(ggplot2)
library(magrittr)
library(tvthemes)
theme_set(tvthemes::theme_brooklyn99())

# primeiro grafico
g1 <- dados::pinguins %>%
  ggplot(aes(x = comprimento_bico, y = profundidade_bico)) +
  geom_point(colour = "orange")

# segundo grafico
g2 <- dados::pinguins %>%
  ggplot(aes(x = profundidade_bico)) +
  geom_density(colour = "white")

# terceiro grafico
g3 <- dados::pinguins %>%
  ggplot(aes(x = comprimento_bico)) +
  geom_density()

# codigo usando o pacote patchwork
# aqui usamos esse operador '+' (que também poderia ser `|`), que fica disponível
# quando carregamos o pacote
g1 | g2 | g3 | g1 | g2 | g3

# codigo usando o pacote patchwork
# aqui usamos esse operador '/', que fica disponível
# quando carregamos o pacote
g1 / g2 / g3

# codigo usando o pacote patchwork
# aqui usamos esse operador '/', que fica disponível
# quando carregamos o pacote
(g1 + g2) / g3

# exemplo mais maluco, podemos misturar quantos gráficos a gente quiser e do jeito que a gente quiser:
(g1+((g1 + g2) / g3))/g3

# Exemplo com gráfico
# primeira linha
(g1 + grid::textGrob("Todos os gráficos indicam que está\nrolando uma parad bi-modal."))/
  # segunda linha
  (g2+g3)

tabela <- dados::pinguins %>%
  dplyr::summarise(
    comprimento_bico = mean(comprimento_bico, na.rm = TRUE),
    profundidade_bico = mean(profundidade_bico, na.rm = TRUE)
  ) %>%
  tidyr::pivot_longer(dplyr::everything(), names_to = "Variável", values_to = "Média")

# Exemplo com tabela
# primeira linha
(g1 + gridExtra::tableGrob(tabela, rows = c("", "")))/
  # segunda linha
  (g2+g3)

((
  # gráfico
  ((g2 / g3) | g1) +  plot_layout(widths = c(1, 2))
) +
    #
    plot_annotation(
      title = "Comparação entre os a profundidade e o comprimento dos bicos",
      subtitle = "Os  graficos indicam a presença de uma distribuição bimodal, possivelmente porque existem várias espécies na base.",
      caption = "Fonte: github.com/cienciadedatos/dados"
    )) &
  # trocando os temas para branco. o operador `&` garante que o tema será aplicado
  # a todos os sub-plots
  theme_bw()

# ggfortify ---------------------------------------------------------------

# https://github.com/sinhrks/ggfortify

library(ggfortify)
theme_set(theme_minimal())

ctl <- c(4.17,5.58,5.18,6.11,4.50,4.61,5.17,4.53,5.33,5.14)
trt <- c(4.81,4.17,4.41,3.59,5.87,3.83,6.03,4.89,4.32,4.69)
group <- gl(2, 10, 20, labels = c("Ctl","Trt"))
weight <- c(ctl, trt)
lm.D9 <- lm(weight ~ group)

# Exemplo modelo linear
autoplot(lm.D9)
plot(lm.D9)

# Exemplo ACF
autoplot(acf(lh)) +
  geom_hline(yintercept = 0, colour = "red", size = 2)

library(survival)
a <- autoplot(survfit( Surv(futime, fustat)~1, data=ovarian)) +
  geom_point(colour = "red")

library(cowplot)
b <- add_sub(a, expression(paste(a^2+b^2, " = ", c^2)))
ggdraw(b)
b2 <- b
ggdraw(b)

a <- ggplot(iris, aes(x = Sepal.Length, y = Petal.Length)) +
  geom_point()

a +
  cowplot::draw_label(label = expression(paste(a^2+b^2, " = ", c^2)), x = 6, y = 4, colour = "red", size = 100)


# especificamente sobre modelos de sobrevivencia, tambem existe o survminer

# gghighlight -------------------------------------------------------------
library(gghighlight)

diamonds %>%
  filter()

diamonds %>%
  ggplot(aes(x = carat, y = price)) +
  geom_point() +
  gghighlight(carat > 4 | price > 18000, label_key = cut) +
  cowplot::theme_minimal_grid()

d <- cranlogs::cran_downloads(
  packages = tidyverse::tidyverse_deps()$package,
  from = "2019-01-01", to = "2019-12-31"
) %>%
  mutate(
    grupo = case_when(
      package %in% c("broom", "magrittr") ~ "grupo 1",
      TRUE ~ "grupo 2"
    )
  )

diamonds %>%
  group_by() %>%
  filter()

d %>%
  ggplot(aes(x = date, y = count, group = package)) +
  geom_line() +
  gghighlight::gghighlight(max(count) > 5000)

# ggrepel -----------------------------------------------------------------

library(ggrepel)
ggrepel::
escola %>%
  filter(ano == "2019", estado_abrev == "SP") %>%
  ggplot(aes(x = saeb_matematica, y = saeb_portugues, label = municipio)) +
  geom_point() +
  # feio
  # geom_text() +
  # bonito
  geom_label_repel(max.overlaps = 10) +
  theme_minimal(15)

# esquisse ----------------------------------------------------------------

esquisse::esquisser()
# or with your data:
esquisse::esquisser(dados::pinguins)

# ggedit ------------------------------------------------------------------

library('ggedit')
library(ggplot2)
p <- ggplot(mtcars, aes(x = hp, y = wt)) +
  geom_point() +
  geom_smooth() +
  theme_minimal()

p2 <- ggedit(p)

names(p2) # will show you which objects are available.
plot(p2)


windowsFonts()
library(extrafont)
extrafont::loadfonts(device = "win")
windows()
extrafont::fonts()
p + theme(text = element_text(family = "serif"))
p + theme(text = element_text(family = "mono", size = 25))



# ggside + ggdendro -------------------------------------------------------
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
