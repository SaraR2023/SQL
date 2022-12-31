Select a.intSiteID, a.strName,



(select count(distinct wo.id) 
from tblWorkOrder wo
inner join tblWorkOrderTask wot on wo.id = wot.intWorkOrderID
where wo.intTenantID = 14418
and wot.intTenantID = 14418
and exists(Select distinct a1.id, ac.strName
from tblAsset a1
inner join tblAssetCategory ac on a1.intCategoryID = ac.id
inner join tblAssetCategoryResolved ar on ac.id = ar.intChildID
#where ar.intParentID = $P{ASSETCATEGORYID}
and ac.intTenantID = 14418
and ar.intTenantID = 14418
and a1.intTenantID = 14418

)
and wo.intSiteID = a.intSiteID
and wo.dtmDateCreated between '2021-10-01' and '2021-10-23'
and wo.dtmDateCompleted is null
#and $X{IN, wo."intSiteID", sites}
and wo.intScheduledMaintenanceID is not null) as "PMs CarriedOver"


From tblAsset a
where a.bolIsSite = 1
and a.intTenantID = 14418
and a.intSysCode is null
order by 2;

show processlist;
kill 4352