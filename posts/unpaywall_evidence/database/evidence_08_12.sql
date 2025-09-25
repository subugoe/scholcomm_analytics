SELECT
        evidence,
        year,
        is_best,
        COUNT(distinct(doi)) AS number_of_articles 
    FROM
        `oadoi_full.feb_19_mongo_export_2008_2012_full_all_genres`,
        UNNEST(oa_locations)
    WHERE
        genre = 'journal-article'
    GROUP BY
        evidence,
        year,
        is_best