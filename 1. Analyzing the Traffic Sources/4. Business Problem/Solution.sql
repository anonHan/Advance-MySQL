 SELECT 
    ws.device_type,
    COUNT(DISTINCT (ws.website_session_id)) AS sessions,
    COUNT(DISTINCT (o.order_id)) AS orders,
    COUNT(DISTINCT (o.order_id)) / COUNT(DISTINCT (ws.website_session_id)) AS conv_rate
FROM
    website_sessions ws
        LEFT JOIN
    orders O ON O.website_session_id = ws.website_session_id
WHERE
    ws.created_at < '2012-05-11'
        AND ws.utm_source = 'gsearch'
        AND ws.utm_campaign = 'nonbrand'
GROUP BY ws.device_type;
