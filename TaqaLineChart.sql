select 
month(ao.dtmOfflineFrom)  as "Month",
cd.strDescription as "Charge Department",

round(sum(ifnull(round(100*if((case when ao.dtmOfflineFrom between '2021-01-01' and '2021-08-01' and (ao.dtmOffLineTo > '2021-08-01' or ao.dtmOffLineTo is null) then '2021-08-01'
when ao.dtmOfflineFrom between '2021-01-01' and '2021-08-01' and (ao.dtmOffLineTo <= '2021-08-01') then ao.dtmOffLineTo
when ao.dtmOfflineFrom < '2021-01-01' and ao.dtmOffLineTo between '2021-01-01' and '2021-08-01' 
then ao.dtmOfflineTo end)
and
(case when ao.dtmOfflineFrom < '2021-01-01' and ao.dtmOffLineTo between '2021-01-01' and '2021-08-01' then '2021-01-01'
when ao.dtmOfflineFrom between '2021-01-01' and '2021-08-01' then ao.dtmOfflineFrom end),
timestampdiff(hour,ao.dtmOffLineFrom, ao.dtmOfflineTo)/24, null)/
(timestampdiff(hour,'2021-01-01', '2021-08-01')/24),2),0))/count(cd.id),2) as "Charge_Dept_Downtime_Rate"

from tblAssetOfflineTracker ao 
left join tblAsset a on ao.intAssetID = a.id
left join tblChargeDepartment cd on cd.id = a.intChargeDepartmentID
where a.intTenantID = 37093
and cd.id is not null
and a.intKind = 2
group by month(ao.dtmOfflineFrom), cd.strDescription


