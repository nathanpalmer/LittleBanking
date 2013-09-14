using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Aplite.Core.Domain;
using Aplite.Core.Services;
using Aplite.Core.UnitTests.Services;
using LittleBanking.Children;
using LittleBanking.Transactions;
using Moq;
using NUnit.Framework;
using Shouldly;

namespace LittleBanking.Tests
{
    [TestFixture]
    public class TransactionTests
    {
        private Area defaultArea;
        private User parent;
        private IMiddleManagement middleManagement;
        private IChildManager parentChildManager;
        private IChildRepository childRepository;
        private ITransactionManager transactionManager;
        private User child;
        private ITransactionRepository transactionRepository;

        public TransactionTests()
        {
            var roleAuthenticated = new Role { ID = 2, Title = "authenticated user" };
            defaultArea = new Area { ID = 1, Name = "Default", PostRoleCreate = roleAuthenticated};
            parent = new User { ID = 1, UserName = "Parent", Roles = new List<Role>(new[]{roleAuthenticated})};
            child = new User { ID = 2, UserName = "Tavis" };
            var childArea = new Area { ID = 2, Name = "Transactions", PostRoleCreate = roleAuthenticated};

            var mockUserSession = new Mock<IUserSession>();
            mockUserSession.Setup(x => x.GetCurrent()).Returns(parent);
            var userSession = mockUserSession.Object;

            middleManagement = new MockMiddleManagement(parent, new[] { defaultArea }, null, null, new[] { parent });
            childRepository = new MockChildRepository(new[]{new Child{Parent = parent, UserAccount = child, TransactionArea = childArea}});
            transactionRepository = new MockTransactionRepository(new Transaction[0]);
            parentChildManager = new ChildManager(middleManagement, userSession, middleManagement.User, childRepository, transactionRepository);
            transactionManager = new TransactionManager(userSession, childRepository, transactionRepository, middleManagement);
        }

        [Test]
        public void Can_Add_Money_To_Child()
        {
            // Arrange
            decimal Amount = 10;
            var parentChild = childRepository.GetByParent(1).First();

            // Act
            transactionManager.AddMoney(parentChild, Amount);

            // Assert
            parentChildManager.GetChildren(parent).First().Balance.ShouldBe(Amount);
        }
    }
}
