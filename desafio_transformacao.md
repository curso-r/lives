# Desafio transformação

O objetivo do desafio é fazer a mesma task usando ferramentas do `{tidyverse}`, R base e Python pandas.

A ideia é ver não só a eficiência dos códigos, mas a fluidez no desenvolvimento de cada solução.

A ideia não é ver qual é melhor, e sim ver como resolver problemas práticos de formas diferentes!

## Regras

- Todas as bases de dados estarão no formato `.feather`, que pode ser lida tanto no R com o pacote `{feather}` quanto no Python com a biblioteca `feather`.
- Em cada desafio, teremos uma base de entrada e uma base de saída.
- A tarefa é pegar a base de entrada e obter a base de saída, salvando-a com o mesmo nome de arquivo.

# Desafios

## Desafio 1: Data tidying e sumários

A base de dados "diamonds" do pacote `{ggplot2}` é bastante utilizada em aulas e exemplos.

Resumo da base:

    Rows: 53,940
    Columns: 10
    $ carat   <dbl> 0.23, 0.21, 0.23, 0.29, 0.31, 0.24, 0.24, 0.…
    $ cut     <chr> "Ideal", "Premium", "Good", "Premium", "Good…
    $ color   <chr> "E", "E", "E", "I", "J", "J", "I", "H", "E",…
    $ clarity <chr> "SI2", "SI1", "VS1", "VS2", "SI2", "VVS2", "…
    $ depth   <dbl> 61.5, 59.8, 56.9, 62.4, 63.3, 62.8, 62.3, 61…
    $ table   <dbl> 55, 61, 65, 58, 58, 57, 57, 55, 61, 61, 55, …
    $ price   <int> 326, 326, 327, 334, 335, 336, 336, 337, 337,…
    $ x       <dbl> 3.95, 3.89, 4.05, 4.20, 4.34, 3.94, 3.95, 4.…
    $ y       <dbl> 3.98, 3.84, 4.07, 4.23, 4.35, 3.96, 3.98, 4.…
    $ z       <dbl> 2.43, 2.31, 2.31, 2.63, 2.75, 2.48, 2.47, 2.…

**Objetivo**: Calcular a média de `carat` para cada combinação de `cut` e `clarity`. Considerar apenas `price` acima de 2000. Formatar o resultado na forma que está abaixo, ordenando em ordem decrescente por *Ideal*.

|clarity |      Fair|      Good|     Ideal|   Premium| Very Good|
|:-------|---------:|---------:|---------:|---------:|---------:|
|I1      | 1.7287597| 1.3845205| 1.3216279| 1.4436364| 1.4061972|
|SI2     | 1.2778261| 1.2022689| 1.2067610| 1.3068894| 1.2153952|
|SI1     | 1.0907937| 1.0855521| 1.1026456| 1.1751936| 1.0880402|
|VS2     | 1.0411290| 1.0822099| 1.0804938| 1.1849919| 1.0928534|
|VS1     | 1.0352459| 1.0314247| 1.0188012| 1.1595602| 1.0355158|
|VVS2    | 0.8748837| 0.9209375| 0.8948753| 1.0220930| 0.9377189|
|VVS1    | 0.9044444| 0.8632759| 0.8512852| 0.9953757| 0.8817573|
|IF      | 0.5800000| 0.9209091| 0.8373551| 1.0671084| 0.9169231|


## Desafio 2: Arrumando colunas de datas e números zoados

A base de dados `sabesp` foi baixada por nós em uma live da Curso-R.


    Rows: 217
    Columns: 18
    $ dia                   <chr> "2020-07-30", "2020-07-30", "2…
    $ sistema_id            <chr> "0", "1", "2", "3", "4", "5", …
    $ nome                  <chr> "Cantareira", "Alto Tietê", "G…
    $ volume_porcentagem_ar <chr> "52,5", "68,1", "53,0", "82,4"…
    $ volume_porcentagem    <dbl> 52.45845, 68.08712, 53.00053, …
    $ volume_variacao_str   <chr> "-0,1", "-0,2", "-0,1", "0,0",…
    $ volume_variacao_num   <dbl> -0.1, -0.2, -0.1, 0.0, 0.2, 2.…
    $ volume_operacional    <dbl> 515.17978, 381.49849, 90.73242…
    $ image_prec_dia        <chr> "prec_icon.png", "prec_icon.pn…
    $ prec_dia              <chr> "2,0", "4,3", "5,0", "8,0", "9…
    $ prec_mensal           <chr> "6,9", "11,8", "6,0", "12,2", …
    $ prec_hist             <chr> "47,7", "47,9", "41,9", "52,1"…
    $ link_grafico          <lgl> NA, NA, NA, NA, NA, NA, NA, NA…
    $ link_informacoes      <lgl> NA, NA, NA, NA, NA, NA, NA, NA…
    $ indicador_volume_dia  <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    $ indicador_volume      <int> 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, …
    $ circle_image          <lgl> NA, NA, NA, NA, NA, NA, NA, NA…
    $ link_tempo            <lgl> NA, NA, NA, NA, NA, NA, NA, NA…

