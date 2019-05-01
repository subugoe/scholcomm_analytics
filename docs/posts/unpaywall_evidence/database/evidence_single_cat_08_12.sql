SELECT
        ev_cat,
        COUNT(distinct(doi)) AS number_of_articles 
    FROM(
        SELECT
                doi,
                STRING_AGG(DISTINCT(evidence), "&" ORDER BY evidence) AS ev_cat
            FROM
                `oadoi_full.feb_19_mongo_export_2008_2012_full_all_genres`,
                UNNEST(oa_locations)
            WHERE
                genre = 'journal-article'
            GROUP BY
                doi
    )
    GROUP BY
        ev_cat