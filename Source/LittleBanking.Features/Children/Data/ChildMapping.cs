using FluentNHibernate.Mapping;

namespace LittleBanking.Children
{
    public class ChildMapping : ClassMap<Child>
    {
        public ChildMapping()
        {
            Table("tbcParentChild");
            Id(x => x.ID).Column("ParentChildID");
            References(x => x.Parent)
                .ForeignKey("ParentUserID")
                .Column("ParentUserID");
            References(x => x.UserAccount)
                .ForeignKey("ChildUserID")
                .Column("ChildUserID");
            References(x => x.TransactionArea)
                .ForeignKey("ChildAreaID")
                .Column("ChildAreaID");
        }
    }
}
