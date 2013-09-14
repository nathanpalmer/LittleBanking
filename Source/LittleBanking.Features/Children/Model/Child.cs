using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using global::Aplite.Core.Domain;

namespace LittleBanking.Children
{
    public class Child : PersistentObject
    {
        public virtual User Parent { get; set; }
        public virtual User UserAccount { get; set; }
        public virtual Area TransactionArea { get; set; }
        public virtual decimal Balance { get; set; }
    }
}
