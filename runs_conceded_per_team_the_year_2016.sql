SELECT
    SUM(extra_runs) AS total_extra_runs,
    bowling_team
FROM
    deliveries
WHERE
    match_id in (select distinct(match_id) from matches where season =2016)
GROUP BY
    bowling_team;