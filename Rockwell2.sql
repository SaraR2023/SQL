select wos.strName as "status", count(distinct wo.id) as "woCount"

from tblWorkOrder wo
left join tblWorkOrderStatus wos on wo.intWorkOrderStatusID = wos.id
where wo.intTenantID = 31482
and wo.dtmDateCreated between date_sub(now(), interval 365 day) and now()
group by wos.id;

select wo.strCode as "woCode", count(a.strCode) as "assetCount"

from tblWorkOrder wo
join tblWorkOrderAsset woa on wo.id = woa.intWorkOrderID
join tblAsset a on a.id = woa.intAssetID
where wo.intTenantID = 31482
and wo.dtmDateCompleted between date_sub(now(), interval 365 day) and now()
group by wo.id;

select wo.strCode as "woCode", count(wot.id) as "wotCount"

from tblWorkOrder wo
join tbltblWorkOrderTask wot on 

