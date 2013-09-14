Update a
set 
	CommentRoleIDView = PostRoleIDView
,	CommentRoleIDDelete = PostRoleIDDelete 
,	CommentRoleIDCreate = case when PostRoleIDCreate <= 6 then 1 else PostRoleIDCreate end
,	CommentRoleIDModerate = PostRoleIDModerate 
from tbdArea a