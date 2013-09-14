using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using Aplite.Core.Common;
using Aplite.Core.Domain;
using Aplite.Core.Services;
using LittleBanking.Users;

namespace LittleBanking.Public
{
    [HandleError]
    public class PublicController : ApplicationController
    {
        public PublicController(
            IMiddleManagement MiddleManagement,
            IUserSession UserSession,
            IFormsAuthentication FormAuthentication) : base(MiddleManagement, UserSession, FormAuthentication)
        {
        }

        [AreaFilter]
        public ActionResult Home(PermissionArea Area)
        {
            if (HttpContext.User.Identity.IsAuthenticated)
            {
                return RedirectToAction("Dashboard", "Leader");
            }

            string host = HttpContext.Request.GetSubDomain();
            if (!string.IsNullOrWhiteSpace(host))
            {
                var parentUser = middleManagement.User.Get(x => x.HomePage.Equals(host));
                if (parentUser.EntityFound && parentUser.Entity.StateUser == StateUser.Active)
                {
                    return RedirectToAction("Login", "User");
                }
                return RedirectToAction("InvalidBank", "Error");
            }

            return View();
        }
    }
}
