select trim(iso.intWeek) || '-' || trim(iso.intYear) as "Dat",
(case when t.smhours is null then 0 else t."smhours" end) as "PM",
(case when t.unplanned is null then 0 else t."unplanned" end) as "Un"
FROM tblIsoWeekCalendar iso
LEFT OUTER JOIN
(
select Year(wot.dtmDateCompleted) as y, week(wot.dtmDateCompleted,2) as eek,
sum(case when (mt.strDescription like '%xPlanned%') then wot.dblTimeSpentHours else 0 end) as "smhours",
sum(case when (mt.strDescription like '%UnPlanned%') then wot.dblTimeSpentHours else 0 end) as "unplanned"
from tblWorkOrderTask wot
inner join tblWorkOrder wo on wo.id = wot.intWorkOrderID
inner join tblMaintenanceType mt on wo.intMaintenanceTypeID = mt.id
where wot.dtmDateCompleted is not null
and wo.intTenantID = 14418
#and wo.intSiteID = $P{Site}
and exists(Select distinct a1.id, ac.strName
from tblAsset a1
inner join tblAssetCategory ac on a1.intCategoryID = ac.id
inner join tblAssetCategoryResolved ar on ac.id = ar.intChildID
#where ar.intParentID = $P{ASSETCATEGORYID}
and ac.intTenantID = 14418
and ar.intTenantID = 14418
and a1.intTenantID = 14418
#and a1.id = wot.intAssetID
)
group by Year(wot.dtmDateCompleted), week(wot.dtmDateCompleted,2)
) t ON iso.intYear = t."y" AND iso.intWeek = t."eek"
Where iso.dtmWeekEnd BETWEEN '2021-01-01' AND '2021-07-01'
ORDER BY iso.id