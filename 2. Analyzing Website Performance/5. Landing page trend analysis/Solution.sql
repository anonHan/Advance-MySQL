CREATE TEMPORARY TABLE landing_page_ids
SELECT 
    MIN(DATE(wpv.created_at)) as week_start_date,
    wpv.website_session_id,
    min(wpv.website_pageview_id) as landing_page_id,
    count(wpv.website_pageview_id) as page_count
FROM
    website_pageviews wpv
        LEFT JOIN
    website_sessions ws ON ws.website_session_id = wpv.website_session_id
WHERE
    wpv.created_at BETWEEN '2012-06-01' AND '2012-08-31'
        AND ws.utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY YEAR(wpv.created_at) , WEEK(wpv.created_at),2;
Drop TEMPORARY TABLE landing_page_urls;
select * from landing_page_ids limit 100;

-- STEP 2: getting url of /home and /lander-1
CREATE TEMPORARY TABLE landing_page_urls
SELECT 
    lpi.week_start_date,
    lpi.website_session_id,
    lpi.page_count,
    wpv.pageview_url
FROM
    landing_page_ids lpi
        LEFT JOIN
    website_pageviews wpv ON wpv.website_pageview_id = lpi.landing_page_id
WHERE
    wpv.pageview_url IN ('/home' , '/lander-1');
select * from landing_page_urls;

-- STEP 3: bounce rate=1
SELECT 
    lpu.week_start_date,
    COUNT(DISTINCT CASE
            WHEN lpu.pageview_url = '/home' THEN lpu.website_session_id
            ELSE NULL
        END) AS home_sessions,
    COUNT(DISTINCT CASE
            WHEN lpu.pageview_url = '/lander-1' THEN lpu.website_session_id
            ELSE NULL
        END) AS lander1_sessions,
    ROUND((COUNT(DISTINCT CASE
                    WHEN lpu.page_count = 1 THEN lpu.website_session_id
                    ELSE NULL
                END) * 1.0 / COUNT(DISTINCT lpu.website_session_id)) * 100,
            2) AS bounce_rate
FROM
    landing_page_urls lpu
        LEFT JOIN
    website_pageviews wpv ON wpv.website_session_id = lpu.website_session_id
GROUP BY YEAR(lpu.week_start_date) , WEEK(lpu.week_start_date);
