## Scholarly Communication Analytics with R Blog

### Installation

From GitHub using devtools.

```r
devtools::install_github("rstudio/distill")
```
### How to use it?

First steps: <https://rstudio.github.io/distill/>

#### Creating an article draft

```r
library(rmarkdown)
draft("article.Rmd", "distill_article", package = "distill")
```

Reference managing is supported, however, there are some issues with BibTeX conversion, e.g. `--` is not rendered as emdash.