 select CDID, Charge_Dept, ID_AC, Asset_Category, Category_Downtime_Rate, Charge_Dept_Downtime_Rate, Total
 #case when CDID is null then 'Other' else Charge_Dept end as Charge_Dept1
 
 from  
 
 (select cd.id as CDID, cd.strDescription as "Charge_Dept", ac.id as "ID_AC", ac.strName as "Asset_Category",

round(sum(ifnull(round(100*if((case when ao.dtmOfflineFrom between '2021-01-01' and '2021-08-01' and (ao.dtmOffLineTo > '2021-08-01' or ao.dtmOffLineTo is null) then '2021-08-01'
when ao.dtmOfflineFrom between '2021-01-01' and '2021-08-01' and (ao.dtmOffLineTo <= '2021-08-01') then ao.dtmOffLineTo
when ao.dtmOfflineFrom < '2021-01-01' and ao.dtmOffLineTo between '2021-01-01' and '2021-08-01' 
then ao.dtmOfflineTo end)
and
(case when ao.dtmOfflineFrom < '2021-01-01' and ao.dtmOffLineTo between '2021-01-01' and '2021-08-01' then '2021-01-01' 
when ao.dtmOfflineFrom between '2021-01-01' and '2021-08-01' then ao.dtmOfflineFrom end),
timestampdiff(hour,ao.dtmOffLineFrom, ao.dtmOfflineTo)/24, null)/
(timestampdiff(hour,'2021-01-01', '2021-08-01')/24),2),0))/count(ac.id),2) as Category_Downtime_Rate


from tblAssetOfflineTracker ao 
left join tblAsset a on ao.intAssetID = a.id
left join tblAssetCategory ac on ac.id = a.intCategoryID
left join tblChargeDepartment cd on cd.id = a.intChargeDepartmentID
where a.intTenantID = 37093
and ao.dtmOfflineFrom between '2021-01-01' and '2021-08-01'
and a.intKind = 2
group by ac.strName) b

right join 

(select id as "CD_ID", Charge_Department, sum(Charge_Dept_Downtime_Rate) as "Total", Charge_Dept_Downtime_Rate

from

(select cd.id, cd.strDescription as "Charge_Department",


round(sum(ifnull(round(100*if((case when ao.dtmOfflineFrom between '2021-01-01' and '2021-08-01' and (ao.dtmOffLineTo > '2021-08-01' or ao.dtmOffLineTo is null) then '2021-08-01'
when ao.dtmOfflineFrom between '2021-01-01' and '2021-08-01' and (ao.dtmOffLineTo <= '2021-08-01') then ao.dtmOffLineTo
when ao.dtmOfflineFrom < '2021-01-01' and ao.dtmOffLineTo between '2021-01-01' and '2021-08-01' 
then ao.dtmOfflineTo end)
and
(case when ao.dtmOfflineFrom < '2021-01-01' and ao.dtmOffLineTo between '2021-01-01' and '2021-08-01' then '2021-01-01'
when ao.dtmOfflineFrom between '2021-01-01' and '2021-08-01' then ao.dtmOfflineFrom end),
timestampdiff(hour,ao.dtmOffLineFrom, ao.dtmOfflineTo)/24, null)/
(timestampdiff(hour,'2021-01-01', '2021-08-01')/24),2),0))/count(cd.id),2) as Charge_Dept_Downtime_Rate


from tblAssetOfflineTracker ao 
left join tblAsset a on ao.intAssetID = a.id
#left join tblAssetCategory ac on ac.id = a.intCategoryID
left join tblChargeDepartment cd on cd.id = a.intChargeDepartmentID
where a.intTenantID = 37093
and ao.dtmOfflineFrom between '2021-01-01' and '2021-08-01'
and cd.id is not null
and a.intKind = 2
group by cd.id) t
group by Charge_Department) c

on b.Charge_Dept = c.Charge_Department