
  create or replace   view ev_infra_analysis.dbt.my_second_dbt_model
  
  
  
  
  as (
    -- Use the `ref` function to select from other models

select *
from ev_infra_analysis.dbt.my_first_dbt_model
where id = 1
  );

