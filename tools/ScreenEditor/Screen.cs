
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;

namespace ScreenEditor
{
	public class Screen
	{
		private byte[] _rawBuffer;
		private Bitmap _colorBuffer;
		private const byte kBLACK = 0;
		private const byte kWHITE = 1;
		private const byte kPURPLE = 2;
		private const byte kGREEN = 3;
		private const byte kBLUE = 4;
		private const byte kORANGE = 5;
		private Rectangle lockRect = new Rectangle(0,0,280,192);
		private bool _interpolate;
		
		public Bitmap Bitmap
		{
			get { return _colorBuffer; }
		}
		
		public byte[] RawBuffer
		{
			get { return _rawBuffer; }
		}
		
		public bool Interpolate
		{
			get { return _interpolate; }
			set
			{
				if (value != _interpolate)
				{
					_interpolate = value;
					UpdateColorBuffer();
				}
			}
		}
		
		public Screen()
		{
			_rawBuffer = new byte[40 * 192];
			_colorBuffer = new Bitmap(280,192,PixelFormat.Format8bppIndexed);
			
			ColorPalette palette = _colorBuffer.Palette;
			palette.Entries[kBLACK]  = Color.Black;
			palette.Entries[kWHITE]  = Color.White;
			palette.Entries[kPURPLE] = Color.FromArgb(0xA0,0x00,0xFF);
			palette.Entries[kGREEN]  = Color.FromArgb(0x20,0xC0,0x00);
			palette.Entries[kBLUE]   = Color.FromArgb(0x00,0x80,0xFF);
			palette.Entries[kORANGE] = Color.FromArgb(0xF0,0x50,0x00);
			_colorBuffer.Palette = palette;
			_interpolate = true;
		}
		
		// load scrambled Apple II format screen file
		public void Load(string fileName)
		{
			FileStream stream = File.OpenRead(fileName);
			Load(stream);
			stream.Close();
		}
		
		public void Load(Stream stream)
		{
			// check for bin file header
			uint headerSize = 0;
			byte [] header = new byte[4];
			stream.Read(header,0,4);
			if (header[0] == 0x00 && header[1] == 0x20 &&
				header[2] == 0x00 && header[3] == 0x20)
			{
				headerSize = 4;
			}
			
			for (int y = 0; y < 192; ++y)
			{
				uint offset = LineToOffset(y);
				stream.Position = headerSize + offset;
				stream.Read(_rawBuffer,y * 40,40);
			}
			UpdateColorBuffer();
		}
		
		public void Clear()
		{
			for (int i = 0; i < 40 * 192; ++i)
				_rawBuffer[i] = 0;
			UpdateColorBuffer();
		}
		
		public void Reverse()
		{
			for (int i = 0; i < 40 * 192; )
			{
				_rawBuffer[i++] ^= 0x2A;
				_rawBuffer[i++] ^= 0x55;
			}
			UpdateColorBuffer();
		}
		
		public void SetPixel(Point p,bool pixelOn,bool highBit)
		{
			int index = p.Y * 40 + p.X / 7;
			byte mask = (byte)(1 << (p.X % 7));
			byte b = _rawBuffer[index];
			if (pixelOn)
				b |= mask;
			else
				b = (byte)(b & ~mask);
			if (highBit)
				b |= 0x80;
			else
				b &= 0x7F;
			_rawBuffer[index] = b;
			UpdateColorBuffer(p.Y,p.Y + 1);
		}
		
		public void UpdateColorBuffer()
		{
			UpdateColorBuffer(0,192);
		}
		
		// update color buffer with contents of raw buffer
		public unsafe void UpdateColorBuffer(int startLine,int endLine)
		{
			BitmapData lockData;
			lockData = _colorBuffer.LockBits(lockRect,
											 ImageLockMode.ReadWrite,
											 PixelFormat.Format8bppIndexed);
			
			byte* dst = (byte*)lockData.Scan0 + startLine * 280;
			int stride = lockData.Stride;
			
			int sindex = startLine * 40;
			for (int y = startLine; y < endLine; ++y)
			{
				byte* dp = dst;
				for (int x = 0; x < 40; ++x)
				{
					byte b = _rawBuffer[sindex++];				
					bool highBit = ((b & 0x80) != 0);
					byte mask = 1;
					byte color;
					
					for (int p = 0; p < 7; ++p)
					{
						if ((b & mask) != 0)
						{
							if (((p ^ x) & 1) == 0)
								color = highBit ? kBLUE : kPURPLE;
							else
								color = highBit ? kORANGE : kGREEN;
						}
						else
							color = kBLACK;
						
						*dp++ = color;
						mask <<= 1;
					}
				}
				
				dp = dst;
				byte prev = 0;
				byte curr = 0;
				byte next = *dp++;
				for (int x = 0; x < 279; ++x)
				{
					prev = curr;
					curr = next;
					next = *dp++;
					
					if (curr == kBLACK)
					{
						if (prev == next && _interpolate)
							*(dp - 2) = prev;
					}
					else if (prev != kBLACK || next != kBLACK)
						*(dp - 2) = kWHITE;
				}
				
				prev = curr;
				curr = next;
				if (curr == kBLACK)
				{
					if (_interpolate)
						*(dp - 1) = prev;
				}
				else if (prev != kBLACK)
					*(dp - 1) = kWHITE;
				
				dst += stride;
			}
			
			_colorBuffer.UnlockBits(lockData);
		}
		
		// turn line index into scrambled Apple II offset
		private uint LineToOffset(int y)
		{
			return _lineTable[y >> 3] + (((uint)y & 7) << 10);
		}
		
		private static ushort [] _lineTable = new ushort[]
		{
			0x0000,0x0080,0x0100,0x0180,0x0200,0x0280,0x0300,0x0380,
			0x0028,0x00A8,0x0128,0x01A8,0x0228,0x02A8,0x0328,0x03A8,
			0x0050,0x00D0,0x0150,0x01D0,0x0250,0x02D0,0x0350,0x03D0
		};
	}
}

