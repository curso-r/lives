# parte 1 NSE -------------------------------------------------------------

mtcars %>%
  summarise(soma = sum(cyl ^ 2))

mtcars %>%
  summarise(cyl = sum(mtcars$cyl ^ 2))

mtcars %>%
  mutate(cyl = sum(mtcars[["cyl"]] ^ 2))

# seria muito bom poder fazer isso:

minha_fn <- function(dados, variavel) {
  dados %>%
    summarise(nova_variavel = sum(variavel ^ 2))
}

mtcars %>%
  minha_fn(cyl)


# jeito certo -------------------------------------------------------------

minha_fn_sem_aspas <- function(dados, variavel) {
  dados %>%
    summarise(nova_variavel = sum({{variavel}} ^ 2))
}

mtcars %>%
  minha_fn_sem_aspas(cyl)

minha_fn_com_aspas <- function(dados, variavel) {
  dados %>%
    summarise(nova_variavel = sum(.data[[variavel]] ^ 2))
}

mtcars %>%
  minha_fn_com_aspas("cyl")

# . vs .data

mtcars %>%
  group_by(cyl) %>%
  summarise(nova_variavel = sum(.data[["cyl"]] ^ 2))

mtcars %>%
  group_by(cyl) %>%
  summarise(nova_variavel = sum(.[["cyl"]] ^ 2))

# no novo pipe o segundo caso nem funciona mais!

mtcars |>
  group_by(cyl) |>
  summarise(nova_variavel = sum(.[["cyl"]] ^ 2))

# passando o nome da coluna nova em uma variavel --------------------------

minha_fn_sem_aspas_novo_nome <- function(dados, variavel, nome) {
  dados %>%
    summarise({{nome}} := sum({{variavel}} ^ 2))
}

# de quebra funciona com aspas tb

mtcars %>%
  minha_fn_sem_aspas_novo_nome(cyl, "novo_nome")

# parte 2 rlang -----------------------------------------------------------

# como a mágica funciona? -------------------------------------------------

mtcars %>%
  summarise(soma = sum(mpg))

# é a mesma coisa que

soma = sum(mtcars$mpg)

# como o R lida com expressões (AST)

library(lobstr)

ast(expr(soma = sum(mpg)))

ast(mtcars %>%
      summarise(soma = sum(mpg)))

paste("Good", "morning", "Hadley")

library(rlang)

cement <- function(...) {
  args <- enexprs(...)
  paste(purrr::map(args, as_string), collapse = " ")
}

cement(Good, morning, Hadley)
#> [1] "Good morning Hadley"
cement(Good, afternoon, Alice)
#> [1] "Good afternoon Alice"

debug(cement)

cement(Good, afternoon, Alice)

# montar várias fórmulas

# v1
# v1 + v2
# v1 + v2 + v3 + ...

variaveis <- names(mtcars)

# remove o mtcars
variaveis <- variaveis[-1]

lista_de_modelos <- purrr::accumulate(syms(variaveis), ~expr(!!.x+!!.y))

lista_de_modelos

lista_de_modelos_final <- lista_de_modelos %>%
  purrr::map(~expr(mpg~!!.x))

lista_de_modelos_final

# ajustando um modelo

lm(lista_de_modelos_final[[6]], data = mtcars)

# ajustando vários modelos

modelos_ajustados <- purrr::map(lista_de_modelos_final, ~lm(.x, data = mtcars))


