using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Routing;
using Aplite.Core.Common;
using Aplite.Core.Services;

namespace LittleBanking.Transactions
{
    public class TransactionRoutes : IRoutes
    {
        public int Priority { get { return 40; } }

        public void Register(RouteCollection Routes)
        {
            Routes.MapRouteLowercase(
                "Transaction Route",
                "transaction/{action}",
                new { controller = "Transaction" },
                new { controller = "Transaction" }
            );
        }
    }
}
