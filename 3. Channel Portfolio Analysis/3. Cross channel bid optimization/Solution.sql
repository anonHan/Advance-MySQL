SELECT 
    ws.device_type,
    ws.utm_source,
    COUNT(ws.website_session_id) AS sessions,
    COUNT(o.order_id) AS orders,
    ROUND((COUNT(o.order_id) / COUNT(ws.website_session_id)) * 100,
            2) AS 'cvr'
FROM
    website_sessions ws
        LEFT JOIN
    orders o ON o.website_session_id = ws.website_session_id
WHERE
    ws.created_at > '2012-08-22'
        AND ws.created_at < '2012-10-19'
        AND ws.utm_campaign = 'nonbrand'
        #AND ws.utm_source IN ('gsearch' , 'bsearch')
        #AND ws.device_type IN ('mobile' , 'desktop')
GROUP BY 1,2;
