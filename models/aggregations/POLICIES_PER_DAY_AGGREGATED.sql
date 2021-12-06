with states as (
select 
	assets.asset_id,
	home_details.state home_state

from 
	development_staging.stg_assets assets
	join
	development_staging.stg_home_details home_details
	on assets.details_id=home_details.home_detail_id
where
	assets.details_type = 'HomeDetails'

),

dates as (
select 
	date_trunc('day', dd):: date as date
from 
	generate_series( '2014-01-01' , now(), '1 day') dd
),



valid_policies as (
select 
	*
from 
	development_staging.stg_policies p
	left join
	development_staging.stg_leads l 
	on p.lead_id = l.lead_id
where p.status!='never_bound'
	and l.disposition_type!='test_request'
),

active_policies as (
select 
	*
from dates, valid_policies p
where  
	(p.cancellation_date is not null	
		and 
	date>=p.effective_date 
		and 
	date < p.cancellation_date)
	or
	(
	p.cancellation_date is  null	
		and 
	date>=p.effective_date 
		and 
	date < p.expiration_date
	)

),

final_without_states as (
select 
	dates.date,
	policy_id,
	sale_date,
	asset_id,
	status
from 
	dates
	left join
	active_policies
	on dates.date = active_policies.date

),

final as (
select 
	date,
	policy_id,
	sale_date,
	home_state,
	status
from 
	final_without_states f
	left join
	states s
	on s.asset_id=f.asset_id
)

select * from final



