
select t."site", trim(iso.intWeek) || '-' || trim(iso.intYear) as "Dat",
(case when t.planned is null then 0 else round(t."planned",2) end) as "PM",
round(t."planned" + t."unplanned",2) as "All"
FROM tblIsoWeekCalendar iso
LEFT OUTER JOIN
(
select site.id, site.strName as "site", Year(wot.dtmDateCompleted) as y, week(wot.dtmDateCompleted,2) as eek,
z."unplanned", u."planned"

from tblWorkOrderTask wot
inner join tblWorkOrder wo on wo.id = wot.intWorkOrderID
inner join tblAsset site on site.id = wo.intSiteID
join 
(select site.id as "id" , sum(wot.dblTimeSpentHours) as "unplanned"
from tblWorkOrderTask wot
inner join tblWorkOrder wo on wo.id = wot.intWorkOrderID
inner join tblMaintenanceType mt on wo.intMaintenanceTypeID = mt.id
join tblAsset site on site.id = wo.intSiteID
left join tblAsset a on a.id = wot.intAssetID
inner join tblAssetCategory ac on a.intCategoryID = ac.id
inner join tblAssetCategoryResolved ar on ac.id = ar.intChildID
where wot.dtmDateCompleted is not null
and wo.intTenantID = 14418
and ar.intParentID = 242818
#and wo.intSiteID = 4162895
and (mt.strDescription like '%UnPlanned%')
and wot.dtmDateCompleted between '2021-12-05 00:00:00' and '2021-12-11 23:59:00'
group by site.id) z on z."id" = site.id
join
(select site.id as "id" , sum(wot.dblTimeSpentHours) as "planned"
from tblWorkOrderTask wot
inner join tblWorkOrder wo on wo.id = wot.intWorkOrderID
inner join tblMaintenanceType mt on wo.intMaintenanceTypeID = mt.id
join tblAsset site on site.id = wo.intSiteID
left join tblAsset a on a.id = wot.intAssetID
inner join tblAssetCategory ac on a.intCategoryID = ac.id
inner join tblAssetCategoryResolved ar on ac.id = ar.intChildID
where wot.dtmDateCompleted is not null
and wo.intTenantID = 14418
and ar.intParentID = 242818
#and wo.intSiteID = 4162895
and (mt.strDescription like '%xPlanned%')
and wot.dtmDateCompleted between '2021-12-05 00:00:00' and '2021-12-11 23:59:00'
group by site.id) u on u."id" = site.id

where wo.intTenantID = 14418
and wot.dtmDateCompleted between '2021-12-05 00:00:00' and '2021-12-11 23:59:00'
#and wo.intSiteID = 4162895
group by site.id) t ON iso.intYear = t."y" AND iso.intWeek = t."eek"
Where iso.dtmWeekStart BETWEEN '2021-12-05 00:00:00' and '2021-12-11 23:59:00'
ORDER BY iso.id;

show processlist;
kill 22762