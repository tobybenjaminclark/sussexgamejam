using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace susgame.code.integration
{
    public partial class GDGameEntity : Node3D
    {

        public GameEntity gameEntity;

        public override void _Ready()
        {
            
        }

        public override void _Process(double delta)
        {
            gameEntity.Tick(delta);
        }

    }
}
