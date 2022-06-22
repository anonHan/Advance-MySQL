SELECT 
    MIN(DATE(ws.created_at)) AS week_start_date,
    COUNT(ws.website_session_id) AS sessions
FROM
    website_sessions ws
WHERE
    ws.created_at < '2012-05-10'
        AND ws.utm_source = 'gsearch'
        AND ws.utm_campaign = 'nonbrand'
GROUP BY YEAR(ws.created_at) , WEEK(ws.created_at);
