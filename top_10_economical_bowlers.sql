 WITH match_ids_2015 AS (
    SELECT id
    FROM matches
    WHERE season = 2015
),
bowler_stats AS (
    SELECT
        bowler,
        SUM(total_runs) AS total_runs_conceded,
        COUNT(*) AS balls_bowled
    FROM deliveries
    WHERE match_id IN (SELECT id FROM match_ids_2015)
    GROUP BY bowler
),
economy_rate AS (
    SELECT
        bowler,
        total_runs_conceded,
        balls_bowled,
        (total_runs_conceded / (balls_bowled / 6.0)) AS economy
    FROM bowler_stats
    WHERE balls_bowled >= 6 -- Exclude bowlers with less than 1 over bowled
)
SELECT
    bowler,
    total_runs_conceded,
    balls_bowled,
    economy
FROM economy_rate
ORDER BY economy ASC
LIMIT 10;