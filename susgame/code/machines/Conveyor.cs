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
        public Conveyor(Map map, float x, float y) : base(map, x, y)
        {
        }

        public Vector2 PushPower { get; set; } = new Vector2(1, 0);

        public override bool Anchored => true;

        public override bool OccupiesTile => true;

        protected override string _Model => "conveyor_1";

        public override void Tick(double deltaTime)
        {
            Location.Where(item => !item.Anchored)
                .ForEach(item =>
                {
                    item.X += PushPower.X * (float)deltaTime;
                    item.Y += PushPower.Y * (float)deltaTime;
                });
        }

    }
}
