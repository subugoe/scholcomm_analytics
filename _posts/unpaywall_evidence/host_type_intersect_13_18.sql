SELECT
        year,
        host_type_count,
        count(*) as number_of_articles      
    FROM
        (SELECT
            doi,
            year,
            STRING_AGG(DISTINCT(host_type)          
        ORDER BY
            host_type) as host_type_count          
        FROM
            `oadoi_full.feb_19_mongo_export_2013_Feb2019_full_all_genres`,
            UNNEST(oa_locations)          
        WHERE
            genre ='journal-article' 
            AND year < 2019         
        GROUP BY
            doi,
            year)      
    GROUP BY
        host_type_count,
        year      
    ORDER BY
        number_of_articles desc