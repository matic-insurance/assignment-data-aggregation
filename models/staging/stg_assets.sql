with assets as(
	select 
		id asset_id,
		customer_id,
		details_id,
		details_type 
	from 
		development_data.assets
)

select * from assets