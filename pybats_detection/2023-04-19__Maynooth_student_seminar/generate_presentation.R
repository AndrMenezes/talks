rm(list = ls())

file.remove("index.html")
unlink("index_files", recursive = TRUE)
rmarkdown::render(input = "index.Rmd",
                  output_file = "index.html",
                  clean = TRUE)
renderthis::to_pdf("index.html")