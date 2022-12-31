select sm.strCode, st.strDescription
from tblScheduledMaintenance sm
left join tblScheduledTask st on sm.id = st.intScheduledMaintenanceID
where sm.intTenantID=10105
and st.id is null