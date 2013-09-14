using Aplite.Core.Domain;

namespace LittleBanking.Transactions
{
    public class TransactionDetail 
    {
        public virtual int ID { get; set; }
        public virtual Transaction Transaction { get; set; }
        public virtual decimal Amount { get; set; }
    }
}