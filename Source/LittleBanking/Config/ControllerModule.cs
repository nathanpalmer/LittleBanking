using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web.Mvc;
using Autofac;
using Autofac.Integration.Mvc;
using Module = Autofac.Module;

namespace LittleBanking.Config
{
    public class ControllerModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {
            // register controllers
            builder.RegisterType<ExtensibleActionInvoker>().As<IActionInvoker>();

            List<Assembly> assemblyCollection = new List<Assembly>();

            // Get Web Admin Controllers
            assemblyCollection.Add(Assembly.Load("LittleBanking.Features"));
            assemblyCollection.Add(Assembly.GetExecutingAssembly());

            builder.RegisterControllers(assemblyCollection.ToArray()).InjectActionInvoker().InstancePerLifetimeScope();
        }
    }
}
