using System;
using System.Linq;
using System.Web.Mvc;
using Aplite.Core.Domain;
using Autofac;
using LittleBanking.Children;
using LittleBanking.Transactions;

namespace LittleBanking.Config
{
    public class DefaultModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {
            builder.RegisterType<ChildRepository>().As<IChildRepository>();
            builder.RegisterType<ChildManager>().As<IChildManager>();
            builder.RegisterType<TransactionRepository>().As<ITransactionRepository>();
            builder.RegisterType<TransactionManager>().As<ITransactionManager>();
        }
    }
}
