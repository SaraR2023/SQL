select 
   t."aCode"
 , t."asset"
 , t."kind"
 , group_concat(t."wCode" order by t."date" separator ';\n') as "woCode"
 , group_concat(t."date" order by t."date" separator ';\n') as "woDate"
 , count(*) as "TimesRCS"
from
(select distinct  
  a.strCode as "aCode"
, a.intKind as "kind"
, wo.strCode as "wCode"
, wo.dtmDateCompleted as "date"
, a.strName as "asset"
, (select ExtractValue(convert(ct.strSysCustomColumnValues USING utf8), '/ccvs/ccv[@name="CalibrationResult"]') 
	from tblDdCustomTableRow ct
		where ct.id = (select ExtractValue(convert(wo.strSysCustomColumnValues USING utf8), '/ccvs/ccv[@name="CalibrationResult"]') 
            from tblWorkOrder wo1 
				where wo1.intTenantID = wo.intTenantID 
				and wo1.id = wo.id
                      )
  ) as "calibrationResult"
, wo.dtmDatecompleted
from tblAsset a
	join tblWorkOrderAsset woa on a.id = woa.intAssetID
	join tblWorkOrder wo on wo.id = woa.intWorkOrderID
	join tblDdCustomTableRow ct on ct.intTenantID = wo.intTenantID
			where wo.intTenantID = 10105
			and ExtractValue(convert(wo.strSysCustomColumnValues USING utf8), '/ccvs/ccv[@name="CalibrationResult"]') = 100
            and a.intKind = 3
group by wo.dtmDatecompleted) t

group by t."aCode"
order by count(*);


/*200129697;
200165492;
200188997*/

select
ExtractValue(convert(wo.strSysCustomColumnValues USING utf8), '/ccvs/ccv[@name="CalibrationResult"]') from tblWorkOrder wo where
wo.intTenantID = 10105 and wo.strCode = 200165914 
*/


