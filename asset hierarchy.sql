select
distinct site.id siteId
, site.strCode siteCode
, site.strName siteName
, a.id locId
, a.strCode locCode
, a.strName locName
, case when t.facilityId is null then z.equipID else t.facilityId end as sub1ID
, case when t.facilityCode is null then z.equipCode else t.facilityCode end as sub1Code
, case when t.facilityName is null then z.equipName else t.facilityName end as sub1Name
, case when s.id is null then p.id else s.id end as sub2Id
, case when s.subCode is null then p.subCode else s.subCode end as sub2Code
, case when s.subName is null then p.subName else s.subName end as sub2Name
, q.aCode sub3Code
, q.aName sub3Name

from tblAsset a 
join tblAsset site on a.intSiteID = site.id
join tblAsset loc on loc.id = a.intAssetLocationID

left outer join (
			select 

			distinct 
			site.id siteId
			, site.strCode siteCode
			, site.strName siteName
			, loc.id locId
			, loc.strCode locCode
			, loc.strName locName
			, a.id as facilityId
			, a.strCode facilityCode
			, a.strName facilityName

			from tblAsset a 
			left join tblAsset site on a.intSiteID = site.id
			left join tblAsset loc on loc.id = a.intAssetLocationID

			where a.intTenantID = 32480
					and a.intAssetLocationID <> a.intSiteID
				) t on t.locId = a.id and t.siteCode = site.strCode
LEFT OUTER JOIN (
				select 
				distinct 
				site.id siteId
				, site.strCode siteCode
				, site.strName siteName
				, a.id equipId
				, a.strCode equipCode
				, a.strName equipName
				, a.intAssetParentID parent

				from tblAsset a 
				left join tblAsset site on a.intSiteID = site.id
				left join tblAsset loc on loc.id = a.intAssetLocationID

				where a.intTenantID = 32480
				)z on z.parent = a.id and z.siteCode = site.strCode
LEFT OUTER JOIN 
				(
				select 
				distinct 
				site.strCode siteCode
				, a.id id
				, a.strCode subCode
				, a.strName subName
				, a.intAssetLocationID as parentLocation

				from tblAsset a 
				left join tblAsset site on a.intSiteID = site.id
				left join tblAsset loc on loc.id = a.intAssetLocationID

				where a.intTenantID = 32480
				and a.intAssetLocationID in
						(
						select 
						distinct  
						a.id as facilityId
						from tblAsset a 
						left join tblAsset site on a.intSiteID = site.id
						left join tblAsset loc on loc.id = a.intAssetLocationID

						where a.intTenantID = 32480
						and a.intAssetLocationID <> a.intSiteID
							)) s
						on  s.parentLocation = t.facilityId and s.siteCode = site.strCode
LEFT OUTER JOIN (
				select
				distinct
				site.strCode siteCode
				, a.id id
				, a.strCode subCode
				, a.strName subName
				, a.intAssetParentID as parentAsset
				from tblAsset a 
				left join tblAsset site on a.intSiteID = site.id
				left join tblAsset loc on loc.id = a.intAssetLocationID

				where a.intTenantID = 32480
				and a.intAssetParentID in 
				(
				select 
				distinct  
				a.id as facilityId
				from tblAsset a 
				left join tblAsset site on a.intSiteID = site.id
				left join tblAsset loc on loc.id = a.intAssetLocationID

				where a.intTenantID = 32480
				and a.intAssetLocationID <> a.intSiteID
				)
) p on p.parentAsset = t.facilityId and p.siteCode = site.strCode 
LEFT OUTER JOIN
(
				select distinct 
				site.strCode siteCode
				, a.id
				, a.strCode aCode
				, a.strName aName
				, a.intAssetParentID as parentAsset
                                                    
				from tblAsset a 
				left join tblAsset site on a.intSiteID = site.id
				left join tblAsset loc on loc.id = a.intAssetLocationID

				where a.intTenantID = 32480
				and a.intAssetParentID in
						(
							select distinct  
							a.id as facilityId
							from tblAsset a 
							left join tblAsset site on a.intSiteID = site.id
							left join tblAsset loc on loc.id = a.intAssetLocationID

							where a.intTenantID = 32480
								and a.intAssetLocationID <> a.intSiteID
						)
) q on q.parentAsset = s.id and q.siteCode = site.strCode

where a.intTenantID = 32480
and site.strCode = 'A2'
and a.intAssetLocationID = a.intSiteID
order by site.strCode, a.id asc;

