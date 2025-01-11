SELECT
    winner AS team_name,
    COUNT(*) AS toss_and_match_wins
FROM
    matches
WHERE
    toss_winner = winner
GROUP BY
    winner
ORDER BY
    toss_and_match_wins DESC;