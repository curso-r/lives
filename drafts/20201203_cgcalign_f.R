#' Author:
#' Subject:

# library(tidyverse)
library(GCalignR)

# Import -----------------------------------------------------------------------

data("peak_data")

# Tidy -------------------------------------------------------------------------

check_input(data = peak_data,plot = F)

# Visualize --------------------------------------------------------------------

peak_interspace(data = peak_data, rt_col_name = "time",
                quantile_range = c(0, 0.8), quantiles = 0.05)

data("aligned_peak_data")

gc_heatmap(aligned_peak_data,threshold = 0.03)

# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
create df

df <- data.frame(x = 1:1000, y = dnorm(1:1000,300,20))

## plot

with(df, plot(x,y))

## detect peak find_peaks(df) df <- peak_data[[3]] %>% set_names(c("x", "y")) ## plot with(df, plot(x,y)) ## detect peak find_peaks(df)
