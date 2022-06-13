SELECT 
    utm_campaign,
    utm_source,
    http_referer,
    COUNT(website_session_id) AS Total_Sessions
FROM
    website_sessions
WHERE
    created_at <= '2012-04-11'
GROUP BY 1 , 2 , 3;
