using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using Aplite.Core.Common;
using Aplite.Core.Domain;
using Aplite.Core.Services;
using LittleBanking.Children;
using LittleBanking.Errors;

namespace LittleBanking.Leaders
{
    public class LeaderController : ApplicationController
    {
        private readonly IChildManager childManager;

        public LeaderController(
            IMiddleManagement MiddleManagement,
            IUserSession UserSession,
            IFormsAuthentication FormAuthentication,
            IChildManager ChildManager) : base(MiddleManagement, UserSession, FormAuthentication)
        {
            childManager = ChildManager;
        }

        [AreaFilter]
        public ActionResult Dashboard(PermissionArea Area)
        {
            var user = userSession.GetCurrent();

            var children = childManager
                .GetChildren(user)
                .Select(c => new ChildList.Child
                             {
                                 ID = c.UserAccount.ID,
                                 AreaID = c.TransactionArea.ID,
                                 Name = c.UserAccount.UserName,
                                 BirthDate = c.UserAccount.BirthDate.HasValue ? c.UserAccount.BirthDate.Value.ToShortDateString() : "",
                                 Balance = c.Balance
                             });

            var index = new ChildList { Children = children };

            return View(index);
        }

        public ActionResult Add()
        {
            return View();
        }

        [HttpPost]
        [AreaFilter]
        public ActionResult Add(PermissionArea Area, string Name, string BirthDate)
        {
            var user = userSession.GetCurrent();
            childManager.AddChild(Area.Entity, user, Name, BirthDate);
            return RedirectToAction("Dashboard");
        }


    }
}
