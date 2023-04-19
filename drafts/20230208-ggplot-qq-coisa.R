
resposta <- openai::create_completion(
  model = "text-davinci-003",
  prompt = "write the code to generate the Cyprus flag in ggplot2",
  max_tokens = 3000
)

resposta$choices$text |>
  cat()

library(patchwork)
library(ggplot2)

ggplot(data = mtcars,
       aes(x = wt, y = mpg)) +
  geom_point(aes(colour = factor(gear))) +
  scale_color_discrete(name = "Number of gears") +
  theme_bw() +
  labs(title = "Miles per gallon and Vehicle Weight") +
  labs(x = "Vehicle Weight (tons)", y = "Miles Per Gallon (mpg)")


# importando o pacote ggplot2
library(ggplot2)

# definindo as variáveis
x <- c(0, 0, 1, 1, 0)
y <- c(0, 1, 1, 0, 0)

# criando a figura
japao <- ggplot(data = NULL, aes(x, y)) +
  # geom_polygon(fill="red") +
  geom_polygon(data=data.frame(x=-x, y=y),fill="white") +
  geom_point(
    data = data.frame(x = -.5, y = .5), colour = "red",
    size = 50
  ) +
  ggtitle("Bandeira do Japão")

japao

## bandeira da líbia


library(ggplot2)

libia <- ggplot() +
  geom_rect(
    aes(xmin = -200, xmax = 200, ymin = 0, ymax = 75),
    fill = "green"
  ) +
  geom_rect(
    aes(xmin = -200, xmax = 200, ymin = 75, ymax = 225),
    fill = "black"
  ) +
  geom_rect(
    aes(xmin = -200, xmax = 200, ymin = 225, ymax = 300),
    fill = "red"
  ) +
  geom_point(
    aes(x = 0, y = 150), colour = "white", size = 40
  ) +
  geom_point(
    aes(x = 10, y = 150), colour = "black", size = 35
  ) +
  ggstar::geom_star(
    aes(x = 35, y = 150), colour = "white", size = 15,
    fill = "white", angle = 25
  ) +
  coord_fixed(ratio = 1)


library(ggplot2)
library(gridExtra)

Nepal_flag <- data.frame(x = c(-1,1,1,-1,-1,1,1,-1, -1,1,-1,-1,0,0),
                         y = c(1,1,0,0,-1,-1,-2,-2,2,2,1,1,2,-2))

p1 <- ggplot(Nepal_flag, aes(x, y)) +
  geom_polygon(fill = "sky blue")

p2 <- ggplot(Nepal_flag, aes(x, y)) +
  geom_polygon(fill = "red") +
  geom_polygon(fill = "white",
               data = data.frame(x = c(0, -0.25, 0.25, 0),
                                 y = c(1.5, 1, 1, 1.5)))


grid.arrange(p2, p1, nrow = 1)


# chipre (cyprus) ---------------------------------------------------------

library(sf)
library(rnaturalearth)
library(ggplot2)

chipre <- rnaturalearth::ne_countries(
  country = "cyprus",
  returnclass = "sf",
  scale = "large"
)
chipre_norte <- rnaturalearth::ne_countries(
  country = "Northern Cyprus",
  returnclass = "sf",
  scale = "large"
)

plot(chipre)

chipre_flag <- ggplot() +
  geom_rect(
    aes(xmin = 31.5,
        xmax = 35.3,
        ymin = 34,
        ymax = 36.1),
    fill = "white"
  ) +
  geom_sf(
    fill = "darkorange",
    data = chipre
  ) +
  geom_sf(
    fill = "darkorange",
    data = chipre_norte
  ) +
  geom_text(
    aes(x = 33.5,
        y = 34.5,
        label = "exercício"),
    size = 10,
    colour = "darkgreen"
  )

library(patchwork)
japao + libia + chipre_flag

# próximas ----------------------------------------------------------------

