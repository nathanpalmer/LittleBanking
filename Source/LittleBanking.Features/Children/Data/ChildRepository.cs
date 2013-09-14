using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using Aplite.DataAccess.Domain;
using LittleBanking.Transactions;
using NHibernate;

namespace LittleBanking.Children
{
    public class ChildRepository : RepositoryBase<Child>, IChildRepository
    {
        private readonly ITransactionRepository _transactionRepository;

        public ChildRepository(ISession Session, ITransactionRepository TransactionRepository)
            : base(Session)
        {
            _transactionRepository = TransactionRepository;
        }

        public IEnumerable<Child> GetByParent(int ParentID)
        {
            return Query().Where(x => x.Parent.ID == ParentID);
        }
    }
}
