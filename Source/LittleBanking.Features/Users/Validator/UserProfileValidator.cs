using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using FluentValidation;
using LittleBanking.Users;

namespace LittleBanking.Users
{
    public class UserProfileValidator : AbstractValidator<UserProfile>
    {
        public UserProfileValidator()
        {
            RuleFor(x => x.Password).Equal(x => x.PasswordConfirmation).WithMessage("Password did not match confirmation");
        }
    }
}
