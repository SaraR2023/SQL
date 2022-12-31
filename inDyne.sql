select wo.strCode as "woCode",t."poCode", u."user",
u."telNo", date(wo.dtmDateCompleted) as "date", date_format(wo.dtmDateCompleted, '%l:%i:%s %p') as "time",
site."building", site."room", wo.strDescription as "description",
pr."emergency", wo.strProblem as "assessment", wo.strCompletionNotes as "corrAction",
b."brokensNumber", b."brokenModel", z."part" , t."model", t."sNumber",t."partCost", t."totalCost", t."dtSubmitted",
r."dateAuth", r."dateReceiv", v."siteRep", z."phoneSolvedOrNot" 


from tblWorkOrder wo
left join (select group_concat(u.strFullName separator ';\n') as "user", wo.strCode as "code", u.strTelephone as "telNo"
from tblWorkOrder wo
join tblWorkOrderUser wou on wo.id = wou.intWorkOrderID
join tblUser u on u.id = wou.intUserID
where wo.intTenantID = 37666
group by wo.strCode) u on u."code" = wo.strCode
left join (select wo.strCode as "code", group_concat(distinct loc.strName separator ';\n') as "building", 
a.strName as "room"
from tblWorkOrder wo
join tblWorkOrderAsset woa on wo.id = woa.intWorkOrderID
join tblAsset a on a.id = woa.intAssetID
join tblAsset loc on loc.id = a.intAssetLocationID
join tblAssetCategory ac on ac.id = a.intCategoryID
where wo.intTenantID = 37666
group by wo.strCode) site on site."code" = wo.strCode
left join (select pr.strName as "emergency", wo.strCode as "code"
from tblWorkOrder wo
join tblPriority pr on wo.intPriorityID = pr.id
where wo.intTenantID = 37666) pr on pr."code" = wo.strCode
left join (select wo.strCode as "code", a.strName, lt.dblUnitPrice*lt.qtyOnOrder as "totalCost",
lt.dblUnitPrice as "partCost", a.strModel as "model", a.strSerialNumber as "sNumber",
po.intCode as "poCode", po.dtmDateSubmitted as "dtSubmitted"
from tblWorkOrder wo
join tblPurchaseOrderLineItem lt on lt.intSourceWorkOrderID = wo.id
join tblPurchaseOrder po on po.id = lt.intPurchaseOrderID
join tblAsset a on lt.intAssetID = a.id
join tblStock s on s.intAssetID = a.id
where wo.intTenantID = 37666) t on wo.strCode = t."code"
left join (select wo.strCode as "code", r.dtmDateOrdered as "dateAuth", r.dtmDateReceived as "dateReceiv"
from tblPurchaseOrder po 
join tblPurchaseOrderLineItem lt on lt.intPurchaseOrderID = po.id
join tblWorkOrder wo on lt.intSourceWorkOrderID = wo.id
join tblReceipt r on r.intPurchaseOrderID = po.id
where po.intTenantID = 37666) r on r."code" = wo.strCode
left join (select wo.strCode as "code", group_concat(part.strName separator ';\n') as "part",
wop.qtyActualQuantityUsed as "phoneSolvedOrNot"
from tblWorkOrder wo
join tblWorkOrderPart wop on wop.intWorkOrderID = wo.id
join tblStock s on s.id = wop.intStockID
join tblAsset part on part.id = s.intAssetID
where wo.intTenantID = 37666
group by wo.strCode) z on z."code" = wo.strCode
left join (select distinct site.strName as "site", u.strFullName as "siteRep"
from tblAsset a 
join tblAsset site on site.id = a.intSiteID
join tblAssetUser au on au.intAssetID = a.id
join tblUser u on u.id = au.intUserID
where a.intTenantID = 37666) v on v."site" = site."building"
left join (select wo.strCode as "code", a.strName as "brokensNumber", 
a.strModel as "brokenModel"
from tblWorkOrder wo
join tblWorkOrderPart wop on wop.intWorkOrderId = wo.id
join tblStock s on s.id = wop.intStockID
join tblAsset a on s.intAssetID = a.id
where wo.intTenantID = 37666) b on b."code" = wo.strCode

where wo.intTenantID = 37666
and wo.dtmDateCreated between '2020-06-01' and '2021-10-12'
group by wo.strCode