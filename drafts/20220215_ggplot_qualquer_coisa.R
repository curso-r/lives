
# Carregando pacotes ------------------------------------------------------

library(tidyverse)
library(lubridate)

# Importar os dados -------------------------------------------------------

url <- "https://raw.githubusercontent.com/adamribaudo/storytelling-with-data-ggplot/master/data/FIG0209.csv"

dados <- read_csv(url)

# Manipulação -------------------------------------------------------------

dados_arrumados <- dados %>%
  unite("Data_texto", Year, Month, sep = "-", remove = FALSE) %>%
  mutate(
    Data = ym(Data_texto)
  )

# Visualização ------------------------------------------------------------

dados_do_pontinho <- dados_arrumados %>%
  filter(Data == max(Data))

dados_arrumados %>%
  ggplot(aes(x = Data, y = Avg, ymin = Min, ymax = Max)) +
  geom_ribbon(alpha = .4) +
  geom_line(size = 2, color = "#595959") +
  geom_point(data = dados_do_pontinho, size = 4, color = "#595959") +
  theme_minimal(15) +
  scale_y_continuous(
    limits = c(0, 40),
    breaks = seq(0, 40, 5)) +
  labs(x = "", y = "Wait time (minutes)") +
  scale_x_date(limits = ymd(c("2014-09-01", "2015-09-20")),
               breaks = "month",
               date_labels = "%b"
               #labels = function(x){month(x, label = TRUE)}
               ) +
  annotate("text", x = as.Date("2014-09-15"), y = 11, label = "MIN") +
  annotate("text", x = as.Date("2014-09-15"), y = 19.5, label = "AVG") +
  annotate("text", x = as.Date("2014-09-15"), y = 24.5, label = "MAX") +
  annotate("text", x = as.Date("2015-09-20"), y = 21, label = "21") +
  ggtitle("Passport control wait time", subtitle = "Past 13 months") +
  #theme_minimal()
  theme(
    text = element_text(color = "#8c8c8c"),
    axis.text = element_text(color = "#bfbfbf"),
    axis.title.y = element_text(hjust = 1),
    panel.grid = element_blank(),
    axis.line = element_line(size = .1, color = '#a6a6a6'),
    axis.ticks = element_line(size = .1, color = '#a6a6a6')
  )
