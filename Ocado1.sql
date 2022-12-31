/*MASOPS*/
select 
wo.strCode woCode
, group_concat(a.strCode order by a.id asc separator ';\n') aCode
, group_concat(a.strName order by a.id asc separator ';\n') aName
, wo.strDescription woDescription
, wo.dtmDateCompleted
, wo.dblTimeSpentHours
, wo.strCompletionNotes
, case when wo.dtmDateCompleted is null then 'Yes' else 'No' end as followup
, (select ExtractValue(convert(ct.strSysCustomColumnValues USING utf8), '/ccvs/ccv[@name="Importance"]') 
	from tblDdCustomTableRow ct
		where ct.id in (select ExtractValue(convert(a1.strSysCustomColumnValues USING utf8), '/ccvs/ccv[@name="Importance"]') 
            from tblAsset a1 
				where a1.intTenantID = a.intTenantID
                and a1.id = a.id
                )) as shiftTeam
from tblWorkOrder wo
join tblWorkOrderAsset woa on wo.id = woa.intWorkOrderID
join tblAsset a on a.id = woa.intAssetID
left join tblDdCustomTableRow ct on ct.intTenantID = a.intTenantID and ct.id = ExtractValue(convert(a.strSysCustomColumnValues USING utf8), '/ccvs/ccv[@name="Importance"]') 
where wo.intTenantID = 75992
and wo.dtmDateCompleted between '2022-07-01' and '2022-07-31'
and ct.id = 44785
and a.intKind = 2
and a.intAssetLocationID in 
(
select a.id

from tblAsset a 
join tblAsset loc on loc.id = a.intAssetLocationID
where a.intTenantID = 75992
and a.intSiteID = 21962402
and loc.id in (22026591, 22026592, 22026593)
and a.intKind = 1)
group by wo.id;

/*Bagging*/
select 
wo.strCode woCode
, group_concat(a.strCode order by a.id asc separator ';\n') aCode
, group_concat(a.strName order by a.id asc separator ';\n') aName
, wo.strDescription woDescription
, wo.dtmDateCompleted
, wo.dblTimeSpentHours
, wo.strCompletionNotes
, case when wo.dtmDateCompleted is null then 'Yes' else 'No' end as followup
, (select ExtractValue(convert(ct.strSysCustomColumnValues USING utf8), '/ccvs/ccv[@name="Importance"]') 
	from tblDdCustomTableRow ct
		where ct.id in (select ExtractValue(convert(a1.strSysCustomColumnValues USING utf8), '/ccvs/ccv[@name="Importance"]') 
            from tblAsset a1 
				where a1.intTenantID = a.intTenantID
                and a1.id = a.id
                )) as shiftTeam
from tblWorkOrder wo
join tblWorkOrderAsset woa on wo.id = woa.intWorkOrderID
join tblAsset a on a.id = woa.intAssetID
join tblAssetCategory ac on ac.id = a.intCategoryID
left join tblDdCustomTableRow ct on ct.intTenantID = a.intTenantID and ct.id = ExtractValue(convert(a.strSysCustomColumnValues USING utf8), '/ccvs/ccv[@name="Importance"]') 
where wo.intTenantID = 75992
and wo.dtmDateCreated between '2022-07-01' and '2022-07-15'
#and ct.id = 44785
and a.intKind = 2
and a.strModel = 'BAGGING MACHINE'
and ac.strName = 'STATEC BINDER BAGGING MODULE'
group by wo.id;

/*SHUTTLE*/
select 
wo.strCode woCode
, group_concat(a.strCode order by a.id asc separator ';\n') aCode
, group_concat(a.strName order by a.id asc separator ';\n') aName
, wo.strDescription woDescription
, wo.dtmDateCompleted
, wo.dblTimeSpentHours
, wo.strCompletionNotes
, case when wo.dtmDateCompleted is null then 'Yes' else 'No' end as followup
, (select ExtractValue(convert(ct.strSysCustomColumnValues USING utf8), '/ccvs/ccv[@name="Importance"]') 
	from tblDdCustomTableRow ct
		where ct.id in (select ExtractValue(convert(a1.strSysCustomColumnValues USING utf8), '/ccvs/ccv[@name="Importance"]') 
            from tblAsset a1 
				where a1.intTenantID = a.intTenantID
                and a1.id = a.id
                )) as shiftTeam
from tblWorkOrder wo
join tblWorkOrderAsset woa on wo.id = woa.intWorkOrderID
join tblAsset a on a.id = woa.intAssetID
join tblAssetCategory ac on ac.id = a.intCategoryID
left join tblDdCustomTableRow ct on ct.intTenantID = a.intTenantID and ct.id = ExtractValue(convert(a.strSysCustomColumnValues USING utf8), '/ccvs/ccv[@name="Importance"]') 
where wo.intTenantID = 75992
and wo.dtmDateCreated between '2022-07-01' and '2022-07-31'
and a.intKind = 2
and ac.strName = 'KNAPP SHUTTLE'
group by wo.id;

