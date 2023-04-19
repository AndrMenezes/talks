library(knitr)
## knitr options
opts_chunk$set(
    ## cache = TRUE,
    tidy = FALSE,
    comment = "#",
    collapse = TRUE, ## colapsa chunks em R Markdown
    fig.width = 14,
    fig.height = 7,
    fig.align = "center",
    out.width = "80%",
    echo = FALSE,
    dpi = 120, ## aumentar o dpi para exibir maior.
    dev = "svg",
    cache.path = "cache/",
    fig.path = "figures/"
    )
