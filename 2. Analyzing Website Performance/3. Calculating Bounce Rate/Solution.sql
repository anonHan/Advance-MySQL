-- Step 1: Gettting the session_id and pageview_id
CREATE TEMPORARY TABLE landing_pageview1
SELECT 
    wpv.website_session_id, MIN(wpv.website_pageview_id) as landing_page_id
FROM
    website_pageviews wpv left join website_sessions wb on wb.website_session_id = wpv.website_session_id
WHERE
    wpv.pageview_url = '/home'
        AND wpv.created_at < '2012-06-14'
GROUP BY 1;

# Step 2: getting the URL 
CREATE TEMPORARY TABLE landing_pageview_urls
SELECT 
    lpv.website_session_id, wpv.pageview_url
FROM
    landing_pageview1 lpv
        LEFT JOIN
    website_pageviews wpv ON wpv.website_pageview_id = lpv.landing_page_id;


# Step 3: getting bounce=1
CREATE TEMPORARY TABLE homepage_bounce
SELECT 
    lpv.website_session_id,
    lpv.pageview_url,
    COUNT(wpv.website_pageview_id) as pages_viewed
FROM
    landing_pageview_urls lpv
        LEFT JOIN
    website_pageviews wpv ON lpv.website_session_id = wpv.website_session_id
GROUP BY 1 , 2
HAVING COUNT(wpv.website_pageview_id) = 1;
Drop TEMPORARY TABLE homepage_bounce;


# Step 4: 
SELECT 
    COUNT(lpv.website_session_id) AS sessions,
    COUNT(hpb.pages_viewed) AS Bounced_sessions,
    ROUND((COUNT(hpb.pages_viewed) / COUNT(lpv.website_session_id)) * 100,
            2) AS Bounce_rate
FROM
    landing_pageview_urls lpv
        LEFT JOIN
    homepage_bounce hpb ON lpv.website_session_id = hpb.website_session_id;

select count(pages_viewed) from homepage_bounce;
