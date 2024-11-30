--Tema 3

with fabd as
( 
	select 'facebook' as source,
		ad_date, campaign_name, spend, impressions, reach, clicks, leads, value
	from 
		public.facebook_ads_basic_daily d
	join 
		public.facebook_campaign c on d.campaign_id = c.campaign_id
		
union 

	select 'google' as source,
		ad_date, campaign_name, spend, impressions, reach, clicks, leads, value
	from
		public.google_ads_basic_daily)
	
		
select 
	ad_date, campaign_name, sum(spend) as total_cost, sum(impressions) as impression_no,
	sum(clicks) as clicks_no, sum(value) as conversion_value
from
	fabd
group by
	ad_date, campaign_name
	
	
	
--Bonus tema 3	
		
/*	
select * from public.facebook_ads_basic_daily 	-  campaign_id, adset_id

select * from public.facebook_adset				- adset_id, adset_name

select * from public.facebook_campaign			- campaign_id, campaign_name

select * from public.google_ads_basic_daily		- campaign_name, adset_name
*/


with all_tabels as	
(
	select 
		g.adset_name, g.campaign_name,  
		sum(b.spend) total_cost, sum(b.value) total_value,
		round(((sum(cast(b.value as decimal))-sum(cast(b.spend as decimal))/(sum(cast(b.spend as decimal)))*100)),2) ROMI
	from
		public.facebook_ads_basic_daily b
	join
		public.facebook_adset a on b.adset_id = a.adset_id
	join 
		public.facebook_campaign c on b.campaign_id = c.campaign_id 
	join 
		public.google_ads_basic_daily g on g.campaign_name = c.campaign_name
	group by
		g.adset_name, g.campaign_name
	having 
		sum(b.spend) > 500000
)
	
select 
	campaign_name, sum(ROMI) ROMI
from
	all_tabels
group by
	campaign_name, ROMI
order by 
	ROMI desc limit 1

	

