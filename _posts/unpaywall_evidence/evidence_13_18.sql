SELECT
        evidence,
        year,
        is_best,
        COUNT(distinct(doi)) AS number_of_articles 
    FROM
        `oadoi_full.feb_19_mongo_export_2013_Feb2019_full_all_genres`,
        UNNEST(oa_locations) 
    WHERE
        genre = 'journal-article'
        AND year < 2019 
    GROUP BY
        evidence,
        year,
        is_best