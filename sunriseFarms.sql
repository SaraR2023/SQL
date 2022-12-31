select 
wo.strCode as "woCode", 
wos.strName as "woStatus", 
group_concat(distinct a.strName separator ';\n') as "assetName", 
site.strName as "site",
loc.strName as "loc",
group_concat(distinct a.strCode separator ';\n') as "assetCode",
(case when a.bolIsOnline = 1 then 'Online'
when a.bolIsOnline = 0 then 'Offline' end) as "assetState",
wo.dtmDateCompleted as "wo_completionDate", 
wo.strCompletionNotes as "wo_completionNotes", wo.strAdminNotes as "adminNotes",
dtmSuggestedCompletionDate as "suggestedDate",
a.id as "assetID",
p.strName as "priority",
m.strName as "mainType",
wo.strNameUserGuest as "nameUserGuest",
group_concat(distinct wo.strAssignedUsers) as "assignedUser",
group_concat(distinct wo.strCompletedByUsers) as "completedBy",
wo.strDescription as "summary",
wo.strRootCause as "cause",
wo.strProblem as "problem",
wo.strSolution as "solution",
concat(rcaa.strCode, '-', rcaa.strDescription) as "rca_action",
concat(rcac.strCode, '-', rcac.strDescription) as "rca_cause",
concat(rcap.strCode, '-', rcap.strDescription) as "rca_problem",
wo.dblTimeEstimatedHours as "estimatedHrs",
wo.dblTimeSpentHours as "timeSpent",

case when
extractvalue(convert(wo.strSysCustomColumnValues using utf8), '/ccvs/ccv[@name = "Notify_QA_Designate_Work_order_is_complete"]')
= '26249' then 'Yes' 
when extractvalue(convert(wo.strSysCustomColumnValues using utf8), '/ccvs/ccv[@name = "Notify_QA_Designate_Work_order_is_complete"]')
= '26250' then 'No' else null end as "notifyQA",
extractvalue(convert(wo.strSysCustomColumnValues using utf8), '/ccvs/ccv[@name = "Downtime"]') as "Downtime",
case when
extractvalue(convert(wo.strSysCustomColumnValues using utf8), '/ccvs/ccv[@name = "All_guards_are_in_place_and_secured"]') 
= '26249' then 'Yes' 
when extractvalue(convert(wo.strSysCustomColumnValues using utf8), '/ccvs/ccv[@name = "All_guards_are_in_place_and_secured"]') 
= '26250' then 'No' 
else null end as "allGuards",
case when
extractvalue(convert(wo.strSysCustomColumnValues using utf8), '/ccvs/ccv[@name = "All_parts_tools_accounted_for"]')
= '26249' then 'Yes' 
when extractvalue(convert(wo.strSysCustomColumnValues using utf8), '/ccvs/ccv[@name = "All_parts_tools_accounted_for"]')
= '26250' then 'No' else null end as "partsAccountedFor",
case when
extractvalue(convert(wo.strSysCustomColumnValues using utf8), '/ccvs/ccv[@name = "Product_removed_and_or_protected"]')
= '26249' then 'Yes' 
when extractvalue(convert(wo.strSysCustomColumnValues using utf8), '/ccvs/ccv[@name = "Product_removed_and_or_protected"]')
= '26250' then 'No' else null end as "productsRemoved",
case when
extractvalue(convert(wo.strSysCustomColumnValues using utf8), '/ccvs/ccv[@name = "Area_clean_and_ready_for_production"]')
= '26249' then 'Yes' 
when extractvalue(convert(wo.strSysCustomColumnValues using utf8), '/ccvs/ccv[@name = "Area_clean_and_ready_for_production"]')
= '26250' then 'No' 
else null end as "areaClean",
case when
extractvalue(convert(wo.strSysCustomColumnValues using utf8), '/ccvs/ccv[@name = "QA_Form"]')
= '26263' then 'QA031F Maintenance Activity Form. Rev.: Aug/09/2021. Sup.: Sep/09/2021.' 
when extractvalue(convert(wo.strSysCustomColumnValues using utf8), '/ccvs/ccv[@name = "QA_Form"]')
= '26262' then 'Not QA' else null end as "QAForm",

wo.dtmDateSigned as "signOffDate",
wo.strCompletedByUsers as "techSignOff",
(select distinct case when 
u.strUserTitle like '%Supervisor' or u.strUserTitle like '%Manager' then u.strFullName end
from tblWorkOrder wo
join tblWorkOrderLog wol on wol.intWorkOrderID = wo.id
join tblUser u on wol.intUserID = u.id
where wo.intTenantID = 57506
and wo.strCode = 1519
and u.strFullName is not null
order by u.id desc limit 1) as "supervisor"

from tblWorkOrder wo
left join tblWorkOrderStatus wos on wo.intWorkOrderStatusID = wos.id
left join tblWorkOrderAsset woa on woa.intWorkOrderID = wo.id
left join tblWorkOrderTask wot on wo.id = wot.intWorkOrderID
left join tblRCAAction rcaa on rcaa.id = wo.intRCAActionID
left join tblRCACause rcac on rcac.id = wo.intRCACauseID
left join tblRCAProblem rcap on rcap.id = wo.intRCAProblemID
left join tblAsset a on woa.intAssetID = a.id
left join tblAsset site on site.id = a.intSiteID
left join tblAsset loc on loc.id = a.intAssetLocationID
left join tblPriority p on p.id = wo.intPriorityID
left join tblMaintenanceType m on m.id = wo.intMaintenanceTypeID
left join tblWorkOrderLog wol on wol.intWorkOrderID = wo.id
left join tblUser u on wol.intUserID = u.id
where wo.intTenantID = 57506
and wo.strCode = 1519;


