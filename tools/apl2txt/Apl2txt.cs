using System;
using System.IO;
using System.Text;

namespace Apl2txt
{
	class App
	{
		static string rootOut = null;
		
		static void ConvertFile(string path)
		{
			if (path.EndsWith(".new"))
				return;
			
			if (!path.EndsWith(".S"))
				return;
			
			Console.WriteLine("Converting {0}", path);
			
			Stream inStream = File.OpenRead(path);
			BinaryReader reader = new BinaryReader(inStream);
			
			string writePath;
			if (rootOut != null)
				writePath = rootOut + path;
			else
				writePath = path + ".new";
			StreamWriter writer = new StreamWriter(writePath);
			
			bool endOfFile = false;
			while (true)
			{
				// read one line
				byte [] b = new byte[1];
				StringBuilder builder = new StringBuilder();
				int column = 0;
				bool foundComment = false;
				bool firstChar = true;
				bool inQuote = false;
				while (true)
				{
					int nn = inStream.ReadByte();
					if (nn == -1)
					{
						endOfFile = true;
						break;
					}
					int c = nn & 0x7F;
					if (c == 0x0D)
						break;
					if (firstChar)
					{
						if (c == '*')
							foundComment = true;
						firstChar = false;
					}
					if (c == '\"' || c == '\'')
					{
						inQuote = !inQuote;
					}
					else if (c == ' ')
					{
						if (!foundComment && !inQuote)
						{
							int target;
							if (column <= 16)
								target = 16;
							else if (column <= 20)
								target = 20;
							else
								target = (column & ~3) + 4;
							b[0] = 0x09;	// spaces become tabs
							do {
								builder.Append(Encoding.ASCII.GetChars(b));
								column += 4 - (column % 4);
							} while (column < target);
							continue;
						}
					}
					else if (c == ';')
					{
						if (!foundComment)
						{
							if (builder.Length == 0 || builder[builder.Length - 1] == '\t')
							{
								while (column < 36)
								{
									builder.Append('\t');
									column += 4 - (column % 4);
								}
							}
							foundComment = true;
						}
					}
					b[0] = (byte)c;
					builder.Append(Encoding.ASCII.GetChars(b));
					column += 1;
				}
				
				if (endOfFile)
					break;
				
				string line = builder.ToString();
				writer.WriteLine(line);
			}
			
			reader.Close();
			writer.Close();
		}
		
		static void ConvertFiles(string[] paths)
		{
			foreach (string path in paths)
				ConvertFile(path);
		}
		
		static void ConvertDir(string path)
		{
			if (rootOut != null)
			{
				if (!Directory.Exists(rootOut + path))
					Directory.CreateDirectory(rootOut + path);
			}
			
			ConvertFiles(Directory.GetFiles(path,"*.*"));
			
			string[] dirs = Directory.GetDirectories(path);
			foreach (string dir in dirs)
				ConvertDir(dir);
		}
		
		[STAThread]
		static void Main(string[] args)
		{
			string fileName = null;
			
			for (int i = 0; i < args.Length; ++i)
			{
				string str = args[i];
				if (str == "-outdir")
				{
					if (++i < args.Length)
					{
						if (rootOut != null)
						{
							Console.WriteLine("Only one output directory allowed");
							return;
						}
						rootOut = args[i];
					}
					else
					{
						Console.WriteLine("Missing directory name");
						return;
					}
				}
				else if (fileName == null)
				{
					fileName = str;
				}
				else
				{
					Console.WriteLine("Only one input file allowed");
					return;
				}
			}
			
			if (fileName != null)
				ConvertFile(fileName);
			else
				ConvertDir(".");
		}
	}
}
