SELECT 
    MIN(DATE(created_at)) AS week_start,
    count(distinct case when utm_source='gsearch' and device_type='desktop' then website_session_id else null end) as g_dtop_sessions,
    count(distinct case when utm_source='bsearch' and device_type='desktop' then website_session_id else null end) as b_dtop_sessions,
    round((count(distinct case when utm_source='bsearch' and device_type='desktop' then website_session_id else null end)
		/count(distinct case when utm_source='gsearch' and device_type='desktop' then website_session_id else null end)
		)*100,2) as b_perc_of_g_dtop,
    count(distinct case when utm_source='gsearch' and device_type='mobile' then website_session_id else null end) as g_mobile_sessions,
	count(distinct case when utm_source='bsearch' and device_type='mobile' then website_session_id else null end) as g_mobile_sessions,
    round((count(distinct case when utm_source='bsearch' and device_type='mobile' then website_session_id else null end) 
		/count(distinct case when utm_source='gsearch' and device_type='mobile' then website_session_id else null end)
		)*100,2) as b_perc_of_g_mobile
FROM
    website_sessions
WHERE
    created_at > '2012-11-04'
        AND created_at < '2012-12-22'
        AND utm_campaign = 'nonbrand' group by week(created_at);
