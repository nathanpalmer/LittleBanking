if not exists(select null from tbmRole where RoleTypeID = 2)
begin
	update tbmRole
	set RoleTypeID = 2
	where Title = 'Authenticated User'
end

if not exists(select null from tbmRole where RoleTypeID = 3)
begin
	update tbmRole
	set RoleTypeID = 3
	where Title = 'Site Admin'
end