using System;
using Aplite.Core.Domain;

namespace LittleBanking.Goals
{
    public class Goal : Post
    {
        public virtual decimal Amount { get; set; }
        public virtual DateTime AchievementDate { get; set; }
    }
}