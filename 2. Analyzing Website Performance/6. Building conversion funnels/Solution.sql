-- STEP 1: selecting relevant sessions

select 
ws.website_session_id, 
case when wpv.pageview_url='/products' then 1 else 0 end as products_page,
case when wpv.pageview_url='/the-original-mr-fuzzy' then 1 else 0 end as mf_page,
case when wpv.pageview_url='/cart' then 1 else 0 end as cart_page,
case when wpv.pageview_url='/shipping' then 1 else 0 end as shipping_page,
case when wpv.pageview_url='/billing' then 1 else 0 end as billing_page,
case when wpv.pageview_url='/thank-you-for-your-order' then 1 else 0 end as thankyou_page

from website_sessions ws left join website_pageviews wpv on wpv.website_session_id=ws.website_session_id 
where ws.created_at between '2012-08-05' and '2012-09-05' 
order by 1;

-- STEP 2:
create temporary table session_made_it
select website_session_id,
max(products_page) as products_made_it,
max(mf_page)as mf_made_it,
max(cart_page)as cart_made_it,
max(shipping_page)as shipping_made_it,
max(billing_page)as billing_made_it,
max(thankyou_page)as thankyou_made_it
from (select 
ws.website_session_id, 
case when wpv.pageview_url='/products' then 1 else 0 end as products_page,
case when wpv.pageview_url='/the-original-mr-fuzzy' then 1 else 0 end as mf_page,
case when wpv.pageview_url='/cart' then 1 else 0 end as cart_page,
case when wpv.pageview_url='/shipping' then 1 else 0 end as shipping_page,
case when wpv.pageview_url='/billing' then 1 else 0 end as billing_page,
case when wpv.pageview_url='/thank-you-for-your-order' then 1 else 0 end as thankyou_page

from website_sessions ws left join website_pageviews wpv on wpv.website_session_id=ws.website_session_id 
where ws.created_at between '2012-08-05' and '2012-09-05' and ws.utm_source='gsearch' and ws.utm_campaign='nonbrand' 
order by 1) as temp_table group by 1;

-- STEP 3: calculation
select count(smi.website_session_id), 
		count(distinct case when smi.products_made_it=1 then smi.website_session_id else null end) as products_clicks,
        count(distinct case when smi.mf_made_it=1 then smi.website_session_id else null end) as mf_clicks,
        count(distinct case when smi.cart_made_it=1 then smi.website_session_id else null end) as cart_clicks,
        count(distinct case when smi.shipping_made_it=1 then smi.website_session_id else null end) as shipping_clicks,
        count(distinct case when smi.billing_made_it=1 then smi.website_session_id else null end) as billing_clicks,
        count(distinct case when smi.thankyou_made_it=1 then smi.website_session_id else null end) as thankyou_clicks
        
from session_made_it as smi;
