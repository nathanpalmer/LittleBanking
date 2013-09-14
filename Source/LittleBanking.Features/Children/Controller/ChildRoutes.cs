using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Routing;
using Aplite.Core.Common;
using Aplite.Core.Services;

namespace LittleBanking.Children
{
    public class ChildRoutes : IRoutes
    {
        public int Priority { get { return 10; } }

        public void Register(RouteCollection Routes)
        {
            Routes.MapRouteLowercase(
                "Child Route",
                "child/{action}",
                new { controller = "Child", action = "Dashboard" },
                new { controller = "Child" }
            );
        }
    }
}
