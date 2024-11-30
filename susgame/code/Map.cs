using susgame.code.machines;
using System;

namespace susgame.code
{

    /// <summary>
    /// 
    /// </summary>
    public class Map
    {

        /// <summary>
        /// The current loaded map data
        /// </summary>
        public static Map Current { get; private set; }

        public static Map CreateMap()
        {
            Current = new Map(40, 10);
            return Current;
        }

        public Tile[,] TileList { get; }

        public int Width { get; }

        public int Height { get; }

        public Map(int width, int height)
        {
            TileList = new Tile[width, height];
            for (int x = 0; x < width; x++)
            {
                for (int y = 0; y < height; y++)
                {
                    TileList[x, y] = new Tile(x, y, this);
                }
            }
            Width = width;
            Height = height;
        }

    }

}