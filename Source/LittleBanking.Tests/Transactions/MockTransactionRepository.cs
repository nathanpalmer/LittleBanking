using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Aplite.Core.UnitTests.Services;
using LittleBanking.Children;
using LittleBanking.Transactions;

namespace LittleBanking.Tests
{
    public class MockTransactionRepository : MockRepositoryBase<Transaction>, ITransactionRepository
    {
        public MockTransactionRepository(IEnumerable<Transaction> Items) : base(Items)
        {
        }

        public void AddTransaction(Transaction Transaction)
        {
            items.Add(Transaction);
        }

        public IEnumerable<Transaction> GetTransactions(Child Child)
        {
            return items.Where(x => x.Area.ID == Child.TransactionArea.ID);
        }

        public decimal GetBalance(Child Child)
        {
            return GetTransactions(Child).Sum(x => x.Amount);
        }
    }
}
