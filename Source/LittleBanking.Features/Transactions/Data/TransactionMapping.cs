using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Aplite.Core.Domain;
using FluentNHibernate.Mapping;
using LittleBanking.Users;

namespace LittleBanking.Transactions
{
    public class TransactionMapping : SubclassMap<Transaction>
    {
        public TransactionMapping()
        {
            DiscriminatorValue((byte)ApType.payment);

            HasOne(x => x.Detail)
                .LazyLoad()
                .Cascade.All();
        }
    }
}
