select 
	campaign_id, max(romi) as max_romi 
from (
	select 
		ad_date, campaign_id, sum(spend) as total_cost, sum(impressions) as impression_no,
		sum(clicks) as clicks_no, sum(value) as conversion_value, 
		round(sum(cast(spend as decimal))/sum(cast(clicks as decimal)),2) as CPC, 
		round((sum(cast(spend as decimal))/sum(cast(impressions as decimal))* 1000),2) as CPM,
		round((sum(cast(clicks as decimal))/sum(cast(impressions as decimal))* 100),2) as CTR,
		round(((sum(cast(value as decimal))-sum(cast(spend as decimal)))/sum(cast(spend as decimal)) * 100),2) as ROMI
	from
		facebook_ads_basic_daily 
	group by 
		ad_date, campaign_id
	having 
		sum(clicks) > 0
	and 
		sum(impressions) > 0
	) a
group by 
	campaign_id
order by 
	max_romi desc
limit 1
;