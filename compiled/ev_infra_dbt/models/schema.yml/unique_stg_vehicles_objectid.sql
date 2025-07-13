
    
    

select
    objectid as unique_field,
    count(*) as n_records

from ev_infra_analysis.staging.stg_vehicles
where objectid is not null
group by objectid
having count(*) > 1


