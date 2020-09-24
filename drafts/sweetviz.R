library(reticulate)
conda_install("r-reticulate", "sweetviz", channel = "conda-forge", pip = TRUE)
sv <- import("sweetviz")
sv$analyze(mtcars, target_feat = "vs")
