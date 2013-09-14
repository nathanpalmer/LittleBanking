namespace TarantinoDatabaseManagerTasks

import Phantom.Core.Integration
import Phantom.Core.Language
import Phantom.Integration.NAnt

class @task(IRunnable[of @task]):
    task as Tarantino.Infrastructure.DatabaseManager.BuildTasks.Task

    def constructor():
        task = Tarantino.Infrastructure.DatabaseManager.BuildTasks.Task()

    @buildfile as System.IO.FileInfo:
        get:
            return task.BuildFile
        set:
            task.BuildFile = value

    @target as System.String:
        get:
            return task.DefaultTarget
        set:
            task.DefaultTarget = value

    @inheritall as System.Boolean:
        get:
            return task.InheritAll
        set:
            task.InheritAll = value

    @inheritrefs as System.Boolean:
        get:
            return task.InheritRefs
        set:
            task.InheritRefs = value

    @failonerror as System.Boolean:
        get:
            return task.FailOnError
        set:
            task.FailOnError = value

    @verbose as System.Boolean:
        get:
            return task.Verbose
        set:
            task.Verbose = value

    @if as System.Boolean:
        get:
            return task.IfDefined
        set:
            task.IfDefined = value

    @unless as System.Boolean:
        get:
            return task.UnlessDefined
        set:
            task.UnlessDefined = value

    def Run():
        NAntTaskRunner().Run(task)
        return self

class @manageSqlDatabase(IRunnable[of @manageSqlDatabase]):
    task as Tarantino.DatabaseManager.Tasks.ManageSqlDatabaseTask

    def constructor():
        task = Tarantino.DatabaseManager.Tasks.ManageSqlDatabaseTask()

    @action as Tarantino.Core.DatabaseManager.Services.Impl.RequestedDatabaseAction:
        get:
            return task.Action
        set:
            task.Action = value

    @scriptDirectory as System.IO.DirectoryInfo:
        get:
            return task.ScriptDirectory
        set:
            task.ScriptDirectory = value

    @server as System.String:
        get:
            return task.Server
        set:
            task.Server = value

    @database as System.String:
        get:
            return task.Database
        set:
            task.Database = value

    @integratedAuthentication as System.Boolean:
        get:
            return task.IntegratedAuthentication
        set:
            task.IntegratedAuthentication = value

    @username as System.String:
        get:
            return task.Username
        set:
            task.Username = value

    @password as System.String:
        get:
            return task.Password
        set:
            task.Password = value

    @skipFileNameContaining as System.String:
        get:
            return task.SkipFileNameContaining
        set:
            task.SkipFileNameContaining = value

    @buildfile as System.IO.FileInfo:
        get:
            return task.BuildFile
        set:
            task.BuildFile = value

    @target as System.String:
        get:
            return task.DefaultTarget
        set:
            task.DefaultTarget = value

    @inheritall as System.Boolean:
        get:
            return task.InheritAll
        set:
            task.InheritAll = value

    @inheritrefs as System.Boolean:
        get:
            return task.InheritRefs
        set:
            task.InheritRefs = value

    @failonerror as System.Boolean:
        get:
            return task.FailOnError
        set:
            task.FailOnError = value

    @verbose as System.Boolean:
        get:
            return task.Verbose
        set:
            task.Verbose = value

    @if as System.Boolean:
        get:
            return task.IfDefined
        set:
            task.IfDefined = value

    @unless as System.Boolean:
        get:
            return task.UnlessDefined
        set:
            task.UnlessDefined = value

    def Run():
        NAntTaskRunner().Run(task)
        return self

