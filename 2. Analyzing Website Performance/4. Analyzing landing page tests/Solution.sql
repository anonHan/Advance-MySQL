-- STEP 1: First we will get the date on which the first lander-1 page was deployed, then only we will be able to make a comparision between lander1 and home page
select min(created_at),min(website_pageview_id) from website_pageviews where pageview_url='/lander-1';

-- STEP 2: Selecting pageview ids of 'lander-1' and 'home' page
CREATE TEMPORARY TABLE landing_page_ids
SELECT 
    wpv.website_session_id,
    MIN(wpv.website_pageview_id) AS landing_page_id
FROM
    website_pageviews wpv
        LEFT JOIN
    website_sessions ws ON ws.website_session_id = wpv.website_session_id
WHERE
    wpv.created_at BETWEEN '2012-06-19 11:05:54' AND '2012-07-28'
        AND ws.utm_source = 'gsearch'
        AND ws.utm_campaign = 'nonbrand'
GROUP BY 1;
select * from landing_page_ids limit 10;

-- STEP 3: getting urls
CREATE TEMPORARY TABLE landing_page_urls
SELECT 
    lpi.website_session_id, wpv.pageview_url AS landing_page_url
FROM
    landing_page_ids lpi
        LEFT JOIN
    website_pageviews wpv ON wpv.website_pageview_id = lpi.landing_page_id
WHERE
    wpv.pageview_url IN ('/home' , '/lander-1'); -- non-brand-test-session-w-landing-page
    
-- STEP 4: bounce rate = 1
CREATE TEMPORARY TABLE bounce_sessions_only
SELECT 
    lpu.website_session_id,
    lpu.landing_page_url,
    COUNT(wpv.website_pageview_id) as page_visit_count
FROM
    landing_page_urls AS lpu
        LEFT JOIN
    website_pageviews wpv ON wpv.website_session_id = lpu.website_session_id
GROUP BY 1 , 2 having COUNT(wpv.website_pageview_id)=1;  -- nonbrand-test-bounced-sessions

-- STEP 5: 
SELECT 
    lpu.landing_page_url,
     bso.page_visit_count,
     lpu.website_session_id
FROM
    bounce_sessions_only bso
        LEFT JOIN
    landing_page_urls lpu ON lpu.website_session_id = bso.website_session_id;
