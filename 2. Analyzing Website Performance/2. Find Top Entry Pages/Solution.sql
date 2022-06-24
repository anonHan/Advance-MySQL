CREATE temporary TABLE top_pages
SELECT 
    wp.website_session_id, MIN(website_pageview_id) as page_id
FROM
    website_pageviews wp
        JOIN
    website_sessions ws ON ws.website_session_id = wp.website_session_id
WHERE
    ws.created_at < '2012-06-12'
GROUP BY 1;

-- Step 2: Get the required output
SELECT 
    wp.pageview_url, COUNT(DISTINCT tp.website_session_id)
FROM
    website_pageviews wp
        JOIN
    top_pages tp ON tp.page_id = wp.website_pageview_id
GROUP BY 1
ORDER BY 2 DESC;
