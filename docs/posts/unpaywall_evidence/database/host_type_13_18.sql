SELECT
        year,
        host_type,
        journal_is_in_doaj,
        COUNT(DISTINCT(doi)) AS number_of_articles 
    FROM
        `oadoi_full.feb_19_mongo_export_2013_Feb2019_full_all_genres`,
        UNNEST(oa_locations) 
    WHERE
        genre = 'journal-article' 
        AND year < 2019 
        AND is_best = true
    GROUP BY
        year,
        host_type,
        journal_is_in_doaj