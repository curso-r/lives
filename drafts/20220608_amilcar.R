# carregando pacotes ------------------------------------------------------

library(ggplot2)
library(gganimate)

# importando dados --------------------------------------------------------

edges_df <- readr::read_csv("https://raw.githubusercontent.com/amilcar-pg/dia_a_dia_amigos/master/output/edges_df.csv")
nodes_df <- readr::read_csv("https://raw.githubusercontent.com/amilcar-pg/dia_a_dia_amigos/master/output/nodes_df.csv")



# vamo tentar -------------------------------------------------------------

nodes_df |>
  dplyr::filter(name == "amilcar") |>
  ggplot(aes(x, y)) +
  geom_point()

posicoes_gerais <- nodes_df |>
  dplyr::filter(atividade) |>
  dplyr::group_by(name) |>
  dplyr::summarise(
    x = median(x),
    y = median(y)
  )

anim <- edges_df |>
  dplyr::anti_join(posicoes_gerais, c("from" = "name")) |>
  ggplot(aes(x, y)) +
  geom_text(aes(label = from)) +
  geom_label(
    aes(label = name),
    data = posicoes_gerais
  ) +
  labs(title = labs(title = 'Hora: {closest_state}')) +
  transition_states(frame_time) +
  theme_void()


animate(anim, nframes = 192)

# plotando ----------------------------------------------------------------

p <- ggplot() +
  geom_segment(
    data = edges_df,
    aes(x = x, xend = xend, y = y, yend = yend, group = id, alpha = status),
    show.legend = FALSE
  ) +
  geom_point(
    data = nodes_df, aes(x, y, group = name, fill = as.factor(atividade)),
    shape = 21, size = 6, show.legend = FALSE
  ) +
  scale_alpha_manual(values = c(0, 1))

# animando ----------------------------------------------------------------

# o título aparece o horário errado.
p +
  labs(title = labs(title = 'Hora: {stringr::str_sub(frame_time, 12, 16)}')) +
  transition_time(frame_time) +
  theme_void()

# funciona certinho, com o índice certinho, mas não tem como colocar o título.
p +
  labs(title = labs(title = 'Hora: {frame_time}')) +
  transition_time(frame) +

p +
  labs(title = labs(title = 'Hora: {stringr::str_sub(frame_time, 12, 16)}')) +
  transition_time(frame_time) +
  theme_void()


# arrumar as labels -------------------------------------------------------

# edges_df$frame_time |>
#

edges_df <- edges_df |>
  dplyr::mutate(
    frame_time_cat = format(frame_time, "%H:%M")
  )

p <- ggplot() +
  geom_segment(
    data = edges_df,
    aes(x = x, xend = xend, y = y, yend = yend, group = id, alpha = status),
    show.legend = FALSE
  ) +
  geom_point(
    data = nodes_df, aes(x, y, group = name, fill = as.factor(atividade)),
    shape = 21, size = 6, show.legend = FALSE
  ) +
  scale_alpha_manual(values = c(0, 1))

p +
  labs(title = labs(title = 'Hora: {closest_state}')) +
  transition_states(frame_time_cat) +
  theme_void()



anim <- p +
  labs(title = labs(title = 'Hora: {stringr::str_sub(closest_state, 12, 16)}')) +
  transition_states(frame_time) + # usei o closest_state do transition_states
  theme_void()

# por algum motivo, precisei colocar o
# dobro de frames do que o número de frames
# distintos da base (96)
animate(anim, nframes = 192)



