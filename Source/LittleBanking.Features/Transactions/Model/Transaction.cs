using System.Collections.Generic;
using System.Linq;
using System.Text;
using Aplite.Core.Domain;

namespace LittleBanking.Transactions
{
    public class Transaction : Post
    {
        public virtual decimal Amount
        {
            get { return Detail.Amount; }
            set { Detail.Amount = value; }
        }

        public virtual TransactionDetail Detail { get; set; }

        public Transaction()
        {
            Type = ApType.payment;
            Detail = new TransactionDetail();
        }
    }
}
