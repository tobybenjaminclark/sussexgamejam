using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace susgame.code.machines
{
    internal class Creator : GameEntity
    {

        private float nextSpawnTime;

        public Creator(Map map, float x, float y) : base(map, x, y)
        {
        }
        public Vector2 PushPower { get; set; } = new Vector2(1, 0);

        public override bool Anchored => true;

        public override bool OccupiesTile => true;

        protected override string _Model => "hammer";

        public override void Tick(double deltaTime)
        {
            Location.Where(item => !item.Anchored)
                .ForEach(item =>
                {
                    item.X += PushPower.X * (float)deltaTime;
                    item.Y += PushPower.Y * (float)deltaTime;
                });
            if (Time.GetTicksMsec() < nextSpawnTime)
                return;
            nextSpawnTime = Time.GetTicksMsec() + 5000;
            new Item(Map.Current, X, Y);
        }

    }
}
