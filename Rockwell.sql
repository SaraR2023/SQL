select 
wo.strCode as "woCode", 
wos.strName as "woStatus", 
group_concat(distinct a.strName separator ';\n') as "assetName", 
a3.strName as "site",
group_concat(distinct a.strCode separator ';\n') as "assetCode",
(case when a.bolIsOnline = 1 then 'Online'
when a.bolIsOnline = 0 then 'Offline' end) as "assetState",
wo.dtmDateCompleted as "wo_completionDate", 
wo.strCompletionNotes as "wo_completionNotes", wo.strAdminNotes as "adminNotes",
a.strModel as "model", a.strSerialNumber as "serialNumber",
a.id as "assetID"
from tblWorkOrder wo
join tblWorkOrderStatus wos on wo.intWorkOrderStatusID = wos.id
join tblWorkOrderAsset woa on woa.intWorkOrderID = wo.id
join tblAsset a on woa.intAssetID = a.id
join tblAsset a3 on a3.id = a.intSiteID
join tblAssetResolved ar on a.id = ar.intDescendantID
where wo.intTenantID = 33834
and wo.strCode = 31028;

select * from tblFile f
join tblAsset a on a.id = f.intAssetID
where a.intTenantID = 31482
and a.strCode = 'TCS-BLR-02'
and f.bolImage = 1;

select fc.strContents, f.strLink from tblFile f
join tblAsset a on a.id = f.intAssetID 
join tblFileContents fc on fc.id = f.intFileContentsID
where a.intTenantID = 31482 and (fc.strContents is not null or f.strLink is not null)
and a.strCode = 'TCS-BLR-02';

select * from tblFileContents fc
join tblFile f on fc.id = f.intFileContentsID
join tblAsset a on a.id = f.intAssetID 
where fc.intTenantID = 31482
and a.strCode = 'TCS-BLR-02' limit 10;


select 
wot.strDescription as "wo_taskDescription",
a1.strName as "laborTaskAsset",
wot.strResult as "result"
from tblWorkOrderTask wot
join tblWorkOrder wo on wo.id = wot.intWorkOrderID
join tblAsset a1 on wot.intAssetID = a1.id
where wo.intTenantID = 33834
and wo.strCode = 31028;


select a2.strName as "part_Supply", 
wop.qtySuggestedQuantity as "suggestedQuantity", 
wop.qtyActualQuantityUsed as "actualQuantityUsed",
a.strName as "assetName"
from tblWorkOrder wo
join tblWorkOrderAsset woa on woa.intWorkOrderID = wo.id
join tblAsset a on woa.intAssetID = a.id
join tblWorkOrderPart wop on wop.intWorkOrderID = wo.id
join tblStock s on s.id = wop.intStockID
join tblAsset a2 on a2.id = s.intAssetID
where wo.intTenantID = 31482
and wo.strCode = 3921;


select 
mr.dblMeterReading as "lastReading", 
mru.strName as "mrUnit",
mr.dtmDateSubmitted as "dateSubmitted",
a.strName as "asset"
from tblWorkOrder wo 
join tblWorkOrderAsset woa on woa.intWorkOrderID = wo.id
join tblAsset a on woa.intAssetID = a.id
join tblMeterReading mr on mr.intAssetId = a.id
join tblLastMeterReading lmr on lmr.intMeterReadingID = mr.id
join tblMeterReadingUnit mru on mr.intMeterReadingUnitsID = mru.id 
where a.intTenantID = 33834
and wo.strCode = 31028
order by mr.id desc;


select 
f.strName as "fileName", 
f.intSize as "fileSize", 
fc.strMimeType as "fileType",
f.strLink as "preview"
from tblWorkOrder wo
join tblWorkOrderAsset woa on woa.intWorkOrderID = wo.id
join tblAsset a on woa.intAssetID = a.id
join tblFile f on f.intWorkOrderID = wo.id
join tblFile f1 on f1.id = f.intFileTypeID
join tblFileContents fc on fc.id = f.intFileContentsID
where wo.intTenantID = 31482
and wo.strCode = 3799;

select 
a.strName as "asset",
f.strName as "fileName", 
f.intSize as "fileSize", 
fc.strMimeType as "fileType",
f.strLink as "preview",
f.intFileTypeID as "file type Id"
from tblAsset a 
join tblFile f on f.intAssetID = a.id
join tblFileContents fc on fc.id = f.intFileContentsID
where a.intTenantID = 31482
and a.strCode = 'TCS-BLR-02';
#and f.bolImage = 1;
