using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Routing;
using Aplite.Core.Common;
using Aplite.Core.Services;

namespace LittleBanking.Users
{
    public class UserRoutes : IRoutes
    {
        public int Priority { get { return 20; } }

        public void Register(RouteCollection Routes)
        {
            Routes.MapRouteLowercase(
                "User Profile w/UserName",
                "user/{userid}/{username}",
                new {controller = "User", action = "Profile"},
                new {controller = "User", action = "Profile", userid = @"\d*"}
                );
            Routes.MapRouteLowercase(
                "User Profile",
                "user/{userid}",
                new { controller = "User", action = "Profile" },
                new { controller = "User", action = "Profile", userid = @"\d*" }
                );
            Routes.MapRouteLowercase(
                "User Action w/ID",
                "user/{action}/{userid}",
                new { controller = "User", action = "Edit" },
                new { controller = "User", userid = @"\d*" }
                );
            Routes.MapRouteLowercase(
                "User Authenticate",
                "user/authenticate/{authenticationtype}",
                new { controller = "User", action = "Authenticate" },
                new { controller = "User" }
                );
            Routes.MapRouteLowercase(
                "User",
                "user/{action}",
                new { controller = "User", action = "Index" },
                new { controller = "User" }
                );

            Routes.MapRouteLowercase(
                "User Confirm",
                "user/{action}/{providerUserKey}",
                new { controller = "User", action = "Confirm" },
                new { controller = "User" }
                );

        }
    }
}
