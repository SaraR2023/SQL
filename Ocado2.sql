#Not MASOPS, BAGGING, or SHUTTLES
select 
wo.strCode woCode
, group_concat(a.strCode order by a.id asc separator ';\n') aCode
, group_concat(a.strName order by a.id asc separator ';\n') assetName
, wo.strDescription woDescription
, wo.dtmDateCompleted
, cast(wo.dblTimeSpentHours as decimal(10,2)) dblTimeSpentHours
, wo.strCompletionNotes
, case when wo.dtmDateCompleted is null then 'Handover' else 'No' end as followup
, (select ExtractValue(convert(ct.strSysCustomColumnValues USING utf8), '/ccvs/ccv[@name="Importance"]') 
	from tblDdCustomTableRow ct
		where ct.id in (select ExtractValue(convert(a1.strSysCustomColumnValues USING utf8), '/ccvs/ccv[@name="Importance"]') 
            from tblAsset a1 
				where a1.intTenantID = a.intTenantID
                and a1.id = a.id
                )
                      
  ) as "shiftTeam"
, site.strName
from tblWorkOrder wo
join tblWorkOrderAsset woa on wo.id = woa.intWorkOrderID
join tblAsset a on a.id = woa.intAssetID
join tblAsset site on site.id = a.intSiteID
join tblAssetCategory ac on ac.id = a.intCategoryID
left join tblDdCustomTableRow ct on ct.intTenantID = a.intTenantID and ct.id = ExtractValue(convert(a.strSysCustomColumnValues USING utf8), '/ccvs/ccv[@name="Importance"]') 

where wo.intTenantID = 75992
and wo.dtmDateCreated between '2022-07-20' and current_date()
#and ct.id = 44785
and site.id in (21962402, 22025136)
and a.intAssetLocationID not in
(
select a.id
from tblAsset a 
join tblAsset loc on loc.id = a.intAssetLocationID
where a.intTenantID = 75992
and a.intSiteID = 21962402
and loc.id in (22026591, 22026592, 22026593)
and a.intKind = 1)
and ac.strName <> 'STATEC BINDER BAGGING MODULE'
and ac.strName <> 'KNAPP SHUTTLE'
group by wo.id
having "shiftTeam" = 'BLUE'
;
