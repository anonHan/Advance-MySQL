SELECT 
    MIN(ws.created_at) AS week_start_date,
    COUNT(CASE
        WHEN ws.device_type = 'desktop' THEN ws.website_session_id
        ELSE NULL
    END) AS desktop_sessions,
    COUNT(CASE
        WHEN ws.device_type = 'mobile' THEN ws.website_session_id
        ELSE NULL
    END) AS mobile_sessions
FROM
    website_sessions ws
WHERE
    ws.created_at < '2012-06-09'
        AND ws.created_at > '2012-04-15'
        AND ws.utm_source = 'gsearch'
        AND ws.utm_campaign = 'nonbrand'
GROUP BY YEAR(ws.created_at) , WEEK(ws.created_at);
