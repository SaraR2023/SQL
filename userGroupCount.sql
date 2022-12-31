select u.intTenantID as "tenantID", 
site.strName as "Site", 
group_concat(u.strFullName) as "userName",
count(u2.strFullName) as "userGroupCount"

from tblUser u
	join tblSiteUser su on u.id = su.intUserID
	join tblSiteUserGroup sug on sug.intSiteUserID = su.id
	join tblUser u2 on sug.intGroupID = u2.id
	join tblAsset site on site.id = su.intSiteID
    
where u2.strFullName = 'Managers'
group by u.intTenantID, site.id
order by u.intTenantID asc;