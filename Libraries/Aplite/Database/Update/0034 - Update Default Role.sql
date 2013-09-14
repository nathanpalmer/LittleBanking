declare @anonymousRole int = null
declare @admin int = null
declare @auth int = null

SET @anonymousRole = (select roleid from tbmrole where RoleTypeID = 1)
SET @auth = (select roleid from tbmrole where RoleTypeID = 2)
SET @admin = (select roleid from tbmrole where RoleTypeID = 3)

print 'anonymous role: ' + cast(@anonymousRole as varchar)
print 'auth role: ' + cast(@auth as varchar)
print 'admin role: ' + cast(@admin as varchar)

/****** Script for SelectTopNRows command from SSMS  ******/
if exists(SELECT null
	FROM [tbdArea]
	where 
	  [AreaRoleIDView] = 1
	and [AreaRoleIDAdmin] = 1
	and [PostRoleIDView] = 1
	and [PostRoleIDCreate] = 1
	and [PostRoleIDModerate] = 1
	and [PostRoleIDDelete] = 1
	and [CommentRoleIDView] = 1
	and [CommentRoleIDCreate] = 1
	and [CommentRoleIDModerate] = 1
	and [CommentRoleIDDelete] = 1
	and Name = 'default')
AND @anonymousRole is not null
AND @auth is not null
and @admin is not null
begin
	print 'updating default area'
	update tbdArea
	set 
	  [AreaRoleIDView] = @anonymousRole
	, [AreaRoleIDAdmin] = @admin
	, [PostRoleIDView] = @anonymousRole
	, [PostRoleIDCreate] = @auth
	, [PostRoleIDModerate] = @admin
	, [PostRoleIDDelete] = @admin
	, [CommentRoleIDView] = @anonymousRole
	, [CommentRoleIDCreate] = @auth
	, [CommentRoleIDModerate] = @admin
	, [CommentRoleIDDelete] = @admin
	where
		 [AreaRoleIDView] = 1
	and [AreaRoleIDAdmin] = 1
	and [PostRoleIDView] = 1
	and [PostRoleIDCreate] = 1
	and [PostRoleIDModerate] = 1
	and [PostRoleIDDelete] = 1
	and [CommentRoleIDView] = 1
	and [CommentRoleIDCreate] = 1
	and [CommentRoleIDModerate] = 1
	and [CommentRoleIDDelete] = 1
	and Name = 'default'
end