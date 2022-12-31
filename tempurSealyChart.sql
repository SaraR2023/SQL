select iso.intWeek || '-' || iso.intYear as "Date",
t."pmsCO" as "pmsCarriedOver", t."site"
FROM tblIsoWeekCalendar iso

left join

(select Year(wo.dtmDateCreated) as "year", week(wo.dtmDateCreated,2) as "week",
count(distinct wo.id) as "pmsCO" , site.strName as "site"
from tblWorkOrder wo
inner join tblWorkOrderTask wot on wo.id = wot.intWorkOrderID
join tblWorkOrderAsset woa on woa.intWorkOrderID = wo.id
join tblAsset a on a.id = woa.intAssetID
join tblAsset site on site.id = a.intSiteID
where wo.intTenantID = 14418
and wot.intTenantID = 14418
#and wo.intSiteID = $P{Site}
and exists(Select distinct a1.id, ac.strName
from tblAsset a1
inner join tblAssetCategory ac on a1.intCategoryID = ac.id
inner join tblAssetCategoryResolved ar on ac.id = ar.intChildID
#where ar.intParentID = $P{ASSETCATEGORYID}
and ac.intTenantID = 14418
and ar.intTenantID = 14418
and a1.intTenantID = 14418
)
and wo.dtmDateCreated between '2021-10-01' and '2021-10-23'
and wo.dtmDateCompleted is null
and wo.intScheduledMaintenanceID is not null
group by week(wo.dtmDateCreated,2), site.strName
order by year(wo.dtmDateCreated), week(wo.dtmDateCreated,2))  t on t."week"= iso.intWeek and t."year" = iso.intYear
where iso.dtmWeekStart between '2021-10-01' and '2021-10-27'
order by iso.intYear, iso.intWeek