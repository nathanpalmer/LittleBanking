using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Aplite.Core.Domain;

namespace LittleBanking.Children
{
    public class ChildList
    {
        public IEnumerable<Child> Children { get; set; }

        public class Child
        {
            public int ID { get; set; }
            public int AreaID { get; set; }
            public string Name { get; set; }
            public string BirthDate { get; set; }
            public string Goal { get; set; }
            public decimal Balance { get; set; }
        }
    }
}