lista_paises <- dados::dados_gapminder |>
  dplyr::distinct(pais)

set.seed(42)

pais_que_vamos_fazer <- lista_paises |>
  dplyr::slice_sample(n = 1)

# GEPETO
result <- openai::create_chat_completion(
  "gpt-4",
  list(
    list(
      role = "system",
      content = "Você um robô que retorna códigos de ggplot2 a partir do que for pedido."
    ),
    list(
      role = "user",
      content = "Faça o mapa da badeira do país Gana com ggplot2."
    )
  )
)

result$choices$message.content |>
  cat()


# Crie um dataframe para as cores e proporções da bandeira
bandeira_ghana <- data.frame(
  cor = c("#cf0921", "#fcd20f", "#006b3d"),
  y = c(3, 2, 1)
)
# Crie outro dataframe para a estrela preta
estrela_ghana <- data.frame(
  x = 0.5,
  y = 1.5,
  cor = "black"
)
# Use ggplot2 para criar o gráfico da bandeira
gana <- ggplot() +
  # Adicione as barras coloridas
  geom_bar(
    data = bandeira_ghana,
    aes(x = 0.5, y = y, fill = cor),
    stat = "identity",
    position = "identity",
    width = 1
  ) +
  # Adicione a estrela preta
  # geom_point(
  #   data = estrela_ghana,
  #   aes(x = x, y = y, color = cor),
  #   size = 10,
  #   shape = 5
  # ) +
  ggstar::geom_star(
    aes(x = 0.5, y = 1.5),
    colour = "black",
    size = 30,
    fill = "black"
  ) +
  # Remova os eixos e defina o tema mínimo
  theme_void() +
  scale_fill_identity() +
  scale_color_identity() +
  # Defina os limites do gráfico
  coord_cartesian(
    xlim = c(0, 1),
    ylim = c(0, 3)
  )
gana

set.seed(42)

paises_que_vamos_fazer <- lista_paises |>
  dplyr::slice_sample(n = 10)


pais <- as.character(paises_que_vamos_fazer$pais[2])

faz_ggplot_gpt <- function(pais) {
  # GEPETO
  usethis::ui_info("bipbop...pensando...")
  result <- openai::create_chat_completion(
    "gpt-4",
    list(
      list(
        role = "system",
        content = paste(
          "Você um robô que retorna códigos de ggplot2 a partir do que for pedido.",
          "Retorne apenas o código e os comentários. Não precisa mostrar",
          "a parte de instalação de pacotes."
        )
      ),
      list(
        role = "user",
        content = glue::glue(
          "Faça o mapa da bandeira do país {pais} com ggplot2."
        )
      )
    )
  )
  result$choices$message.content
}

codigo <- faz_ggplot_gpt(pais)
cat(codigo)

# Carregando bibliotecas
library(ggplot2)

# Criando o conjunto de dados da bandeira italiana
italy_flag <- data.frame(
  y = c(1, 1, 1),
  x = c(1, 2, 3),
  fill = c("green", "white", "red")
)

# Plotando a bandeira italiana com ggplot2
italia <- ggplot(italy_flag, aes(x = x, y = y, fill = fill)) +
  geom_col(width = 1) +
  scale_fill_identity() +
  scale_x_continuous(expand = c(0, 0), breaks = NULL) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1), breaks = NULL) +
  theme_void()


result <- openai::create_chat_completion(
  "gpt-4",
  list(
    list(
      role = "system",
      content = paste(
        "Você um robô que retorna códigos de ggplot2 a partir do que for pedido.",
        "Retorne apenas o código e os comentários. Não precisa mostrar",
        "a parte de instalação de pacotes."
      )
    ),
    list(
      role = "user",
      content = glue::glue(
        "Faça um gráfico 3D em ggplot2."
      )
    )
  )
)
result$choices$message.content |> cat()


