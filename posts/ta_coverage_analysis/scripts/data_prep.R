# loading libraries
library(tidyverse)
options(scipen = 999, tidyverse.quiet = TRUE)


md_raw <- readRDS(file = "data_raw/md_raw.rds")

# check for duplicate or missing issn_l
n_distinct(md_raw$issn_l) # 6,732

md_raw |>
  unnest(cr_journal_title) |>
  group_by(doi) |>
  filter(n() > 1) |>
  filter(n_distinct(issn_l) > 1) |>
  group_by(issn_l, cr_journal_title) |>
  summarise(n = n()) |>
  arrange(desc(n))

# unify journal, esac_id and esac_publisher

md_dst <- md_raw |>
  rename(esac_id = jn_esac_id) |>
  unnest(cr_journal_title) |>
  mutate(
    issn_l = case_when(
      cr_journal_title == "Continental Philosophy Review" ~ "1387-2842",
      cr_journal_title == "Theoretical Medicine and Bioethics" ~ "1386-7415",
      cr_journal_title == "Journal of Central South University" ~ "2095-2899",
      cr_journal_title == "Journal of Coatings Technology and Research" ~ "1547-0091",
      cr_journal_title == "Resonance" ~ "0971-8044",
      cr_journal_title == "Rendiconti Lincei. Scienze Fisiche e Naturali" ~ "2037-4631",
      cr_journal_title == "Indian Journal of Clinical Biochemistry" ~ "0970-1915",
      cr_journal_title == "Journal of Plant Biology" ~ "1226-9239",
      cr_journal_title == "Journal of the Indian Society of Remote Sensing" ~ "0255-660X",
      cr_journal_title == "Korea-Australia Rheology Journal" ~ "1226-119X",
      cr_journal_title == "Journal of Homotopy and Related Structures" ~ "2193-8407",
      cr_journal_title == "Indian Geotechnical Journal" ~ "0971-9555",
      cr_journal_title == "Fudan Journal of the Humanities and Social Sciences" ~ "1674-0750",
      cr_journal_title == "Eurasian Economic Review" ~ "1309-422X",
      cr_journal_title == "Journal of Quantitative Economics" ~ "0971-1554",
      cr_journal_title == "Journal of Indian Council of Philosophical Research" ~ "0970-7794",
      cr_journal_title == "The Journal of Analysis" ~ "0971-3611",
      cr_journal_title == "Journal of the Indian Institute of Science" ~ "0970-4140",
      cr_journal_title == "Bulletin of the Iranian Mathematical Society" ~ "1017-060X",
      cr_journal_title == "Proceedings of the Indian National Science Academy" ~ "0370-0046",
      cr_journal_title == "Schmerz Nachrichten" ~ "2076-7625",
      cr_journal_title == "Design Management Journal" ~ "1942-5074",
      cr_journal_title == "Journal of Applied Corporate Finance" ~ "1078-1196",
      cr_journal_title == "Journal of Obstetrics and Gynaecology Research" ~ "1341-8076",
      cr_journal_title == "Polymer Science, Series A" ~ "0965-545X",
      cr_journal_title == "European Archives of Oto-Rhino-Laryngology" ~ "0937-4477",
      cr_journal_title == "Health Services Research" ~ "0017-9124",
      cr_journal_title == "MRS Advances" ~ "2059-8521",
      cr_journal_title == "Pramana" ~ "0304-4289",
      cr_journal_title == "Journal of Control Science and Engineering" ~ "1687-5249",
      cr_journal_title == "Chinese Journal of Polymer Science" ~ "0256-7679",
      cr_journal_title == "Paleoceanography and Paleoclimatology" ~ "2572-4525",
      cr_journal_title == "Irrigation and Drainage" ~ "1531-0361",
      cr_journal_title == "World Journal of Pediatrics" ~ "1867-0687",
      cr_journal_title == "Current Pain and Headache Reports" ~ "1534-3081",
      cr_journal_title == "Environmental Sciences Europe" ~ "2190-4715",
      cr_journal_title == "Ecological Management &amp; Restoration" ~ "1839-3330",
      cr_journal_title == "Journal of Evidence-Based Medicine" ~ "1756-5391",
      cr_journal_title == "Advances in Pharmacological and Pharmaceutical Sciences" ~ "2633-4690",
      cr_journal_title == "International Journal of Mechanical and Materials Engineering" ~ "2198-2791",
      TRUE ~ issn_l
    ),
    cr_journal_title = case_when(
      issn_l == "1661-819X" ~ "Advances in Science and Technology",
      issn_l == "2813-8333" ~ "Engineering Headway",
      TRUE ~ cr_journal_title
    ),
    esac_id = case_when(
      issn_l == "1091-255X" & cr_year < 2024 ~ "sn2020deal",
      issn_l == "1355-8145" & cr_year < 2024 ~ "sn2020deal",
      issn_l == "1226-7988" & cr_year < 2024 ~ "sn2020deal",
      issn_l == "1071-3581" & cr_year < 2024 ~ "sn2020deal",
      issn_l == "1279-7707" & cr_year < 2024 ~ "sn2020deal",
      issn_l == "1878-7479" & cr_year < 2024 ~ "sn2020deal",
      issn_l == "2274-5807" & cr_year < 2024 ~ "sn2020deal",
      issn_l == "1600-6135" & cr_year >= 2023 ~ "els2023deal",
      issn_l == "1538-7836" & cr_year >= 2023 ~ "els2023deal",
      issn_l == "1469-221X" & cr_year < 2020 ~ "wiley2019deal",
      issn_l == "1469-221X" & cr_year >= 2020 & cr_year < 2024 ~ "sn2020deal",
      issn_l == "0261-4189" & cr_year < 2020 ~ "wiley2019deal",
      issn_l == "0261-4189" & cr_year >= 2020 & cr_year < 2024 ~ "sn2020deal",
      issn_l == "1056-8190" & cr_year < 2024 ~ "wiley2019deal",
      issn_l == "1757-7802" & cr_year < 2024 ~ "wiley2019deal",
      issn_l == "2260-1341" & cr_year < 2024 ~ "sn2020deal",
      issn_l == "1744-4292" & cr_year >= 2020 & cr_year < 2024 ~ "sn2020deal",
      issn_l == "1757-4676" & cr_year < 2024 ~ "wiley2019deal",
      issn_l == "1097-6647" & cr_year < 2024 ~ "sn2020deal",
      issn_l == "1880-6546" & cr_year < 2024 ~ "sn2020deal",
      issn_l == "2475-0379" & cr_year > 2022 ~ "els2023deal",
      issn_l == "1326-0200" & cr_year > 2022 ~ "els2023deal",
      issn_l == "2688-1152" & cr_year < 2024 ~ "wiley2019deal",
      TRUE ~ esac_id
    ),
    esac_publisher = case_when(
      esac_id %in% c("wiley2019deal", "wiley2024deal") ~ "Wiley",
      esac_id %in% c("sn2021gac", "sn2020deal", "sn2024deal") ~ "Springer Nature",
      esac_id == "els2023deal" ~ "Elsevier",
      esac_id %in% c("degruy2022gac", "degruy2023gac") ~ "Walter de Gruyter",
      esac_id %in% c("hogrefe2021gac", "hogrefe2024gac") ~ "Hogrefe",
      esac_id == "rsc2024tib" ~ "Royal Society of Chemistry",
      esac_id == "opg2023tib" ~ "Optica",
      esac_id == "ttp2024tib" ~ "Trans Tech Publications",
      TRUE ~ cr_publisher
    )
  ) |>
  distinct()

