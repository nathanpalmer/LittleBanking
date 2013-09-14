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
    public class ChildTests
    {
        private Area defaultArea;
        private User parent;
        private IMiddleManagement middleManagement;
        private IChildManager parentChildManager;
        private IChildRepository childRepository;
        private TransactionManager transactionManager;

        public ChildTests()
        {
            defaultArea = new Area { ID = 1, Name = "Default" };
            parent = new User { ID = 1, UserName = "Parent" };

            var mockUserSession = new Mock<IUserSession>();
            mockUserSession.Setup(x => x.GetCurrent()).Returns(parent);
            var userSession = mockUserSession.Object;

            middleManagement = new MockMiddleManagement(parent, new[] { defaultArea }, null, null, new[] { parent });
            childRepository = new MockChildRepository();
            var transactionRepository = new MockTransactionRepository(new Transaction[0]);
            parentChildManager = new ChildManager(middleManagement, userSession, middleManagement.User, childRepository, transactionRepository);
            transactionManager = new TransactionManager(userSession, childRepository, transactionRepository, middleManagement);
        }

        [Test]
        public void Can_Add_Child_To_Parent()
        {
            // Arrange

            // Act
            parentChildManager.AddChild(defaultArea, parent, "Tavis", "01/01/2001");
            var children = childRepository.GetByParent(parent.ID);

            // Assert
            children.Count().ShouldBe(1);
            children.First().UserAccount.LoginName.ShouldBe(string.Format("{0}/{1}", parent.ID, "Tavis"));
        }

        [Test]
        public void When_Adding_A_Child_Does_It_Set_The_Login()
        {
            // Act
            parentChildManager.AddChild(defaultArea, parent, "Tavis", "01/01/2001");
            var children = childRepository.GetByParent(parent.ID);

            // Assert
            children.First().UserAccount.LoginName.ShouldBe(string.Format("{0}/{1}", parent.ID, "Tavis"));
        }

        [Test]
        public void When_Adding_A_Child_Does_It_Set_The_User()
        {
            // Act
            parentChildManager.AddChild(defaultArea, parent, "Tavis", "01/01/2001");
            var children = childRepository.GetByParent(parent.ID);

            // Assert
            children.First().UserAccount.UserName.ShouldBe("Tavis");
        }

        
    }
}
