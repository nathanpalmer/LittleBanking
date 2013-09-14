using System.Reflection;
using Aplite.Core.Common;
using Aplite.Core.Services;
using Aplite.DataAccess.Common;
using Aplite.Web.Mvc.Common;
using Autofac;

namespace LittleBanking.Config
{
    public class Autofac
    {
        public static IContainer Build()
        {
            var builder = new ContainerBuilder();

            ApliteAutofacConfiguration.Initialize(builder);
            ApliteAutofacDataAccessConfiguration.Initialize(builder);
            ApliteAutofacMvcConfiguration.Initialize(builder);

            builder.RegisterModule(new ControllerModule());
            builder.RegisterModule(new DefaultModule());
            builder.RegisterModule(new MvcModule());

            var core = Assembly.Load("LittleBanking.Features");

            // Routes
            builder.RegisterAssemblyTypes(core)
                .Where(t => t.IsAssignableTo<IRoutes>())
                .As<IRoutes>()
                .AsImplementedInterfaces();

            var container = builder.Build();

            return container;
        }
    }
}
