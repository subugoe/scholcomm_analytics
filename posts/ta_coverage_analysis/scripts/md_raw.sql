WITH filtered_publications AS (
  SELECT DISTINCT
    UPPER(TRIM(cr.doi)) AS doi,
    jct.issn_l,
    jct.esac_id AS jn_esac_id,
    cr.publisher AS cr_publisher,
    cr.container_title AS cr_journal_title,
    EXTRACT(YEAR FROM cr.issued) AS cr_year,
    CASE WHEN cr.abstract IS NOT NULL THEN 1 END AS has_abstract,
    cr.license,
    cr.author,
    cr.link,
    cr.funder
  FROM (
      SELECT SPLIT(issn, ",") AS issn,
        doi,
        publisher,
        container_title,
        issued,
        license,
        abstract,
        author,
        link,
        funder
      FROM `subugoe-collaborative.cr_instant.snapshot`
      WHERE NOT REGEXP_CONTAINS(
          title,
          '(?i)^Author Index$|^Back Cover|^Contents$|^Contents:|^Corrigendum|^Cover Image|^Cover Picture|^Editorial Board|^Front Cover|^Frontispiece|^Inside Back Cover|^Inside Cover|^Inside Front Cover|^Issue Information|^List of contents|^Masthead|^Title page|^Correction$|^Corrections to|^Corrections$|^Withdrawn|^Frontmatter'
        )
        AND (
          NOT REGEXP_CONTAINS(page, '^S')
          OR page IS NULL
        )
        AND (
          NOT REGEXP_CONTAINS(issue, '^S')
          OR issue IS NULL
        )
        AND EXTRACT(YEAR FROM issued) BETWEEN 2019 AND 2025
  ) AS cr
  CROSS JOIN UNNEST(cr.issn) AS issn
  INNER JOIN `subugoe-collaborative.resources.oad_jct_jn` jct
    ON issn = jct.issn
  WHERE (
      (jct.esac_id = 'wiley2019deal' AND EXTRACT(YEAR FROM cr.issued) BETWEEN 2019 AND 2023) OR
      (jct.esac_id = 'wiley2024deal' AND EXTRACT(YEAR FROM cr.issued) BETWEEN 2024 AND 2025) OR
      (jct.esac_id = 'sn2021gac' AND EXTRACT(YEAR FROM cr.issued) BETWEEN 2021 AND 2023) OR
      (jct.esac_id = 'sn2020deal' AND EXTRACT(YEAR FROM cr.issued) BETWEEN 2020 AND 2023) OR
      (jct.esac_id = 'sn2024deal' AND EXTRACT(YEAR FROM cr.issued) BETWEEN 2024 AND 2025) OR
      (jct.esac_id = 'els2023deal' AND EXTRACT(YEAR FROM cr.issued) BETWEEN 2023 AND 2025) OR
      (jct.esac_id = 'degruy2022gac' AND EXTRACT(YEAR FROM cr.issued) = 2022) OR
      (jct.esac_id = 'degruy2023gac' AND EXTRACT(YEAR FROM cr.issued) BETWEEN 2023 AND 2024) OR
      (jct.esac_id = 'hogrefe2021gac' AND EXTRACT(YEAR FROM cr.issued) BETWEEN 2021 AND 2023) OR
      (jct.esac_id = 'hogrefe2024gac' AND EXTRACT(YEAR FROM cr.issued) BETWEEN 2024 AND 2025) OR
      (jct.esac_id = 'rsc2024tib' AND EXTRACT(YEAR FROM cr.issued) BETWEEN 2024 AND 2025) OR
      (jct.esac_id = 'opg2023tib' AND EXTRACT(YEAR FROM cr.issued) BETWEEN 2023 AND 2025) OR
      (jct.esac_id = 'ttp2024tib' AND EXTRACT(YEAR FROM cr.issued) BETWEEN 2024 AND 2025)
  )
),
first_author_data AS (
  SELECT
    UPPER(TRIM(w.doi)) AS doi,
    a.countries
  FROM `subugoe-collaborative.openalex_walden.works` w
  CROSS JOIN UNNEST(authorships) AS a
  WHERE a.author_position = 'first'
    AND 'DE' IN (
      SELECT UPPER(TRIM(country_code))
      FROM UNNEST(a.countries) AS country_code
    )
    AND EXISTS (
      SELECT 1
      FROM UNNEST(a.institutions) AS i
      JOIN `subugoe-collaborative.resources.oad_jct_inst` ji
        ON LOWER(i.ror) = LOWER(ji.ror_id)
        OR LOWER(i.display_name) = LOWER(ji.inst_name)
      WHERE i.display_name IS NOT NULL
        AND ji.inst_name IS NOT NULL
    )
),
oad_ta_md AS (
  SELECT
    fp.doi,
    fp.cr_year,
    fp.issn_l,
    fp.cr_journal_title,
    fp.jn_esac_id,
    fp.cr_publisher,
    fp.has_abstract,
    ARRAY_LENGTH(fp.author) AS num_authors,
    (SELECT COUNT(1) FROM UNNEST(fp.author) AS authors WHERE authors.orcid IS NOT NULL) AS num_orcids,
    COUNT(DISTINCT CASE WHEN md_2.id IS NOT NULL THEN md_2.id ELSE md_1.name END) AS num_affiliations,
    COUNT(DISTINCT CASE WHEN LOWER(md_2.id_type) = 'ror' THEN md_2.id END) AS num_rors,
    ARRAY_LENGTH(fp.funder) AS num_funders,
    (SELECT COUNT(1) FROM UNNEST(fp.funder) AS funders, UNNEST(funders.id) WHERE LOWER(id_type) = "doi") AS num_funder_dois,
    MAX(CASE WHEN md_3.content_version IN ('vor', 'unspecified') THEN md_3.url END) AS license_url,
    CASE
      WHEN EXISTS (SELECT 1 FROM UNNEST(fp.link) WHERE intended_application = "text-mining") THEN 1
      ELSE 0
    END AS has_tdm,
    tt.doi AS tt_doi,
    tt.count_authors,
    tt.has_authors_id_orcid,
    tt.count_authors_id_orcid,
    tt.has_affiliations,
    tt.count_affiliations,
    tt.has_affiliations_id_ror,
    tt.count_affiliations_id_ror,
    tt.has_abstract AS tt_has_abstract,
    tt.has_funders,
    tt.count_funders,
    tt.has_funders_id_doi,
    tt.count_funders_id_doi
  FROM filtered_publications fp
  INNER JOIN first_author_data fa
    ON fp.doi = fa.doi
  LEFT JOIN UNNEST(fp.author) AS md_0
  LEFT JOIN UNNEST(md_0.affiliation) AS md_1
  LEFT JOIN UNNEST(md_1.id) AS md_2
  LEFT JOIN UNNEST(fp.license) AS md_3
  LEFT JOIN `sos-datasources.truthtables.crossref_truthtable_20260131` tt
    ON fp.doi = tt.doi
  GROUP BY
    fp.doi,
    tt.doi,
    fp.cr_year,
    fp.issn_l,
    fp.cr_journal_title,
    fp.jn_esac_id,
    fp.cr_publisher,
    fp.has_abstract,
    fp.author,
    fp.funder,
    fp.license,
    fp.link,
    tt.count_authors,
    tt.has_authors_id_orcid,
    tt.count_authors_id_orcid,
    tt.has_affiliations,
    tt.count_affiliations,
    tt.has_affiliations_id_ror,
    tt.count_affiliations_id_ror,
    tt.has_abstract,
    tt.has_funders,
    tt.count_funders,
    tt.has_funders_id_doi,
    tt.count_funders_id_doi
)

SELECT * FROM oad_ta_md