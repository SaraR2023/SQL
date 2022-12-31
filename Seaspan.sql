select w.strCode as "WO Code", w.strDescription, a.strName, a.strCode as "Asset Code", s.strName, 
mt.strName,  w.dtmDateCreated, w.dtmDateCompleted, a2.strName as "Site",  w.strAssignedUsers, a3.strName, m.dtmMoveDate,
case 
when alt.id = 1500 then a3.strName
when alt.id = 1500 and m.intUserDestinationID = u.id then u.strFullName 
when alt.id = 1100 and m.intUserDestinationID = u.id then u.strFullName
when alt.id = 1100 then a3.strName

end as "Moved to User",
alt.strName
from tblWorkOrder w
left join tblWorkOrderAsset wa on wa.intWorkOrderID = w.id
left join tblAsset a on wa.intAssetID= a.id
left join tblAsset a2 on a2.id = a.intSiteID
left join tblAsset a3 on a.intAssetLocationID = a3.id
left join tblMoveAsset ma on ma.intAssetID = a.id
left join tblMove m on ma.intMoveID = m.id
left join tblUser u on m.intUserDestinationID = u.id
left join tblWorkOrderStatus s on w.intWorkOrderStatusID = s.id
left join tblMaintenanceType mt on w.intMaintenanceTypeID = mt.id
join tblActivityLog al on al.intAssetID = a.id
join tblActivityLogType alt on al.intActivityLogTypeID = alt.id
where w.intTenantID = 10105
and w.dtmDateCreated between '2021-01-01' and now()
and mt.strDescription = 'Calibration'
and ma.id = (select max(ma1.id) from tblMoveAsset ma1 where ma1.intAssetID = a.id)
and al.id = (select max(al1.id) from tblActivityLog al1 where al1.intAssetID = a.id)

and a.strCode = 'A11412'  /* supposed to return "Electrical Shop Tool Crib" */
group by w.id, a.id
order by m.dtmMoveDate desc
