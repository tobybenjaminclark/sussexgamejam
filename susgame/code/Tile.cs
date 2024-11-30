using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace susgame.code
{
    public class Tile : IEnumerable<GameEntity>
    {

        internal List<GameEntity> _contents = new List<GameEntity>();

        /// <summary>
        /// A list of all items contained on this tile
        /// </summary>
        public IReadOnlyList<GameEntity> Contents => _contents;

        public int X { get; }

        public int Y { get; }

        public Map Map { get; }

        public Tile(int x, int y, Map map)
        {
            X = x;
            Y = y;
            Map = map;
        }

        public IEnumerator<GameEntity> GetEnumerator()
        {
            return Contents.GetEnumerator();
        }

        public bool IsOccupied()
        {
            return Contents.Any(x => x.OccupiesTile);
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return ((IEnumerable)Contents).GetEnumerator();
        }
    }
}
