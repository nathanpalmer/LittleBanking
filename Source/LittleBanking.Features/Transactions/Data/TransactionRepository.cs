using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using Aplite.Core.Domain;
using Aplite.Core.Services;
using Aplite.DataAccess.Domain;
using LittleBanking.Children;
using LittleBanking.Users;
using NHibernate;
using NHibernate.Criterion;

namespace LittleBanking.Transactions
{
    public class TransactionRepository : RepositoryBase<Transaction>, ITransactionRepository
    {
        private readonly IMiddleManagement middleManagement;

        public TransactionRepository(
            ISession Session,
            IMiddleManagement MiddleManagement) : base(Session)
        {
            middleManagement = MiddleManagement;
        }

        public void AddTransaction(Transaction Transaction)
        {
            middleManagement.Post.Add(Transaction);
        }

        public IEnumerable<Transaction> GetTransactions(Child Child)
        {
            return middleManagement
                .Post
                .GetAll(Child.TransactionArea, p => p.Type == ApType.payment)
                .Select(x => ((Transaction) x.Entity));
        }

        public decimal GetBalance(Child Child)
        {
            return session
                .CreateQuery("select sum(Amount) from TransactionDetail as td where td.Transaction.Area.ID = :AreaID")
                .SetParameter("AreaID", Child.TransactionArea.ID)
                .UniqueResult<decimal>();
        }
    }
}
