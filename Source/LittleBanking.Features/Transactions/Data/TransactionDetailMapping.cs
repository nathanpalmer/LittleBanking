using FluentNHibernate.Mapping;
using LittleBanking.Users;

namespace LittleBanking.Transactions
{
    public class TransactionDetailMapping : ClassMap<TransactionDetail>
    {
        public TransactionDetailMapping()
        {
            Cache.NonStrictReadWrite();
            LazyLoad();

            Table("tbcPost_Transaction");

            HasOne(x => x.Transaction)
                .Constrained()
                .ForeignKey();

            Id(x => x.ID)
                .Column("PostID")
                .GeneratedBy.Foreign("Transaction");

            Map(x => x.Amount);
        }
    }
}