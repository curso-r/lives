library(shiny)
library(dplyr)

imdb <- basesCursoR::pegar_base("imdb") |>
  tidyr::drop_na(data_lancamento, nota_imdb)

# pessoas <- stringr::str_split(c(imdb$elenco, imdb$direcao), pattern = ", ") |>
#   purrr::flatten_chr() |>
#   unique() |>
#   sort()

ui <- fluidPage(
  titlePanel("Recomendador de filmes"),
  br(),
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      textInput(
        "pessoa",
        label = "Escolha uma pessoa",
        value = "Xuxa"
      ),
      actionButton("recomendar", "Gerar recomendação"),
      hr(),
      downloadButton("gerar_relatorio", "Gerar PDF"),
    ),
    mainPanel = mainPanel(
      plotOutput("grafico")
    )
  )
)

server <- function(input, output, session) {

  output$grafico <- renderPlot({

    filmes_da_pessoa <- basesCursoR::pegar_base("imdb") |>
      mutate(
        data_lancamento = as.Date(data_lancamento)
      ) |>
      filter(
        stringr::str_detect(direcao, input$pessoa) |
          stringr::str_detect(elenco, input$pessoa)
      )

    nota_dos_melhores_filmes <- quantile(filmes_da_pessoa$nota_imdb, .9)
    tab_melhores <- filmes_da_pessoa |>
      filter(nota_imdb >= nota_dos_melhores_filmes) |>
      select(data_lancamento, titulo_original, nota_imdb) |>
      arrange(desc(nota_imdb))

    nota_dos_piores_filmes <- quantile(filmes_da_pessoa$nota_imdb, .1)
    tab_piores <- filmes_da_pessoa |>
      filter(nota_imdb <= nota_dos_piores_filmes) |>
      select(data_lancamento, titulo_original, nota_imdb, num_avaliacoes) |>
      arrange(desc(nota_imdb))

    filmes_da_pessoa |>
      filter(nota_imdb > nota_dos_piores_filmes, nota_imdb < nota_dos_melhores_filmes) |>
      ggplot(aes(x = data_lancamento, y = nota_imdb)) +
      geom_point(color = "grey") +
      geom_smooth(se = FALSE, color = "grey") +
      geom_point(data = tab_melhores, color = "dark green") +
      geom_smooth(data = tab_melhores, se = FALSE, color = "dark green") +
      ggrepel::geom_label_repel(data = tab_melhores, aes(label = titulo_original), color = "dark green") +
      geom_point(data = tab_piores, color = "red") +
      geom_smooth(data = tab_piores, se = FALSE, color = "red") +
      ggrepel::geom_label_repel(data = tab_piores, aes(label = titulo_original), color = "red") +
      theme(
        legend.position = 'none'
      ) +
      theme_minimal() +
      labs(
        x = "Noda média no IMDB",
        y = "Nota média no ano"
      ) +
      scale_y_continuous(limits = c(0, 10))
  })

  output$gerar_relatorio <- downloadHandler(
    filename = function() {
      paste0("filmes_", input$pessoa, ".pdf")
    },
    content = function(file) {
      rmarkdown::render(
        input = "www/template.Rmd",
        output_file = file,
        params = list(pessoa = input$pessoa)
      )
    }
  )

}

shinyApp(ui, server)
