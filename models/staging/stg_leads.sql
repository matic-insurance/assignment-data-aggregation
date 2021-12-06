with distinct_leads as (
select 
	id lead_id,
	disposition_type
from(	
	select
		distinct * 
	from 
		development_data.leads l
) a
)



select * from distinct_leads