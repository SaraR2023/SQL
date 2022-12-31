select count(sm.id), date(ce.dtmDate) , group_concat(sm.strCode)
from tblCalendarEvent ce
join tblScheduledMaintenance sm on ce.intScheduledMaintenanceID = sm.id
join tblScheduledMaintenanceAsset sma on sma.intScheduledMaintenanceID = sm.id
join tblAsset a on sma.intAssetID = a.id 
join tblAssetResolved ar on ar.intDescendantID = a.id
where sm.intTenantID = 74872
and ce.dtmDate between now() and date_add(now(), interval 365 day)
and ar.intAncestorID = 21495084
group by date(ce.dtmDate)
order by ce.dtmDate;


select distinct sm.strCode, date(ce.dtmDate), a.strName, a.strSerialNumber, sm.strDescription, 
count(distinct st.id) as "taskSteps"
from tblScheduledMaintenance sm
join tblCalendarEvent ce  on ce.intScheduledMaintenanceID = sm.id
join tblScheduledTask st on st.intScheduledMaintenanceID = sm.id
join tblScheduledMaintenanceAsset sma on sma.intScheduledMaintenanceID = sm.id
join tblAsset a on sma.intAssetID = a.id 
join tblAssetResolved ar on ar.intDescendantID = a.id
where sm.intTenantID = 74872
and ce.dtmDate between now() and date_add(now(), interval 365 day)
#and ar.intAncestorID = 21495084
group by sm.id
order by ce.dtmDate asc
limit 10;
