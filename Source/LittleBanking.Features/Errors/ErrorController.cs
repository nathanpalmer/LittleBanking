using System.Web.Mvc;
using Aplite.Core.Services;

namespace LittleBanking.Errors
{
    public class ErrorController : ApplicationController
    {
        public ErrorController(IMiddleManagement MiddleManagement, IUserSession UserSession, IFormsAuthentication FormAuthentication)
            : base(MiddleManagement, UserSession, FormAuthentication)
        {
            
        }

        public ActionResult Index()
        {
            return View("Error");
        }

        public ActionResult NotFound()
        {
            return View("NotFound");
        }

        public ActionResult InvalidBank()
        {
            return View();
        }
    }
}
