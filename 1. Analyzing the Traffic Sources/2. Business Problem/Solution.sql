SELECT 
    COUNT(DISTINCT (ws.website_session_id)) AS sessions,
    COUNT(DISTINCT (o.order_id)) AS orders,
    COUNT(DISTINCT (o.order_id)) / COUNT(DISTINCT (ws.website_session_id)) AS session_to_order_conv_rate
FROM
    website_sessions ws
        LEFT JOIN
    orders O ON o.website_session_id = ws.website_session_id
WHERE
    ws.website_session_id < '2012-04-14'
        AND ws.utm_source = 'gsearch'
        AND ws.utm_campaign = 'nonbrand';
