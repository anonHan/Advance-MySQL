SELECT 
    wp.pageview_url, COUNT(ws.website_session_id) as sessions
FROM
    website_pageviews wp
        JOIN
    website_sessions ws ON ws.website_session_id = wp.website_session_id
WHERE
    ws.created_at < '2012-06-09'
GROUP BY 1;
