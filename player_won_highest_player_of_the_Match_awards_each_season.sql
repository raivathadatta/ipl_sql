WITH player_awards AS (
    SELECT
        season,
        player_of_match,
        COUNT(*) AS awards
    FROM matches
    GROUP BY season, player_of_match
),
max_awards AS (
    SELECT
        season,
        MAX(awards) AS max_awards
    FROM player_awards
    GROUP BY season
)
SELECT
    pa.season,
    pa.player_of_match,
    pa.awards
FROM player_awards pa
JOIN max_awards ma
    ON pa.season = ma.season AND pa.awards = ma.max_awards
ORDER BY pa.season;