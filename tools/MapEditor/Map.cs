
using System;
using System.Collections;
using System.IO;
using System.Text;

namespace MapEditor
{
    public class Map
    {
        public enum Direction
        {
            North,
            West,
            South,
            East
        }

        public enum SegmentType
        {
            Empty,
            Transition,
            Door,
            Wall
        }

        public int Width
        {
            get { return _cellWidth; }
        }

        public int Height
        {
            get { return _cellHeight; }
        }

        private byte[] _mapData;
        private int _cellWidth;
        private int _cellHeight;
        private int _byteWidth;

        private int GetOffset(int x, int y, Direction direction, out int shift)
        {
            int offset = y * _byteWidth * 2;
            switch (direction)
            {
                case Direction.North:
                    x += 1;
                    break;
                case Direction.South:
                    x += 1;
                    offset += _byteWidth * 2;
                    break;
                case Direction.West:
                    offset += _byteWidth * 1;
                    break;
                case Direction.East:
                    x += 1;
                    offset += _byteWidth * 1;
                    break;
            }

            shift = ((x & 3) ^ 3) << 1;
            offset += x / 4;
            return offset;
        }

        public SegmentType GetSegment(int x, int y, Direction direction)
        {
            int shift;
            int offset = GetOffset(x, y, direction, out shift);
            return (SegmentType)((_mapData[offset] >> shift) & 3);
        }

        public void SetSegment(int x, int y, Direction direction, SegmentType segment)
        {
            if (_mapData != null)
            {
                int shift;
                int offset = GetOffset(x, y, direction, out shift);
                _mapData[offset] = (byte)((_mapData[offset] & ~(3 << shift)) | ((int)segment << shift));
            }
        }

        public bool TextToMap(string text)
        {
            try
            {
                char[] separators = new char[] { ' ', '\t', ',' };
                StringReader reader = new StringReader(text);
                ArrayList array = new ArrayList();

                string line;
                int lineCount = 0;
                int lineWidth = 0;
                while ((line = reader.ReadLine()) != null)
                {
                    bool hex = false;
                    bool db = false;
                    bool dollar = false;

                    string[] strings = line.Split(separators);
                    foreach (string s in strings)
                    {
                        if (s.Length == 0)
                            continue;

                        string str = s.ToLower();
                        if (str == "hex")
                        {
                            hex = true;
                            continue;
                        }
                        if (str == "db")
                        {
                            db = true;
                            continue;
                        }
                        if (str.StartsWith("$"))
                        {
                            dollar = true;
                            str = str.Substring(1);
                            if (str.Length == 0)
                                continue;
                        }
                        if (str == ";")
                            break;
                        if (db)
                        {
                            byte b = Convert.ToByte(str, dollar ? 16 : 10);
                            array.Add(b);
                            dollar = false;
                        }
                        else if (hex)
                        {
                            if (dollar)
                                return false;

                            ++lineCount;
                            int w = str.Length / 2;
                            if (lineWidth == 0)
                                lineWidth = w;
                            else if (lineWidth != w)
                                lineWidth = -1;

                            for (int i = 0; i < str.Length; i += 2)
                            {
                                string substr = str.Substring(i, 2);
                                byte b = Convert.ToByte(substr, 16);
                                array.Add(b);
                            }
                        }
                    }
                }

                switch (array.Count)
                {
                    case (17 * 2 + 1) * 5:
                        _cellWidth = 17;
                        _cellHeight = 17;
                        break;
                    case (15 * 2 + 1) * 4:
                        _cellWidth = 15;
                        _cellHeight = 15;
                        break;
                    case (13 * 2 + 1) * 4:
                        _cellWidth = 13;
                        _cellHeight = 13;
                        break;
                    case (11 * 2 + 1) * 3:
                        _cellWidth = 11;
                        _cellHeight = 11;
                        break;
                    case (9 * 2 + 1) * 3:
                        _cellWidth = 9;
                        _cellHeight = 9;
                        break;
                    default:
                        if (lineWidth > 0 && lineWidth != 3 && (lineCount & 1) != 0)
                        {
                            _cellWidth = (lineWidth * 4) - 1;
                            _cellHeight = (lineCount - 1) / 2;
                            break;
                        }
                        return false;
                }

                _byteWidth = (((_cellWidth + 1) * 2) + 7) / 8;
                _mapData = (byte[])array.ToArray(typeof(byte));
            }
            catch
            {
                return false;
            }
            return true;
        }

        public string MapToText()
        {
            StringBuilder builder = new StringBuilder();

            int sindex = 0;
            for (int y = 0; y < _cellHeight * 2 + 1; ++y)
            {
                builder.Append("\t\t\t\tHEX\t");
                for (int x = 0; x < _byteWidth; ++x)
                {
                    byte b = _mapData[sindex + x];
                    builder.Append(b.ToString("X2", null));
                }
                builder.Append("\n");
                sindex += _byteWidth;
            }

            return builder.ToString();
        }

        public void Clear()
        {
            if (_mapData != null)
            {
                for (int i = 0; i < _mapData.Length; ++i)
                {
                    _mapData[i] = 0;
                }
            }
        }

        public void Reset(int cellWidth, int cellHeight)
        {
            _cellWidth = cellWidth;
            _cellHeight = cellHeight;
            _byteWidth = (((_cellWidth + 1) * 2) + 7) / 8;
            _mapData = new byte[(_cellWidth * 2 + 1) * _byteWidth];

            Clear();
        }
    }
}
