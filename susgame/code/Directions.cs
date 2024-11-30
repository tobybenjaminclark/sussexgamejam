using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace susgame.code
{
    public enum Directions
    {
        NORTH = (1 << 0),
        SOUTH = (1 << 1),
        EAST = (1 << 2),
        WEST = (1 << 3)
    }
}
