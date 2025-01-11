WITH season_batsman_stats AS (
    SELECT
        m.season,
        d.batsman,
        SUM(d.batsman_runs) AS total_runs,
        COUNT(*) AS balls_faced
    FROM matches m
    JOIN deliveries d ON m.id = d.match_id
    GROUP BY m.season, d.batsman
)
SELECT
    season,
    batsman,
    total_runs,
    balls_faced,
    ROUND((total_runs * 100.0) / NULLIF(balls_faced, 0), 2) AS strike_rate
FROM season_batsman_stats
WHERE balls_faced > 0
ORDER BY season, strike_rate DESC;
