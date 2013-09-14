using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Routing;
using Aplite.Core.Common;
using Aplite.Core.Services;

namespace LittleBanking.Public
{
    public class PublicRoutes : IRoutes
    {
        public int Priority { get { return 50; } }

        public void Register(RouteCollection Routes)
        {
            // Generic Actions
            Routes.MapRouteLowercase(
                "Generic pages for site",
                "{action}",
                new { controller = "Public" },
                new { controller = "Public", action = "(FAQ|About)" }
                );

            // Default route
            Routes.MapRouteLowercase(
                "Landing Page",
                "",
                new {controller = "Public", action = "Home", page = 1}
                );
        }
    }
}
