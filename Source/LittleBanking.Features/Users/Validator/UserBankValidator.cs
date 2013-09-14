using FluentValidation;

namespace LittleBanking.Users
{
    public class UserBankValidator : AbstractValidator<UserBank>
    {
        public UserBankValidator()
        {
            RuleFor(x => x.BankName).NotEmpty();
            RuleFor(x => x.Url).NotEmpty();
        }
    }
}