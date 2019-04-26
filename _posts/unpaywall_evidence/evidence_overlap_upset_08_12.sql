SELECT
        distinct(evidence),
        doi
    FROM`oadoi_full.feb_19_mongo_export_2008_2012_full_all_genres`, UNNEST(oa_locations)
    WHERE
        genre = 'journal-article'