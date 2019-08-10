
using System;
using System.Collections;
using System.IO;
using System.Text;

// map format is NN.EE.SS.WW

namespace MapEditor
{
    public class Map2 : Map
    {
        public override SegmentType GetSegment(int x, int y, Direction direction)
        {
            int offset = y * _cellWidth + x;
            int shift = 6 - ((int)direction * 2);
            byte value = (byte)((_mapData[offset] >> shift) & 3);
            return (SegmentType)value;
        }

        private void SetOneSegment(int x, int y, Direction direction, SegmentType segment)
        {
            int offset = y * _cellWidth + x;
            int shift = 6 - ((int)direction * 2);
            int mask = 3 << shift;
            int bits = ((int)segment & 3) << shift;
            _mapData[offset] = (byte)((_mapData[offset] & ~mask) | bits);
        }

        public override void SetSegment(int x, int y, Direction direction, SegmentType segment)
        {
            if (_mapData != null)
            {
                SetOneSegment(x, y, direction, segment);

                switch (direction)
                {
                    case Direction.North:

                        if (--y < 0)
                            return;

                        direction = Direction.South;
                        break;

                    case Direction.East:

                        if (++x == _cellWidth)
                            return;

                        direction = Direction.West;
                        break;

                    case Direction.South:
                        if (++y == _cellHeight)
                            return;

                        direction = Direction.North;
                        break;

                    case Direction.West:
                        if (--x < 0)
                            return;

                        direction = Direction.East;
                        break;
                }

                SetOneSegment(x, y, direction, segment);
            }
        }

        protected override bool CalculateMapSize(int arrayCount, int lineWidth, int lineCount)
        {
            switch (arrayCount)
            {
                case 17 * 17:
                    _cellWidth = 17;
                    _cellHeight = 17;
                    break;

                case 15 * 15:
                    _cellWidth = 15;
                    _cellHeight = 15;
                    break;

                case 13 * 13:
                    _cellWidth = 13;
                    _cellHeight = 13;
                    break;

                case 11 * 11:
                    _cellWidth = 11;
                    _cellHeight = 11;
                    break;

                case 9 * 9:
                    _cellWidth = 9;
                    _cellHeight = 9;
                    break;

                default:
                    if (lineWidth > 0)
                    {
                        _cellWidth = lineWidth;
                        _cellHeight = lineCount;
                        break;
                    }
                    return false;
            }

            return true;
        }

        public override string MapToText()
        {
            StringBuilder builder = new StringBuilder();

            int sindex = 0;
            for (int y = 0; y < _cellHeight; ++y)
            {
                builder.Append("\t\t\t\tHEX\t");
                for (int x = 0; x < _cellWidth; ++x)
                {
                    byte b = _mapData[sindex + x];
                    builder.Append(b.ToString("X2", null));
                }
                builder.Append("\n");
                sindex += _cellWidth;
            }

            return builder.ToString();
        }

        public override void Reset(int cellWidth, int cellHeight)
        {
            _cellWidth = cellWidth;
            _cellHeight = cellHeight;
            _mapData = new byte[_cellHeight * _cellWidth];

            Clear();
        }
    }
}
