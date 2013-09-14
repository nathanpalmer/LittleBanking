using FluentValidation.Attributes;

namespace LittleBanking.Users
{
    [Validator(typeof(UserBankValidator))]
    public class UserBank
    {
        public string BankName { get; set; }
        public string Url { get; set; }
    }
}