#' Author:
#' Subject:

# library(tidyverse)
library(magrittr)

remotes::install_github("mottensmann/GCalignR",
                        build_vignettes = TRUE,
                        force = TRUE)

# Import -----------------------------------------------------------------------
library(GCalignR)
browseVignettes("GCalignR")

vignette(package = "GCalignR")

data("peak_data")

peak_data$C3 %>% str
dplyr::glimpse(peak_data)
# Tidy -------------------------------------------------------------------------

check_input(data = peak_data,plot = F)

peak_interspace(
  data = peak_data, rt_col_name = "time",
  quantile_range = c(0, 0.8), quantiles = 0.05
)

# Visualize --------------------------------------------------------------------

plot(peak_data$C3$time,
     peak_data$C3$area,
     type = "l")



gc_heatmap(aligned_peak_data,threshold = 0.03)

peak_data_aligned <- align_chromatograms(
  data = peak_data, # input data
  rt_col_name = "time", # retention time variable name
  rt_cutoff_low = 15, # remove peaks below 15 Minutes
  rt_cutoff_high = 45, # remove peaks exceeding 45 Minutes
  reference = NULL, # choose automatically
  max_linear_shift = 0.05, # max. shift for linear corrections
  max_diff_peak2mean = 0.03, # max. distance of a peak to the mean across samples
  min_diff_peak2peak = 0.03, # min. expected distance between peaks
  blanks = "C2", # negative control
  delete_single_peak = TRUE, # delete peaks that are present in just one sample
  write_output = NULL
) # add variable names to write aligned data to text files

gc_heatmap()

df <- peak_data[[3]] %>% set_names(c("x", "y")) ## plot plot(df$x,df$y, type = "l") ## detect peak find_peaks(df)
## create df

df <- data.frame(x = 1:1000, y = dnorm(1:1000,300,20))
##
with(df, plot(x,y)) ## detect peak
find_peaks(df)

df <- peak_data[[3]] %>%
  set_names(c("x", "y"))

df <- peak_data[[3]] %>%
  set_names(c("x", "y")) %>%
  na.omit()

# with(df, plot(x,y)) ## detect peak
# with(find_peaks(df), points(x, y, col = "blue", pch = 16))
#
# df <- peak_data_aligned$aligned_list[[4]] %>%
#   set_names(c("x", "y"))
# with(df, plot(x,y)) ## detect peak
# with(find_peaks(df), points(x, y, col = "blue", pch = 16))


# Model ------------------------------------------------------------------------

# Export -----------------------------------------------------------------------

# readr::write_rds(d, "")
