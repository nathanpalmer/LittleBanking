UPDATE tbdArea 
set StateAreaID = 0
where Tier = 1
GO

update tbdArea 
set Tracking = 1
where Tier = 2
go