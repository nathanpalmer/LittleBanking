using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using FluentValidation.Attributes;

namespace LittleBanking.Users
{
    [Validator(typeof(UserProfileValidator))]
    public class UserProfile
    {
        public int UserID { get; set; }
        public bool Local { get; set; }
        public string DisplayName { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string PasswordConfirmation { get; set; }
    }
}
