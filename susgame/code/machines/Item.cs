using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace susgame.code.machines
{
    internal class Item : GameEntity
    {

        public Item(Map map, float x, float y) : base(map, x, y)
        {
        }

        protected override string _Model => "hammer";

    }
}