# check for unique journals

n_distinct(md_dst$issn_l) # 6,708

md_dst |>
  group_by(doi) |>
  filter(n() > 1) |>
  arrange(desc(doi))

saveRDS(md_dst, file = "data_raw/md_dst.rds")
write_csv(md_dst, file = "data/md_dst.csv")

# check licence URLs

md_dst |>
  group_by(license_url) |>
  summarise(n = n()) |>
  arrange(desc(n))

# correct licence URLs and add agreement columns

md_alt <- md_dst |>
  mutate(
    license_url = str_replace(license_url, "http://creativecommons.org/licenses/by-nc-nd/4.0/ http://creativecommons.org/licenses/by-nc-nd/4.0/", "http://creativecommons.org/licenses/by-nc-nd/4.0/"),
    license_url = str_replace(license_url, "http://creativecommons.org/licenses/by/4.0/ http://creativecommons.org/licenses/by/4.0/", "http://creativecommons.org/licenses/by/4.0/"),
    license_url = str_replace(license_url, "http://creativecommons.org/licenses/by-nc/4.0/ http://creativecommons.org/licenses/by-nc/4.0/", "http://creativecommons.org/licenses/by-nc/4.0/"),
    cc = case_when(
      str_detect(license_url, "creativecommons.org") ~ str_extract(license_url, "(?<=licenses/)[a-zA-Z0-9\\s-]+(?=/)"),
      !is.na(license_url) ~ "other",
      TRUE ~ NA_character_
    ),
    agreement = case_when(
      esac_id == "wiley2019deal" ~ "DEAL (2019)",
      esac_id == "wiley2024deal" ~ "DEAL (2024)",
      esac_id == "sn2021gac" ~ "MPDL (2021)",
      esac_id == "sn2020deal" ~ "DEAL (2020)",
      esac_id == "sn2024deal" ~ "DEAL (2024)",
      esac_id == "els2023deal" ~ "DEAL (2023)",
      esac_id == "degruy2022gac" ~ "SUB Göttingen (2022)",
      esac_id == "degruy2023gac" ~ "SUB Göttingen (2023)",
      esac_id == "hogrefe2021gac" ~ "SUB Göttingen (2021)",
      esac_id == "hogrefe2024gac" ~ "SUB Göttingen (2024)",
      esac_id == "rsc2024tib" ~ "TIB (2024)",
      esac_id == "opg2023tib" ~ "TIB (2023)",
      esac_id == "ttp2024tib" ~ "TIB (2024)",
      TRUE ~ esac_id
    ),
    combined_agreement = glue::glue('<div><div style="font-weight:bold;font-size:14px;">{esac_publisher}</div><div style="font-size:12px;">{agreement}</div></div>'),
    agreement_display = paste(esac_publisher, agreement, sep = " "),
    has_abstract = replace_na(has_abstract, 0)
  ) |>
  relocate(agreement, .before = num_authors) |>
  relocate(combined_agreement, .before = num_authors) |>
  relocate(agreement_display, .before = num_authors)

