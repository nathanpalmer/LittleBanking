using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Routing;
using Aplite.Core.Common;
using Aplite.Core.Services;

namespace LittleBanking.Operations
{
    public class OperationsRoutes : IRoutes
    {
        public int Priority { get { return 30; } }

        public void Register(RouteCollection Routes)
        {
            // Operations
            // CRUD Routes
            Routes.MapRouteLowercase(
                "Post Create",
                "Create/{title}/{type}",
                new { controller = "Operations", action = "Create", type = "blog" },
                new { controller = "Operations", action = "Create" }
                );

            Routes.MapRouteLowercase(
                "Edit Comment",
                "Edit/{postid}/Comment/{commentid}/{type}",
                new { controller = "Operations", action = "Edit", type = "blog" },
                new { controller = "Operations", action = "Edit", postid = @"\d*", commentid = @"\d*" }
                );

            Routes.MapRouteLowercase(
                "Edit Post",
                "Edit/{postid}/{type}",
                new { controller = "Operations", action = "Edit", type = "blog" },
                new { controller = "Operations", action = "Edit", postid = @"\d*" }
                );

            Routes.MapRouteLowercase(
               "Delete Comment",
               "Delete/{postid}/Comment/{commentid}/{type}",
               new { controller = "Operations", action = "Delete", type = "blog" },
               new { controller = "Operations", action = "Delete", postid = @"\d*", commentid = @"\d*" }
               );

            Routes.MapRouteLowercase(
                "Delete Post",
                "Delete/{postid}/{type}",
                new { controller = "Operations", action = "Delete", type = "blog" },
                new { controller = "Operations", action = "Delete", postid = @"\d*" }
                );

            Routes.MapRouteLowercase(
                "Reply Comment",
                "Reply/{postid}/{type}",
                new { controller = "Operations", action = "Reply", type = "blog" },
                new { controller = "Operations", action = "Reply", postid = @"\d*" }
                );

            // Rank Methods
            Routes.MapRouteLowercase(
                "Rank Post",
                "Rank/{postid}/{rank}/{type}",
                new { controller = "Operations", action = "Rank", type = "blog" },
                new { controller = "Operations", action = "Rank", postid = @"\d*", rank = @"\-?\d*" }
                );
        }
    }
}
