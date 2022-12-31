select 
a.strCode as "Asset Code", 
a.strName as "Asset Name", 
ac.strName as "Asset Category", 
extractvalue(convert(a.strSysCustomColumnValues using utf8), '/ccvs/ccv[@name = "Machine_Size"]') as "Machine Size",
extractvalue(convert(a.strSysCustomColumnValues using utf8), '/ccvs/ccv[@name = "Supplier"]') as "Supplier",
a1.strName as "Location", 
mr.dtmDateSubmitted as "Meter Reading Date",
mr.dblMeterReading as "Meter Reading",
mru.strName as "Meter Reading Unit Type",

IF(@ID=a.strCode, mr.dblMeterReading - @prev_dblMeterReading, null) as "Difference From Last Reading",
IF(@ID=a.strCode, timestampdiff(day,@prev_dtmDateSubmitted,mr.dtmDateSubmitted), null) as "Days Between Meter Readings",
@row_number:=CASE WHEN @ID=a.strCode THEN @row_number+1 ELSE 1 END AS row_number,
@ID:=a.strCode AS ID,
@ID1:=a.strCode AS ID1,
@prev_dblMeterReading:= mr.dblMeterReading as "Meter Reading1",
@prev_dtmDateSubmitted:= mr.dtmDateSubmitted as "Meter Reading Date1"

from tblAsset a
inner join tblAssetCategory ac on a.intCategoryID = ac.id
inner join tblAsset a1 on a1.id = a.intAssetLocationID
inner join tblMeterReading mr on mr.intAssetID = a.id
inner join tblMeterReadingUnit mru on mr.intMeterReadingUnitsID = mru.id
, (select @prev_dblMeterReading:= 0 as num) as b
, (select @prev_dtmDateSubmitted:= 0 as num) as c
, (SELECT @row_number:=0, @ID:='', @prev_dblMeterReading := NULL) AS d
, (SELECT @row_number:=0, @ID1:='', @prev_dtmDateSubmitted := NULL) AS e
where a.intTenantID = 38798 and a.intKind = 2
and mr.dtmDateSubmitted between '2021-09-01' and '2021-09-10'
order by 2, 7 asc;


SELECT DISTINCT ac.strName as "categoryName",
(SELECT group_concat(distinct loc.strName) FROM tblAsset loc JOIN tblAsset a on loc.id = a.intAssetLocationID where a.intTenantID = 38798) as "Loc",
(SELECT group_concat(distinct mru.strName) FROM tblMeterReadingUnit mru where mru.intTenantID = 38798) as "mrUnit"
FROM
    tblAssetCategory ac
    INNER JOIN tblAsset a ON a.intCategoryID = ac.id
    inner JOIN tblAsset l ON l.id = a.intAssetLocationID
    inner JOIN tblMeterReading mr ON mr.intAssetID = a.id
    INNER JOIN tblMeterReadingUnit u ON mr.intMeterReadingUnitsID = u.id

WHERE a.intTenantID=38798 
AND mr.dtmDateSubmitted between '2021-09-01' and '2021-09-10';