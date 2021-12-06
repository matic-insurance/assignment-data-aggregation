with dates as (
select 
	date_trunc('day', dd):: date as date
from 
	generate_series( '2014-01-01' , now(), '1 day') dd
),

valid_policies as (
select 
	* 
from 
	development_staging.stg_policies p2
where 
	p2.policy_id in (
		select 
			p.policy_id

		from 
			development_staging.stg_policies p
			left join
			development_staging.stg_leads l 
			on p.lead_id = l.lead_id
		where p.status!='never_bound'
			and l.disposition_type!='test_request'
	)
),

states as (
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



final as (
select 
	p.policy_id,
	p.policy_type,
	c.key carrier,
	p.premium,
	p.sale_date,
	p.effective_date,
	p.expiration_date,
	p.cancellation_date,
	p.status,
	p.lead_id,
	(case 
		when p.transaction_type in (
			'new_business', 
			'cross_sale', 
			'undefined') 
			and
			p.sale_date is not null
		then 
			true 
		else 
			false 
	end) x_is_sold,
	(case 
		when p.renewed_policy_id is not null 
			then true 
		else 
			false 
		end) x_is_renewed,
	s.home_state property_state,
	(select 
		count(*) 
	from 
		active_policies ap
	where 
		ap.date=p.sale_date) active_policies_count,
	
	p.renewed_policy_id

from 
	valid_policies p
	left join 
	development_staging.stg_carriers c
	on p.carrier_id=c.carrier_id
	left join
	states s
	on s.asset_id=p.asset_id
)

select * from final