WITH batsman_stats AS (
    SELECT
        d.batsman,
        m.season,
        SUM(d.batsman_runs) AS total_runs,
        COUNT(*) AS total_balls
    FROM deliveries d
    JOIN matches m
        ON d.match_id = m.id
    GROUP BY d.batsman, m.season
)
SELECT
    batsman,
    season,
    total_runs,
    total_balls,
    ROUND((CAST(total_runs AS DECIMAL) / total_balls) * 100, 2) AS strike_rate
FROM batsman_stats
ORDER BY batsman, season;

WITH dismissal_counts AS (
    SELECT
        bowler,
        player_dismissed,
        COUNT(*) AS dismissal_count
    FROM deliveries
    WHERE player_dismissed IS NOT NULL
    GROUP BY bowler, player_dismissed
)

SELECT
    bowler,
    player_dismissed,
    dismissal_count
FROM dismissal_counts
WHERE dismissal_count = (
    SELECT MAX(dismissal_count) FROM dismissal_counts
)
ORDER BY bowler, player_dismissed;
