SELECT 
    ws.utm_source,
    COUNT(ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT CASE
            WHEN ws.device_type = 'mobile' THEN website_session_id
            ELSE NULL
        END) AS traffic_from_mobile,
    ROUND((COUNT(DISTINCT CASE
                    WHEN ws.device_type = 'mobile' THEN website_session_id
                    ELSE NULL
                END) / COUNT(ws.website_session_id)) * 100,
            2) AS traffic_percent
FROM
    website_sessions ws
WHERE
    ws.created_at >'2012-08-22'
        AND ws.created_at < '2012-11-29'
        AND ws.utm_campaign = 'nonbrand'
        AND ws.utm_source IN ('gsearch' , 'bsearch')
GROUP BY 1;
