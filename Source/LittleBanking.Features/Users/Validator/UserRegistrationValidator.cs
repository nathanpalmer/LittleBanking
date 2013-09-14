using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using FluentValidation;

namespace LittleBanking.Users
{
    public class UserRegistrationValidator : AbstractValidator<UserRegistration>
    {
        public UserRegistrationValidator()
        {
            RuleFor(x => x.UserName)
                .NotEmpty()
                .WithMessage("You must specify a username.");

            RuleFor(x => x.UserName)
                .Length(3, 15)
                .WithMessage("The username must be at least 3 characters and no longer than 15.");

            RuleFor(x => x.Email)
                .NotEmpty()
                .WithMessage("You must specify an email address.");

            RuleFor(x => x.Password)
                .NotEmpty()
                .WithMessage("You must specify a password.");

            RuleFor(x => x.PasswordConfirmation)
                .Must((m, c) => c == m.Password)
                .WithMessage("The password and confirmation password do not match.");
        }
    }
}
