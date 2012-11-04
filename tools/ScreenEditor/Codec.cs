
using System;
using System.Collections;
using System.Drawing;
using System.IO;
using System.Text;

namespace ScreenEditor
{
	public class Codec
	{
		public static string CaptureToText(Screen screen,Rectangle bounds)
		{
			int left = bounds.Left / 7;
			int right = (bounds.Right + 6) / 7;
			int columns = right - left;
			int sindex = bounds.Top * 40 + left;
			StringBuilder builder = new StringBuilder();
			
			builder.Append(String.Format("\t\t\t\tDB\t{0},{1},{2},{3}\n",
				left,bounds.Top,right,bounds.Bottom));
			for (int y = bounds.Top; y < bounds.Bottom; ++y)
			{
				builder.Append("\t\t\t\tHEX\t");
				for (int x = 0; x < columns; ++x)
				{
					byte b = screen.RawBuffer[sindex + x];
					builder.Append(b.ToString("X2",null));
				}
				builder.Append("\n");
				sindex += 40;
			}
			
			return builder.ToString();
		}
		
		public static string CompressToText(Screen screen,Rectangle bounds)
		{
			byte[] data = Codec.Compress(screen,bounds);
			StringBuilder builder = new StringBuilder();
			
			int si = 0;
			int column = 0;
			while (si < data.Length)
			{
				if (column == 0)
					builder.Append("\t\t\t\tHEX\t");
				
				byte b = data[si++];
				builder.Append(b.ToString("X2",null));
				
				if (++column == 24)
				{
					builder.Append("\n");
					column = 0;
				}
			}
			if (column != 0)
				builder.Append("\n");
			
			return builder.ToString();
		}
		
		public static byte[] Compress(Screen screen,Rectangle bounds)
		{
			int top = bounds.Top;
			int bottom = bounds.Bottom - 1;
			int left = bounds.Left / 7;
			int right = (bounds.Right + 6) / 7 - 1;
			ArrayList data = new ArrayList();
			
			data.Add((byte)top);
			data.Add((byte)bottom);
			data.Add((byte)left);
			data.Add((byte)right);
			
			byte c = 0;
			byte v = 0;
			int x = right;
			while (x >= left)
			{
				int y = bottom;
				while (y >= top)
				{
					byte b = screen.RawBuffer[y * 40 + x];
					if (c > 0)
					{
						if (b == v)
						{
							if (++c == 255)
							{
								data.Add((byte)0xFE);
								data.Add(c);
								data.Add(v);
								c = 0;
							}
						}
						else
						{
							if (c > 3 || v == 0xFE)
							{
								data.Add((byte)0xFE);
								data.Add(c);
								data.Add(v);
							}
							else
							{
								while (c-- > 0)
									data.Add(v);
							}
							v = b;
							c = 1;
						}
					}
					else
					{
						v = b;
						c = 1;
					}
					y -= 1;
				}
				x -= 1;
			}
			
			if (c > 3 || v == 0xFE)
			{
				data.Add((byte)0xFE);
				data.Add(c);
				data.Add(v);
			}
			else
			{
				while (c-- > 0)
					data.Add(v);
			}
			
			return (byte[])data.ToArray(typeof(byte));
		}
		
		public static bool Decompress(byte[] data,Screen screen,out Rectangle bounds)
		{
			bounds = Rectangle.Empty;
			try
			{
				int si = 0;
				int top = data[si++];
				int bottom = data[si++];
				int left = data[si++];
				int right = data[si++];
				
				bounds.X = left * 7;
				bounds.Y = top;
				bounds.Width = (right + 1) * 7 - bounds.X;
				bounds.Height = bottom - bounds.Y + 1;
				
				int x = right;
				byte c = 0;
				byte v = 0;
				while (x >= left)
				{
					int y = bottom;
					while (y >= top)
					{
						if (c == 0)
						{
							v = data[si++];
							
							if (v == 0xFE)
							{
								c = data[si++];
								v = data[si++];
							}
							else
								c = 1;
						}
						
						screen.RawBuffer[y * 40 + x] = v;
						c -= 1;
						y -= 1;
					}
					x -= 1;
				}
			}
			catch
			{
				return false;
			}
			screen.UpdateColorBuffer();
			return true;
		}
		
		private static void HexToScreen(byte[] data,int index,Screen screen,Rectangle bounds)
		{
			int x1 = (bounds.X + 6) / 7;
			int x2 = (bounds.X + bounds.Width + 6) / 7;
			int y1 = bounds.Y;
			int y2 = bounds.Y + bounds.Height;
			
			for (int y = y1; y < y2; ++y)
			{
				for (int x = x1; x < x2; ++x)
					screen.RawBuffer[y * 40 + x] = data[index++];
			}
			screen.UpdateColorBuffer();
		}
		
		private static bool TextToHex(string text,out byte[] data,out Rectangle bounds)
		{
			data = null;
			bounds = Rectangle.Empty;
			try
			{
				char[] separators = new char[] {' ', '\t', ',' };
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
							byte b = Convert.ToByte(str,dollar ? 16 : 10);
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
								string substr = str.Substring(i,2);
								byte b = Convert.ToByte(substr,16);
								array.Add(b);
							}
						}
					}
				}
				
				if (lineWidth > 0)
					bounds = new Rectangle(0,0,lineWidth * 7,lineCount);
				data = (byte[])array.ToArray(typeof(byte));
			}
			catch
			{
				return false;
			}
			return true;
		}
		
		private enum HexDataType
		{
			Unknown			= 0,
			RawNoHeader		= 1,
			RawWithHeader	= 2,
			Compressed		= 3
		};
		
		public static bool TextToScreen(string text,Screen screen,out Rectangle bounds)
		{
			byte[] data;
			
			if (!Codec.TextToHex(text,out data,out bounds))
				return false;
			
			HexDataType type = HexDataType.Unknown;
			int startIndex = 0;
			
			if (!bounds.IsEmpty)
			{
				int rawSize = (bounds.Width + 6) / 7 * bounds.Height;
				if (data.Length == rawSize)
				{
					// raw hex without header
					type = HexDataType.RawNoHeader;
				}
				else if (data.Length == rawSize + 4)
				{
					// raw hex with header
					int w = data[2] - data[0];
					int h = data[3] - data[1];
					if (w * h == rawSize &&
						w * 7 == bounds.Width &&
						h == bounds.Height)
					{
						type = HexDataType.RawWithHeader;
						bounds.X = data[0] * 7;
						bounds.Y = data[1];
						startIndex = 4;
					}
				}
			}
			
			// check for compressed data
			if (type == HexDataType.Unknown && (data.Length > 4))
			{
				int y1 = data[0];	// top
				int y2 = data[1];	// bottom
				int x1 = data[2];	// left
				int x2 = data[3];	// right
				
				if (y1 <= y2 && x1 <= x2 && y2 < 192 && x2 < 40)
				{
					type = HexDataType.Compressed;
					bounds.X = x1 * 7;
					bounds.Y = y1;
					bounds.Width = (x2 - x1 + 1) * 7;
					bounds.Height = y2 - y1 + 1;
				}
			}
			
			if (type == HexDataType.Unknown)
				return false;
			
			if (type == HexDataType.Compressed)
				Codec.Decompress(data,screen,out bounds);
			else
				Codec.HexToScreen(data,startIndex,screen,bounds);
			
			return true;
		}
	}
}
