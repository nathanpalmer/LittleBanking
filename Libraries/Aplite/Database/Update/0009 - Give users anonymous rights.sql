insert into tbdUser_Role 
(
	UserID,
	RoleID 
)
SELECT 
	u.UserID
,	1 as roleid
from tbdUser u 
	left join tbdUser_Role r on u.UserID = r.UserID AND r.RoleID = 1
where 
	r.RoleID is null