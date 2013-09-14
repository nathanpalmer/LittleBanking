using Aplite.Core.DataAccess;
using System.Collections.Generic;
using LittleBanking.Children;
using LittleBanking.Users;

namespace LittleBanking.Transactions
{
    public interface ITransactionRepository : IRepository<Transaction>
    {
        void AddTransaction(Transaction Transaction);
        IEnumerable<Transaction> GetTransactions(Child Child);
        decimal GetBalance(Child Child);
    }
}