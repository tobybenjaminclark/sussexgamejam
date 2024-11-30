using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace susgame.code.machines
{
    public class Conveyor : GameEntity
    {

        public Vector2 PushPower { get; set; }

        public override bool Anchored => true;

        public override bool OccupiesTile => true;

        public override void Tick(TimeSpan deltaTime)
        {
            Location.Where(item => !item.Anchored)
                .ForEach(item =>
                {
                    item.X += PushPower.X * (float)deltaTime.TotalSeconds;
                    item.Y += PushPower.Y * (float)deltaTime.TotalSeconds;
                });
        }

    }
}
