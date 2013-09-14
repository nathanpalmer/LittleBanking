using System;
using System.Linq;
using System.Web.Mvc;
using Aplite.Core.Domain;
using Autofac;

namespace LittleBanking.Config
{
    public class MvcModule : Module
    {
        private void SettingsFunctions(SiteSettings SiteSettings)
        {
            Func<ActionExecutingContext, string> operationsFunc = FilterContext =>
            {
                var type = FilterContext.HttpContext.Request["Type"];

                if (String.IsNullOrWhiteSpace(type))
                {
                    var key = FilterContext.RouteData.Values.Keys.
                        FirstOrDefault(x => x.Equals("Type", StringComparison.OrdinalIgnoreCase));

                    if (key == null)
                    {
                        throw new Exception("No default parameter found in route values. Looking for parameter 'type'.");
                    }

                    type = FilterContext.RouteData.Values[key].ToString();
                }

                var apType = (ApType)Enum.Parse(typeof(ApType), type, true);

                FilterContext.ActionParameters["ApType"] = apType;

                switch (apType)
                {
                    case ApType.blog:
                        return "Default";
                    default:
                        throw new Exception("Unable to find area name for type " + apType);
                }
            };

            SiteSettings.Actions.Add("Operations", operationsFunc);
        }

        protected override void Load(ContainerBuilder builder)
        {
            SiteSettings siteSettings = new SiteSettings()
                                        {
                                            DefaultAreaName = "Default",
                                            Login = new Link("Login", null, "User", "Login", null),
                                            Views = new Views()
                                                    {
                                                        AccessDenied = "AccessDenied",
                                                        Error = "Error",
                                                        NotFound = "NotFound"
                                                    }
                                        };

            SettingsFunctions(siteSettings);

            // Custom Types
            builder.RegisterInstance<SiteSettings>(siteSettings).SingleInstance();
        }
    }
}
