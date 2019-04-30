SELECT
        year,
        host_type,
        journal_is_in_doaj,
        COUNT(DISTINCT(doi)) AS number_of_articles 
    FROM
        `oadoi_full.feb_19_mongo_export_2008_2012_full_all_genres`,
        UNNEST(oa_locations) 
    WHERE
        genre = 'journal-article' 
        AND is_best = true
        AND data_standard = 2
    GROUP BY
        year,
        host_type,
        journal_is_in_doaj