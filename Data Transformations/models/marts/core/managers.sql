with hub_staffs as ( select * from {{ref("hub_staffs")}} ),

sat_staffs_contact as ( select * from {{ref("sat_staffs_contact")}} ),

sat_staffs_profile as ( select * from {{ref("sat_staffs_profile")}} ),

sat_staffs_details as ( select * from {{ref("sat_staffs_details")}} ),

link_stores_staffs as ( select * from {{ref("link_stores_staffs")}} ),

dim_stores as ( select * from {{ref("dim_stores")}} ),

dim_geography as ( select * from {{ref("dim_geography")}} ),

details as (

    select
        hs.STAFF_PK,
        hs.staff_id,
        first_name,
        last_name,
        ssc.phone,
        ssc.email,
        active,
        manager_id,
        state
    from hub_staffs hs
        join sat_staffs_contact ssc on hs.STAFF_PK = ssc.STAFF_PK
        join sat_staffs_profile ssp on hs.STAFF_PK = ssp.STAFF_PK
        join sat_staffs_details ssd on hs.STAFF_PK = ssd.STAFF_PK
        join link_stores_staffs lss on hs.STAFF_PK = lss.STAFF_PK
        join dim_stores ds on lss.STORE_PK = DS.STORE_PK
        join dim_geography dg on ds.GEOGRAPHY_PK = dg.GEOGRAPHY_PK

),

final as (

    select
        distinct(manager_id.manager_id) as manager_id,
        manager_details.STAFF_PK,
        manager_details.staff_id,
        manager_details.first_name,
        manager_details.last_name,
        manager_details.phone,
        manager_details.email,
        manager_details.active,
        manager_details.state
    from 
        details as manager_id
        join details as manager_details on manager_id.manager_id = manager_details.staff_id

)

select
    manager_id,
    first_name,
    last_name,
    phone,
    email,
    active,
    state
from final