 WITH super_over_stats AS (
    SELECT
        bowler,
        SUM(total_runs) AS total_runs_conceded,
        COUNT(*) AS balls_bowled
    FROM deliveries
    WHERE is_super_over = 1
    GROUP BY bowler
),
economy_rates AS (
    SELECT
        bowler,
        total_runs_conceded,
        balls_bowled,
        (total_runs_conceded / (balls_bowled / 6.0)) AS economy_rate
    FROM super_over_stats
)
SELECT
    bowler,
    economy_rate
FROM economy_rates
WHERE balls_bowled >= 6
ORDER BY economy_rate ASC