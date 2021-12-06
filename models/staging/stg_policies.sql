with policies as (
	select 
		id policy_id,
		policy_type,
		asset_id,
		carrier_id,
		lead_id,
		premium,
		sale_date,
		effective_date,
		expiration_date,
		cancellation_date,
		status,
		transaction_type,
		renewed_policy_id

		from 
			development_data.policies
	)

select * from policies