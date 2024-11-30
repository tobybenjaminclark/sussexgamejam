using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace susgame.code
{
    public abstract class GameEntity
    {

        /// <summary>
        /// The tile where we are currently located
        /// </summary>
        public Tile Location { get; private set; }

        /// <summary>
        /// If true, then we are indicating that this entity is not expected to move
        /// </summary>
        public virtual bool Anchored => false;

        /// <summary>
        /// If true, then things will not be able to be placed at this location
        /// </summary>
        public virtual bool OccupiesTile => false;

        private float _x;

        private float _y;

        /// <summary>
        /// X position of the game entitiy, directly tied to the godot object
        /// </summary>
        public float X
        {
            get => _x;
            set {
                _x = value;
                // Clamp the location to keep it on the map
                _x = Math.Clamp(value, 0, Location.Map.Width - float.Epsilon);
                // Moved to a new location
                if (_x >= Location.X + 1 || _x < Location.X || _y >= Location.Y + 1 || _y < Location.Y)
                {
                    Location = Location.Map.TileList[(int)_x, (int)_y];
                }
            }
        }

        /// <summary>
        /// X position of the game entitiy, directly tied to the godot object
        /// </summary>
        public float Y
        {
            get => _y;
            set
            {
                _y = value;
                // Clamp the location to keep it on the map
                _y = Math.Clamp(value, 0, Location.Map.Height - float.Epsilon);
                // Moved to a new location
                if (_x >= Location.X + 1 || _x < Location.X || _y >= Location.Y + 1 || _y < Location.Y)
                {
                    Location = Location.Map.TileList[(int)_x, (int)_y];
                }
            }
        }

        /// <summary>
        /// Perform a single tick
        /// </summary>
        /// <param name="deltaTime"></param>
        public virtual void Tick(TimeSpan deltaTime)
        {

        }

    }
}
