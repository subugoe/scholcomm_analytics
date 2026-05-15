# loading libraries
library(tidyverse)
library(bigrquery)
library(DBI)
options(tidyverse.quiet = TRUE)

target_esac_ids <- c(
  "wiley2019deal", "wiley2024deal", "sn2021gac", "sn2020deal", "sn2024deal",
  "els2023deal", "degruy2022gac", "degruy2023gac", "hogrefe2021gac",
  "hogrefe2024gac", "rsc2024tib", "opg2023tib", "ttp2024tib"
)

# reused and adapted from: https://github.com/njahn82/jct_data/blob/df78ce621651b9aa26ca29bbb4a4100d94fd4248/enrich.R
# reading issn data and creating journal table
issn_l <- readr::read_tsv("data_raw/20260222.ISSN-to-ISSN-L.txt", col_names = c("issn", "issn_l"), skip = 1) |>
  dplyr::mutate(issn_l = substr(issn_l, start = 1, stop = 9))
jct_jn <- readr::read_csv("https://github.com/njahn82/jct_data/blob/main/data/jct_jn_all.csv?raw=true") # 2026-02-23

oad_jct_jn <- jct_jn |>
  dplyr::filter(esac_id %in% target_esac_ids) |>
  tidyr::pivot_longer(
    cols = c(issn_print, issn_online),
    names_to = "issn_type",
    values_to = "issn"
  ) |>
  dplyr::filter(!is.na(issn)) |>
  dplyr::left_join(issn_l, by = c("issn")) |>
  dplyr::distinct(
    esac_id,
    issn,
    issn_l,
    time_last_seen,
    commit_hash
  )


jct_inst <- readr::read_csv("https://github.com/njahn82/jct_data/blob/main/data/jct_inst_all.csv?raw=true") # 2026-04-21

oad_jct_inst <- jct_inst |>
  dplyr::filter(esac_id %in% target_esac_ids) |>
  dplyr::distinct()

# write_csv(oad_jct_inst, "data_raw/oad_jct_inst.csv")

# uploading to BQ

bq_con <- dbConnect(
  bigrquery::bigquery(),
  project = "subugoe-collaborative",
  dataset = "resources",
  billing = "subugoe-collaborative"
)

# Source - https://stackoverflow.com/a/77315474
# Posted by Lachlan Macnish
# Retrieved 2026-02-23, License - CC BY-SA 4.0

bq_table_create("subugoe-collaborative.resources.oad_jct_jn", as_bq_fields(oad_jct_jn))
bq_table_upload(
  bq_table("subugoe-collaborative", "resources", "oad_jct_jn"),
  oad_jct_jn,
  write_disposition = "WRITE_TRUNCATE"
)

bq_table_create("subugoe-collaborative.resources.oad_jct_inst", as_bq_fields(oad_jct_inst))
bq_table_upload(
  bq_table("subugoe-collaborative", "resources", "oad_jct_inst"),
  oad_jct_inst,
  write_disposition = "WRITE_TRUNCATE"
)
