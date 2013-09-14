using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Aplite.Core.Domain;

namespace LittleBanking.Users
{
    public class UserLogin
    {
        public string Title { get; set; }
        public UserAuthenticationType AuthenticationType { get; set; }
        public string Identifier { get; set; }
        public string Password { get; set; }
    }
}
