using System.Collections.Generic;
using System.Linq;
using Aplite.Core.Domain;
using Aplite.Core.Services;
using LittleBanking.Children;

namespace LittleBanking.Transactions
{
    public class TransactionManager : ITransactionManager
    {
        private readonly IUserSession userSession;
        private readonly IChildRepository childRepository;
        private readonly ITransactionRepository transactionRepository;
        private readonly IMiddleManagement middleManagement;

        public TransactionManager(
            IUserSession UserSession,
            IChildRepository ChildRepository,
            ITransactionRepository TransactionRepository,
            IMiddleManagement MiddleManagement)
        {
            userSession = UserSession;
            childRepository = ChildRepository;
            transactionRepository = TransactionRepository;
            middleManagement = MiddleManagement;
        }

        public void AddMoney(Child ParentChild, decimal Amount)
        {
            var user = userSession.GetCurrent();
            var transaction = new Transaction()
            {
                Area = ParentChild.TransactionArea,
                User = user,
                Amount = Amount,
                Title = "Transaction",
                Raw = new PostRaw()
                {
                    Body = ""
                }
            };
            transaction.Detail.Transaction = transaction;

            transactionRepository.AddTransaction(transaction);
        }

        public Dictionary<int, decimal> GetBalances(int ParentUserID)
        {
            var children = childRepository.GetByParent(ParentUserID);

            return children.Select(c => new
                                        {
                                            ChildID = c.UserAccount.ID,
                                            Balance = transactionRepository.GetTransactions(c).Select(x => x.Amount).Sum()
                                        }).ToDictionary(x => x.ChildID, x => x.Balance);
        }
    }
}