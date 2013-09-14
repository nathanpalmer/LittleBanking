using System;
using System.Collections.Generic;
using System.Linq;
using Aplite.Core.Domain;
using Aplite.Core.Services;
using LittleBanking.Transactions;

namespace LittleBanking.Children
{
    public class ChildManager : IChildManager
    {
        private readonly IMiddleManagement middleManagement;
        private readonly IUserSession userSession;
        private readonly IUserManagement userManagement;
        private readonly IChildRepository childRepository;
        private readonly ITransactionRepository transactionRepository;

        public ChildManager(
            IMiddleManagement MiddleManagement,
            IUserSession UserSession,
            IUserManagement UserManagement,
            IChildRepository ChildRepository,
            ITransactionRepository TransactionRepository)
        {
            middleManagement = MiddleManagement;
            userSession = UserSession;
            userManagement = UserManagement;
            childRepository = ChildRepository;
            transactionRepository = TransactionRepository;
        }

        public IEnumerable<Child> GetChildren(User Parent)
        {
            var children = childRepository.GetByParent(Parent.ID).ToList();
            var balances = children
                .Select(x => new { ID = x.UserAccount.ID, Balance = transactionRepository.GetBalance(x)})
                .ToDictionary(x => x.ID, x => x.Balance);

            foreach (var pr in children)
            {
                pr.Balance = balances[pr.UserAccount.ID];
            }

            return children;
        }

        public Child AddChild(Area Area, User user, string Name, string BirthDate)
        {
            var birthDate = DateTime.Parse(BirthDate);
            var child = new User()
            {
                LoginName = string.Format("{0}/{1}", user.ID, Name),
                UserName = Name,
                Password = birthDate.ToShortDateString(),
                BirthDate = birthDate,
                ProviderUserKey = Guid.NewGuid()
            };
            middleManagement.User.Add(child);
            // Add user roles
            child = userManagement.ConfirmRegistration(child.ProviderUserKey.Value, false).Entity;

            var area = new Area()
            {
                ParentArea = Area,
                Name = "Transactions",
                Description = "Transactions",
                DescriptionRaw = "Transactions",
                // Copying permissions from parent
                // TODO: Might want to do something different here?
                AreaRoleAdmin = Area.AreaRoleAdmin,
                AreaRoleView = Area.AreaRoleView,
                CommentRoleView = Area.CommentRoleView,
                CommentRoleCreate = Area.CommentRoleCreate,
                CommentRoleDelete = Area.CommentRoleDelete,
                CommentRoleModerate = Area.CommentRoleModerate,
                PostRoleView = Area.PostRoleView,
                PostRoleCreate = Area.PostRoleCreate,
                PostRoleDelete = Area.PostRoleDelete,
                PostRoleModerate = Area.PostRoleModerate,
            };
            middleManagement.Area.Add(area);

            var parentChild = new Child()
            {
                Parent = user,
                UserAccount = child,
                TransactionArea = area
            };

            childRepository.Save(parentChild);

            return parentChild;
        }

        public Child GetChild(User Parent, int ChildUserID)
        {
            return childRepository.GetByParent(Parent.ID).Where(x => x.UserAccount.ID == ChildUserID).FirstOrDefault();
        }
    }
}