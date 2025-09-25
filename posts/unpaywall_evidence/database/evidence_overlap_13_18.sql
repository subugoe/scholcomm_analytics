SELECT
        ev_cat,
        COUNT(distinct(doi)) AS number_of_articles 
    FROM(
        SELECT
                doi,
                STRING_AGG(DISTINCT(evidence), "&" ORDER BY evidence) AS ev_cat
            FROM
                `oadoi_full.feb_19_mongo_export_2013_Feb2019_full_all_genres`,
                UNNEST(oa_locations)
            WHERE
                genre = 'journal-article'
                AND year < 2019
            GROUP BY
                doi
    )
    GROUP BY
        ev_cat