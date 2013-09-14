using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Aplite.Core.UnitTests.Services;
using LittleBanking.Children;

namespace LittleBanking.Tests
{
    class MockChildRepository : MockRepositoryBase<Child>, IChildRepository
    {
        public MockChildRepository() : base(new Child[0])
        {
            
        }

        public MockChildRepository(IEnumerable<Child> Items) : base(Items)
        {
        }

        public IEnumerable<Child> GetByParent(int ParentID)
        {
            return items.Where(x => x.Parent.ID == ParentID);
        }
    }
}
