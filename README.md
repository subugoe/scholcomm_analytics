## Scholarly Communication Analytics with R Blog


### How to use it?

Overview first steps: <https://rstudio.github.io/distill/>

#### Clone the repo

```
git clone https://github.com/subugoe/scholcomm_analytics.git
```

#### Install R package distill

From GitHub using devtools.

```r
devtools::install_github("rstudio/distill")
```

#### Creating an R Markdown article draft

```r
library(rmarkdown)
rmarkdown::draft("article.Rmd", "distill_article", package = "distill")
```

Reference managing is supported, however, there are some issues with BibTeX conversion, e.g. `--` is not rendered as emdash.

#### Build the website

```r
rmarkdown::render_site()
```

### License

CC-BY 4.0