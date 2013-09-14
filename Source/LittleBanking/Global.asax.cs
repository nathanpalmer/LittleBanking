using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using Aplite.Core.Services;
using Autofac.Integration.Mvc;
using Autofac.Integration.Web;
using FluentValidation.Attributes;
using FluentValidation.Mvc;
using LittleBanking.Users;

namespace LittleBanking
{
    public class MvcApplication : HttpApplication, IContainerProviderAccessor
    {
        private static IContainerProvider containerProvider;

        public static void RegisterRoutes(RouteCollection routes)
        {
            // Global ignores
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
            routes.IgnoreRoute("Images/{*pathInfo}");
            routes.IgnoreRoute("Styles/{*pathInfo}");
            routes.IgnoreRoute("Scripts/{*pathInfo}");
            routes.IgnoreRoute("favicon.ico");

            // Service routes
            var serviceRoutes = DependencyResolver.Current.GetServices<IRoutes>();
            foreach (var route in serviceRoutes.OrderBy(x => x.Priority))
            {
                route.Register(routes);
            }
        }

        protected void Application_Start()
        {
            var container = Config.Autofac.Build();
            containerProvider = new ContainerProvider(container);
            DependencyResolver.SetResolver(new AutofacDependencyResolver(container));

            AreaRegistration.RegisterAllAreas();

            RegisterRoutes(RouteTable.Routes);
            
            // Register spark
            ViewEngines.Engines.Clear();
            ViewEngines.Engines.Add(new RazorViewEngine());

            // Fluent validations
            ModelValidatorProviders.Providers.Add(new FluentValidationModelValidatorProvider(new AttributedValidatorFactory()));

            AutoMapperConfiguration.ConfigureObjectMapping(container);
        }

        public IContainerProvider ContainerProvider
        {
            get { return containerProvider; }
        }
    }
}
