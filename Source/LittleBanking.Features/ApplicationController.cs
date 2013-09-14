using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Aplite.Core.Common;
using Aplite.Core.Common.Extensions;
using Aplite.Core.DataAccess;
using Aplite.Core.Domain;
using Aplite.Core.Services;

namespace LittleBanking
{
    [HandleErrorAttributeLogged]
    public abstract class ApplicationController : Controller
    {
        protected readonly IMiddleManagement middleManagement;
        protected readonly IUserSession userSession;
        private readonly IFormsAuthentication formAuthentication;

        public ApplicationController(IMiddleManagement MiddleManagement, IUserSession UserSession, IFormsAuthentication FormAuthentication)
        {
            middleManagement = MiddleManagement;
            userSession = UserSession;
            formAuthentication = FormAuthentication;
        }

        private void CreateLinks(Aplite.Core.Domain.User CurrentUser)
        {
            // Main Links
            var mainLinks = new[]
                                {
                                    new Link("Home", null, "Home", "Index", new {page = 1}, null),
                                    //new Link("About", null, "Home", "About", null),
                                    //new Link("FAQ", null, "Home", "FAQ", null),
                                    //new Link("Rss", null, "Home", "Rss", null),
                                    //new Link("Read Blog", null, "Blog", "Index", null),
                                    //new Link("Create Post", null, "Operations", "Create", new { title = "blog-post"})
                            };
            ViewData["MainLinks"] = mainLinks.ToActionLinks(this);

            Link[] metaLinks;
            if (User.Identity.IsAuthenticated)
            {
                string userName = CurrentUser.UserName;
                if (userName.Length <= 7)
                {
                    userName += " (Profile)";
                }
                else if (userName.Length > 15)
                {
                    userName = userName.Substring(0, 15) + "..";
                }

                metaLinks = new[]
                                {
                                    new Link("Logout", null, "User", "Logout", null),
                                    new Link(userName, null, "User", "Profile", new { userid = CurrentUser.ID, username = CurrentUser.UserName.ToUrlFriendly() })
                                };
            }
            else
            {
                metaLinks = new[]
                                {
                                    new Link("Login", null, "User", "Login", null)
                                };
            }

            ViewData["MetaLinks"] = metaLinks.ToActionLinks(this);
        }

        protected override void OnActionExecuted(ActionExecutedContext filterContext)
        {
            if (filterContext.Result is DelayedView)
            {
                filterContext.Result = View(((DelayedView)filterContext.Result).ViewName);
            }
        }

        protected override ViewResult View(string viewName, string masterName, object model)
        {
            var user = userSession.GetCurrent();
            ViewData["CurrentUser"] = user;
            ViewData["GoogleAnalyticsAccount"] = ConfigurationManager.AppSettings["GoogleAnalyticsAccount"];

           CreateLinks(user);

            if (user != null &&
                user.StateUser == StateUser.Blocked)
            {
                formAuthentication.SignOut();
            }

            return base.View(viewName, masterName, model);
        }
    }
}
