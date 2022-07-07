create temporary table table1
SELECT 
    CASE
        WHEN wpv.pageview_url = '/billing' THEN '/billling'
        ELSE '/billing-2'
    END AS pageview_url,
    wpv.website_session_id,
    o.order_id
FROM
     website_pageviews wpv
        LEFT JOIN
   orders o ON wpv.website_session_id = o.website_session_id
WHERE
    wpv.created_at BETWEEN '2012-09-10 10:43:05' AND '2012-11-10'
        AND wpv.website_pageview_id > 53550
        AND wpv.pageview_url IN ('/billing' , '/billing-2');
        
-- STEP 2: blling to order counting
create temporary table table2
select website_session_id,
max(billing_page) as billing1_made_it,
max(billing_page2)as billing2_made_it
from 
(select ws.website_session_id,
case when wpv.pageview_url='/billing' then 1 else 0 end as billing_page,
case when wpv.pageview_url='/billing-2' then 1 else 0 end as billing_page2
from  website_sessions ws left join website_pageviews wpv on ws.website_session_id = wpv.website_session_id
WHERE
    wpv.created_at BETWEEN '2012-09-10 10:43:05' AND '2012-11-10'
        AND wpv.website_pageview_id > 53550
        AND wpv.pageview_url IN ('/billfing' , '/billing-2')) as temp group by 1 order by 1;


select t1.pageview_url, count(t1.website_session_id) as sessions,
count(distinct case when t2.billing1_made_it=1 then t2.website_session_id else null end) as billing_1, 
count(distinct case when t2.billing2_made_it=1 then t2.website_session_id else null end) as billing_2,
count(t1.order_id) as orders
from table1 t1 left join table2 t2 on t2.website_session_id=t1.website_session_id group by 1 order by 1 desc; 
