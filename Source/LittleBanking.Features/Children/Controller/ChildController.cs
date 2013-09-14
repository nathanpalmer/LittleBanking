using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using Aplite.Core.Services;

namespace LittleBanking.Children.Controller
{
    public class ChildController : ApplicationController
    {
        public ChildController(
            IMiddleManagement MiddleManagement,
            IUserSession UserSession,
            IFormsAuthentication FormAuthentication) : base(MiddleManagement, UserSession, FormAuthentication)
        {
        }

        public ActionResult Dashboard()
        {
            return View();
        }
    }
}
