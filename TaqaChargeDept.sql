select id, Charge_Department, sum(Charge_Dept_Downtime_Rate) as Charge_Dept_Downtime_Rate
from (

select cd.id, cd.strDescription as "Charge_Department",


round(sum(ifnull(round(100*if((case when ao.dtmOfflineFrom between '2020-07-14' and '2021-07-15' and (ao.dtmOffLineTo > '2021-07-15' or ao.dtmOffLineTo is null) then '2021-07-15 00:00:00'
when ao.dtmOfflineFrom between '2020-07-14' and '2021-07-15' and (ao.dtmOffLineTo <= '2021-07-15') then ao.dtmOffLineTo
when ao.dtmOfflineFrom < '2020-07-14' and ao.dtmOffLineTo between '2020-07-14' and '2021-07-15' 
then ao.dtmOfflineTo end)
and
(case when ao.dtmOfflineFrom < '2020-07-14' and ao.dtmOffLineTo between '2020-07-14' and '2021-07-15' then '2020-07-14'
when ao.dtmOfflineFrom between '2020-07-14' and '2021-07-15' then ao.dtmOfflineFrom end),
timestampdiff(hour,ao.dtmOffLineFrom, ao.dtmOfflineTo)/24, null)/
(timestampdiff(hour,'2020-07-14 11:59:00', '2021-07-15 00:00:00')/24),2),0))/count(cd.id),2) as "Charge_Dept_Downtime_Rate"


from tblAssetOfflineTracker ao 
left join tblAsset a on ao.intAssetID = a.id
left join tblChargeDepartment cd on cd.id = a.intChargeDepartmentID
where a.intTenantID = 37093
and cd.id is not null
and a.intKind = 2


group by cd.id) t group by Charge_Department





