SELECT
        ev_cat,
        year,
        COUNT(*) AS number_of_articles 
    FROM(
        SELECT
                doi,
                year,
                genre,
                STRING_AGG(DISTINCT(evidence) ORDER BY evidence) AS ev_cat
            FROM
                `oadoi_full.feb_19_mongo_export_2008_2012_full_all_genres`,
                UNNEST(oa_locations)
            WHERE
                genre = 'journal-article'
            GROUP BY
                doi,
                year
    )
    GROUP BY
        ev_cat,
        year