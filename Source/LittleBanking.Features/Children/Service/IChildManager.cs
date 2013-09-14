using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Aplite.Core.Domain;

namespace LittleBanking.Children
{
    public interface IChildManager
    {
        IEnumerable<Child> GetChildren(User Parent);
        Child AddChild(Area Area, User Parent, string Name, string BirthDate);
        Child GetChild(User Parent, int ChildUserID);
    }
}
