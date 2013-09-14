using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Routing;
using Aplite.Core.Common;
using Aplite.Core.Services;

namespace LittleBanking.Errors
{
    public class ErrorRoutes : IRoutes
    {
        public int Priority { get { return 100; } }

        public void Register(RouteCollection Routes)
        {
            // Error Routes
            Routes.MapRouteLowercase(
                "Generic Error",
                "Error/{action}",
                new { controller = "Error", action = "Index" },
                new { controller = "Error" }
            );

            // Catch all
            Routes.MapRouteLowercase(
                "Error",
                "{*url}",
                new { controller = "Error", action = "NotFound" }
            );
        }
    }
}
