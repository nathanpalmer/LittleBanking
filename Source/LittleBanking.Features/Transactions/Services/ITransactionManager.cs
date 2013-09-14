using System;
using System.Collections.Generic;
using System.Text;
using LittleBanking.Children;
using LittleBanking.Users;

namespace LittleBanking.Transactions
{
    public interface ITransactionManager
    {
        void AddMoney(Child ParentChild, decimal Amount);
        Dictionary<int, decimal> GetBalances(int ParentUserID);
    }
}