result_svg <- openai::create_chat_completion(
  "gpt-4",
  list(
    list(
      role = "system",
      content = paste(
        "Você um robô que retorna códigos de SVG a partir do que for pedido.",
        "Retorne apenas o código."
      )
    ),
    list(
      role = "user",
      content = glue::glue(
        "Escreva um código SVG com o símbolo que fica no centro da bandeira do Lesotho"
      )
    )
  )
)
result_svg


# # Carregar os pacotes necessários
# library(plotly)
# library(ggplot2)
#
# # Criar um conjunto de dados de exemplo
# set.seed(123)
# dados_exemplo <- data.frame(
#   x = rnorm(100),
#   y = rnorm(100),
#   z = rnorm(100)
# )
#
# # Crie um gráfico 3D com plotly
# p <- dados_exemplo %>%
#   plot_ly(x = ~x, y = ~y, z = ~z, type = "scatter3d", mode = "markers",
#           marker = list(size = 5, color = "red")) %>%
#   layout(scene = list(xaxis = list(title = "Eixo X"),
#                       yaxis = list(title = "Eixo Y"),
#                       zaxis = list(title = "Eixo Z")))
#
# # Exibir o gráfico 3D
# p


# "/Users/julio/OneDrive/Imagens/Capturas de tela/Captura de tela 2023-04-19 194201.png" |>
#   file.copy("drafts/lesotho.png")


# Crie um dataframe para as cores e proporções da bandeira
bandeira_lesoto <- data.frame(
  cor = c("#001489", "white", "#009a44"),
  y = c(3, 2, 1)
)
# Crie outro dataframe para a estrela preta
imagem_lesoto <- data.frame(
  x = 0.5,
  y = 1.5,
  image = "drafts/lesotho.png"
)
# Use ggplot2 para criar o gráfico da bandeira
lesoto <- ggplot() +
  # Adicione as barras coloridas
  geom_bar(
    data = bandeira_lesoto,
    aes(x = 0.5, y = y, fill = cor),
    stat = "identity",
    position = "identity",
    width = 1
  ) +
  ggimage::geom_image(
    aes(x = 0.5, y = 1.5, image = image),
    data = imagem_lesoto,
    size = .2,
    by = "height"
  ) +
  # Remova os eixos e defina o tema mínimo
  theme_void() +
  scale_fill_identity() +
  scale_color_identity() +
  # Defina os limites do gráfico
  coord_cartesian(
    xlim = c(0, 1),
    ylim = c(0, 3)
  ) +
  coord_equal(0.25)

lesoto


"/Users/julio/OneDrive/Imagens/Capturas de tela/Captura de tela 2023-04-19 195542.png" |>
  file.copy("drafts/essuatini.png")


# Crie um dataframe para as cores e proporções da bandeira
bandeira_essuatini <- data.frame(
  cor = c("#3e5eb9", "#ffd900", "#b10c0c", "#ffd900", "#3e5eb9"),
  y = c(3, 2.5, 2.35, 0.65, 0.5)
)
# Crie outro dataframe para a estrela preta
imagem_essuatini <- data.frame(
  x = 0.5,
  y = 1.5,
  image = "drafts/essuatini.png"
)
# Use ggplot2 para criar o gráfico da bandeira
essuatini <- ggplot() +
  # Adicione as barras coloridas
  geom_bar(
    data = bandeira_essuatini,
    aes(x = 0.5, y = y, fill = cor),
    stat = "identity",
    position = "identity",
    width = 1
  ) +
  ggimage::geom_image(
    aes(x = 0.5, y = 1.5, image = image),
    data = imagem_essuatini,
    size = .32,
    by = "height"
  ) +
  # Remova os eixos e defina o tema mínimo
  theme_void() +
  scale_fill_identity() +
  scale_color_identity() +
  # Defina os limites do gráfico
  coord_cartesian(
    xlim = c(0, 1),
    ylim = c(0, 3)
  ) +
  coord_equal(0.3)

essuatini

(gana + italia) / (lesoto + essuatini)