saveRDS(md_alt, file = "data_raw/md_alt.rds")
write_csv(md_alt, file = "data/md_alt.csv")

# check unique issn_l and doi

n_distinct(md_alt$issn_l) # 6,708
n_distinct(md_alt$doi) # 246,499

# create smaller data frame
md_calc <- md_alt |>
  select(doi, esac_id, cr_year, cc)

saveRDS(md_calc, file = "data_raw/md_calc.rds")
write_csv(md_calc, file = "data/md_calc.csv")


# prepare data for cc reactable table

md_react <- md_alt |>
  group_by(esac_id, esac_publisher, agreement, combined_agreement, agreement_display, cr_year, cc) |>
  summarise(
    num_articles = n(),
    .groups = "drop"
  ) |>
  group_by(esac_id, esac_publisher, agreement, combined_agreement, agreement_display, cr_year) |>
  mutate(
    num_articles_total = sum(num_articles),
    cc_share = case_when(
      cc == "other" ~ 0,
      is.na(cc) ~ 0,
      TRUE ~ round(num_articles / num_articles_total * 100, 2)
    ),
    cc_share_total = sum(cc_share)
  ) |>
  ungroup() |>
  select(-c(num_articles)) |>
  pivot_wider(names_from = cc, values_from = cc_share, names_prefix = "cc_share_", values_fill = list(cc_share = 0)) |>
  select(-c(cc_share_other, cc_share_NA)) |>
  mutate(
    by_color = get_by_color(cc_share_by),
    cc_color = get_cc_color(cc_share_total),
    # combined_agreement = paste(esac_publisher, agreement, sep = " "),
    lead = str_replace(agreement, "\\s{1}\\({1}\\d{4}\\){1}", "")
  ) |>
  group_by(esac_id, esac_publisher, agreement, combined_agreement, agreement_display) |>
  mutate(cc_by_trend = list(cc_share_by)) |>
  ungroup()

saveRDS(md_react, file = "data/md_react.rds")


# create metadata coverage table data

md_cov <- md_alt |>
  group_by(esac_publisher, esac_id, agreement, agreement_display, combined_agreement, cr_year) |>
  summarise(
    articles = n(),
    authors = sum(num_authors, na.rm = TRUE),
    affiliations = sum(num_affiliations, na.rm = TRUE),
    tdm_support = sum(has_tdm, na.rm = TRUE),
    orcid_coverage = sum(num_orcids, na.rm = TRUE),
    ror_coverage = sum(num_rors, na.rm = TRUE),
    funder_info = sum(num_funders > 0, na.rm = TRUE),
    funders = sum(num_funders, na.rm = TRUE),
    funder_doi_coverage = sum(num_funder_dois, na.rm = TRUE),
    abstract_coverage = sum(has_abstract, na.rm = TRUE),
    .groups = "drop"
  ) |>
  mutate(
    tdm_share = tdm_support / articles,
    orcid_share = orcid_coverage / authors,
    ror_share = case_when(
      ror_coverage == 0 ~ 0,
      TRUE ~ ror_coverage / affiliations
    ),
    funder_share = funder_info / articles,
    funder_doi_share = case_when(
      funder_doi_coverage == 0 ~ 0,
      TRUE ~ funder_doi_coverage / funders
    ),
    abstract_share = abstract_coverage / articles
  ) |>
  select(esac_publisher, esac_id, agreement, agreement_display, combined_agreement, cr_year, tdm_share, orcid_share, ror_share, funder_share, funder_doi_share, abstract_share) |>
  pivot_longer(
    cols = c(tdm_share, orcid_share, ror_share, funder_share, funder_doi_share, abstract_share),
    names_to = "metric", values_to = "value"
  ) |>
  mutate(metric = case_when(
    metric == "tdm_share" ~ "TDM",
    metric == "orcid_share" ~ "ORCID",
    metric == "ror_share" ~ "ROR",
    metric == "funder_share" ~ "Funder Info",
    metric == "funder_doi_share" ~ "Funder DOIs",
    metric == "abstract_share" ~ "Open Abstracts"
  )) |>
  pivot_wider(names_from = "cr_year", values_from = "value") |>
  # mutate(combined_agreement = glue::glue('<div><div style="font-weight:bold;font-size:14px;">{esac_publisher}</div><div style="font-size:12px;">{agreement}</div></div>')) |>
  # mutate(agreement_display = paste(esac_publisher, agreement, sep = " ")) |>
  select(esac_publisher, esac_id, agreement, agreement_display, combined_agreement, metric, `2019`, `2020`, `2021`, `2022`, `2023`, `2024`, `2025`)

saveRDS(md_cov, file = "data_raw/md_cov.rds")
write_csv(md_cov, file = "data/md_cov.csv")
