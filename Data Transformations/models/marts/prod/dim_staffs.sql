with hub_staffs as ( select * from {{ref("hub_staffs")}} ),

sat_staffs_contact as ( select * from {{ref("sat_staffs_contact")}} ),

sat_staffs_profile as ( select * from {{ref("sat_staffs_profile")}} ),

sat_staffs_details as ( select * from {{ref("sat_staffs_details")}} )

select
    hs.STAFF_PK,
    first_name,
    last_name,
    phone,
    email,
    active,
    manager_id
from hub_staffs hs
    join sat_staffs_contact ssc on hs.STAFF_PK = ssc.STAFF_PK
    join sat_staffs_profile ssp on hs.STAFF_PK = ssp.STAFF_PK
    join sat_staffs_details ssd on hs.STAFF_PK = ssd.STAFF_PK