**Objetivo**: calcular a média de `prec_hist` por mês e por nome do reservatório. Necessário formatar o mês e transformar `prec_hist` em numérico. Obs: se quiser, pode deixar o nome do mês em inglês.

|mes   |nome         |  n| media|
|:-----|:------------|--:|-----:|
|junho |Alto Tietê   |  1|  56.1|
|junho |Cantareira   |  1|  63.4|
|junho |Cotia        |  1|  59.3|
|junho |Guarapiranga |  1|  53.7|
|junho |Rio Claro    |  1|  98.5|
|junho |Rio Grande   |  1|  61.2|
|junho |São Lourenço |  1|  75.0|
|julho |Alto Tietê   | 30|  47.9|
|julho |Cantareira   | 30|  47.7|
|julho |Cotia        | 30|  52.1|
|julho |Guarapiranga | 30|  41.9|
|julho |Rio Claro    | 30|  92.1|
|julho |Rio Grande   | 30|  55.2|
|julho |São Lourenço | 30|  77.7|

## Desafio 3: Arrumando colunas de datas e números zoados, parte 2

A base de dados `contratos_covid` foi baixada por nós em uma live da Curso-R.


    Columns: 8
    $ valor_total_contrato <chr> "R$391.000,00", "R$124.000,00", "R$51.800,…
    $ empresa              <chr> "S.M. GUIMARÃES EIRELI - QUALITY", "NDALAB…
    $ cnpj                 <chr> "26.889.274/0001-77", "04.654.861/0001-44"…
    $ n_contrato           <chr> "40/2020", "41/2020", "42/2020", "43/2020"…
    $ prazo_180_dias       <chr> "29/08/2020", "29/08/2020", "30/08/2020", …
    $ n_processo_sei       <chr> "25000.020637/2020-03", "25000.020637/2020…
    $ href                 <chr> "https://www.saude.gov.br/images/pdf/2020/…
    $ file                 <chr> "~/Downloads/Contrato-40-2020.pdf", "~/Dow…

**Objetivo**: De forma similar ao anterior, calcular a quantidade de observações e a soma de `valor_total_contrato` de acordo com o mês retirado de `prazo_180_dias`. Obs: tome cuidado pois a data tem mais de um formato distinto.


|mes      |  n|soma             |
|:--------|--:|:----------------|
|agosto   | 10|R$6.943.200,00   |
|setembro | 24|R$194.921.722,39 |
|outubro  |  4|R$790.550.400,00 |
|novembro |  3|R$139.575.027,52 |


## Desafio 4: Join de bases

A base `varas` contém informações de varas de direito e cartórios do Brasil. Já a base `idhm` contém informações sobre o IDH-Municipal dos municípios do país


varas:

    Rows: 50,760
    Columns: 6
    $ cod          <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16…
    $ tipo         <chr> "Conselhos", "Conselhos", "Conselhos", "Justiça do Tr…
    $ nome_vara    <chr> "CONSELHO DA JUSTIÇA FEDERAL", "CONSELHO NACIONAL DE …
    $ municipio_uf <chr> "Brasília - DF", "Brasília - DF", "Brasília - DF", "A…
    $ lat          <dbl> -15.780148, -15.780148, -15.809753, -1.729506, -22.46…
    $ long         <dbl> -47.92917, -47.92917, -47.86932, -48.87425, -44.45555…

idhm:

    Rows: 5,565
    Columns: 5
    $ ufn       <chr> "Rondônia", "Rondônia", "Rondônia", "Rondônia", "Rondônia", "Rond…
    $ municipio <chr> "ALTA FLORESTA D'OESTE", "ARIQUEMES", "CABIXI", "CACOAL", "CEREJE…
    $ codmun6   <int> 110001, 110002, 110003, 110004, 110005, 110006, 110007, 110008, 1…
    $ idhm      <dbl> 0.641, 0.702, 0.650, 0.718, 0.692, 0.685, 0.613, 0.611, 0.672, 0.…
    $ popt      <int> 22429, 88730, 6156, 76876, 16815, 18204, 8397, 13246, 27791, 3820…


**Objetivo**: Adicionar a coluna `codmun6` na base de dados `varas`, cruzando pelo nome do município. Para facilitar, vamos trabalhar apenas com o estado do Rio Grande do Sul. No final, contar a quantidade de varas por `municipio` e `codmun6`, o `idhm`, ordenar em ordem decrescente pela frequência e pegar os 10 mais frequentes.


|municipio     | codmun6|   n|  idhm|
|:-------------|-------:|---:|-----:|
|PORTO ALEGRE  |  431490| 255| 0.805|
|CAXIAS DO SUL |  430510|  52| 0.782|
|PELOTAS       |  431440|  48| 0.739|
|NOVO HAMBURGO |  431340|  44| 0.747|
|SANTA MARIA   |  431690|  42| 0.784|
|CANOAS        |  430460|  41| 0.750|
|PASSO FUNDO   |  431410|  36| 0.776|
|RIO GRANDE    |  431560|  35| 0.744|
|BAGE          |  430160|  30| 0.740|
|SAO LEOPOLDO  |  431870|  29| 0.739|
