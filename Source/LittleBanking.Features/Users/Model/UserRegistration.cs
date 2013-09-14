using FluentValidation.Attributes;
using LittleBanking.Users;

namespace LittleBanking.Users
{
    [Validator(typeof(UserRegistrationValidator))]
    public class UserRegistration
    {
        public string UserName { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string PasswordConfirmation { get; set; }
    }
}
