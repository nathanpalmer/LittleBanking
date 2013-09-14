using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using Aplite.Core.Services;
using LittleBanking.Children;
using LittleBanking.Errors;
using LittleBanking.Transactions;

namespace LittleBanking.Transactions
{
    public class TransactionController : ApplicationController
    {
        private readonly IChildManager childManager;
        private readonly ITransactionManager transactionManager;

        public TransactionController(
            IMiddleManagement MiddleManagement,
            IUserSession UserSession,
            IFormsAuthentication FormAuthentication,
            IChildManager ChildManager,
            ITransactionManager TransactionManager) : base(MiddleManagement, UserSession, FormAuthentication)
        {
            childManager = ChildManager;
            transactionManager = TransactionManager;
        }

        public ActionResult Add(int ChildUserID)
        {
            var model = new AddMoney()
            {
                ChildUserID = ChildUserID
            };

            return View(model);
        }

        [HttpPost]
        public ActionResult Add(AddMoney AddMoney)
        {
            if (!ModelState.IsValid)
            {
                return View();
            }

            var user = userSession.GetCurrent();
            var child = childManager.GetChild(user, AddMoney.ChildUserID);
            transactionManager.AddMoney(child, AddMoney.Amount);

            return RedirectToAction("Dashboard", "Leader");
        }
    }
}
