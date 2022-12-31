select

(select group_concat(DISTINCT(u2.strUserName)) from tblMeterReading mr3 inner join tblUser u2 on mr3.intSubmittedByUserID = u2.id where $X{IN,mr3.intSubmittedByUserID,userid}) as "RecordedByUsers",

(select group_concat(DISTINCT(ac1.strName)) from tblAsset a1 inner join tblAssetCategory ac1 on a1.intCategoryID = ac1.id where $X{IN, a1.intCategoryID, ASSETCATEGORYID}) as "AssetCategories",

(select group_concat(DISTINCT(a1.strName)) from tblAsset a1 where $X{IN, a1.id, assetid}) as "AssetNames",

a.strCode as "Asset Code", a.strName as "Asset Name", a.strSerialNumber as "Serial Number", 
ac.strName as "Asset Category", lmr.dblMeterReading as "Latest Meter Reading", mu.strName as "Unit Type", 
lmr.dtmDateSubmitted as "Last Date Recorded", u.strUserName as "Recorded By", imr.dblMeterReading as "Initial Meter Reading", 
imr.dtmDateSubmitted as "Initial Date Recorded", wo.strCode as "WO Code"

#(lmr.dblMeterReading - emr.dblMeterReading)

from tblAsset a inner join tblAssetCategory ac on a.intCategoryID = ac.id
inner join tblAssetCategoryResolved ar on ac.id = ar.intChildID
inner join tblMeterReadingUnit mu on mu.intTenantID = .a.intTenantID
inner join tblMeterReading lmr on lmr.id = (select mr1.id from tblMeterReading mr1 where mr1.intAssetID = a.id and mr1.intMeterReadingUnitsID=mu.id and mr1.dtmDateSubmitted between $P{FROM_DATE_TIMESTAMP} and $P{TO_DATE_TIMESTAMP} order by mr1.dtmDateSubmitted DESC limit 1)
inner join tblMeterReading emr on emr.id = (select mr1.id from tblMeterReading mr1 where mr1.intAssetID = a.id and mr1.intMeterReadingUnitsID=mu.id and mr1.dtmDateSubmitted between $P{FROM_DATE_TIMESTAMP} and $P{TO_DATE_TIMESTAMP} order by mr1.dtmDateSubmitted ASC limit 1)

inner join tblMeterReading imr on imr.id = (select mr2.id from tblMeterReading mr2 where mr2.intAssetID = a.id and mr2.intMeterReadingUnitsID=mu.id order by mr2.dtmDateSubmitted ASC limit 1)
left outer join tblUser u on u.id = lmr.intSubmittedByUserID
left outer join tblWorkOrder wo on wo.id = lmr.intWorkOrderID

where a.intTenantID = $P{tenant}
and $X{IN, a.id, assetid}
and $X{IN, a.intCategoryID, ASSETCATEGORYID}
and $X{IN, lmr.intSubmittedByUserID, userid}

group by a.id, mu.id
order by a.strcode ASC