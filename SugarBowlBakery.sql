select 
u.strFullName as "User", st.dblTimeEstimatedHours as "KRONOS", 
t."WOs" as "Total WOs", t."Total Hrs" as "Hrs Spent", u.strPersonnelCode as "Utilization",
round((t."Total Hrs"/st.dblTimeEstimatedHours),2) as "Total Utilization"

from tblScheduledMaintenance sm 
join tblScheduledTask st on st.intScheduledMaintenanceID=sm.id
join tblScheduledMaintenanceUser su on su.intScheduledMaintenanceID=sm.id
join tblUser u on su.intUserID = u.id
join tblWorkOrder wo on wo.intScheduledMaintenanceID=sm.id

left outer join 
(select 
wo.strCompletedByUsers as "User1" , count(wo.strCode) as "WOs", round(sum(wo.dblTimeSpentHours),2) as "Total Hrs"
from tblWorkOrder wo
join tblWorkOrderStatus wos on wo.intWorkOrderStatusID = wos.id
where wo.intTenantID = 33834
and date(wo.dtmDateCompleted) = '2021-09-08'
and wos.id in (176999,196900)
group by wo.strCompletedByUsers) t on t."User1" = u.strFullName

where sm.intTenantID = 33834
and sm.strCode = 'SM215'
group by u.strFullName
