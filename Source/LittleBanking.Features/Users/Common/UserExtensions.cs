using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace LittleBanking.Users
{
    public static class UserExtensions
    {
        public static string GetSubDomain(this HttpRequestBase HttpRequest)
        {
            string host = HttpRequest.Headers["HOST"];
            if (!string.IsNullOrEmpty(host))
            {
                var parts = host.Split('.');
                if (parts.Length > 2 || // Url with subdomain.domain.register
                    (parts.Length == 2 && host.Contains("localhost"))) // or local host domain testing
                {
                    return parts[0];
                }
            }
            return string.Empty;
        }
    }
}
