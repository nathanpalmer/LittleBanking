using Aplite.Core.DataAccess;
using System.Collections.Generic;

namespace LittleBanking.Children
{
    public interface IChildRepository : IRepository<Child>
    {
        IEnumerable<Child> GetByParent(int ParentID);
    }
}