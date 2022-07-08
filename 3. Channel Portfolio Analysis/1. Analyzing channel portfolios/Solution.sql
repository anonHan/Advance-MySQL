ELECT 
    MIN(DATE(created_at)) week_start, 
    COUNT(distinct case when utm_source='bsearch' then website_session_id else NULL end) as bsearch_sessions,
	COUNT(distinct case when utm_source='gsearch' then website_session_id else NULL end) as gsearch_sessions
FROM
    website_sessions
WHERE
    created_at BETWEEN '2012-08-22' AND '2012-11-29'
        AND utm_campaign = 'nonbrand'
GROUP BY WEEK(created_at);
