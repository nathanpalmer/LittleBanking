using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Routing;
using Aplite.Core.Common;
using Aplite.Core.Services;

namespace LittleBanking.Leaders
{
    public class LeaderRoutes : IRoutes
    {
        public int Priority { get { return 10; } }

        public void Register(RouteCollection Routes)
        {
            Routes.MapRouteLowercase(
                "Leader Route",
                "leader/{action}",
                new { controller = "Leader", action = "Dashboard" },
                new { controller = "Leader" }
            );
        }
    }
}
