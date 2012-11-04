using System;
using System.Collections;
using System.ComponentModel;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Data;
using System.Windows.Forms;

namespace ScreenEditor
{
	public class ScreenControl : System.Windows.Forms.Control
	{
		private System.ComponentModel.Container components = null;
		
		private Screen _screen;
		private Point _corner = new Point(0,0);	// in 280x192 coords
		private int _scale = 2;
		
		public Screen Screen
		{
			get { return _screen; }
		}
		
		public new int Scale
		{
			// public scale of 1,2,4,8 maps to 2,4,8,16
			get { return _scale / 2; }
			set 
			{
				_scale = value * 2;
				_corner.X = 0;
				_corner.Y = 0;
				this.Invalidate();
			}
		}
		
		public void Zoom(char key,Point at)
		{
			int newScale;
			if (key == '1')
				newScale = 2;
			else if (key == '2')
				newScale = 4;
			else if (key == '3')
				newScale = 8;
			else if (key == '4')
				newScale = 16;
			else
				return;
			
			int x = at.X / _scale + _corner.X;
			int y = at.Y / _scale + _corner.Y;
			
			_scale = newScale;
			int w = (this.Width + _scale - 1) / _scale;
			int h = (this.Height + _scale - 1) / _scale;
			
			x -= w / 2;
			y -= h / 2;
			
			if (x + w > 280)
				x = 280 - w;
			if (x < 0)
				x = 0;
			
			if (y + h > 192)
				y = 192 - h;
			if (y < 0)
				y = 0;
			
			_corner.X = x;
			_corner.Y = y;
			this.Invalidate();
		}
		
		public ScreenControl()
		{
			// This call is required by the Windows.Forms Form Designer.
			InitializeComponent();
			
			_screen = new Screen();
		}

		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if( components != null )
					components.Dispose();
			}
			base.Dispose( disposing );
		}

		#region Component Designer generated code
		private void InitializeComponent()
		{
			components = new System.ComponentModel.Container();
		}
		#endregion

		protected override void OnPaint(PaintEventArgs pe)
		{
			Graphics g = pe.Graphics;
			g.InterpolationMode = InterpolationMode.NearestNeighbor;
			
			Rectangle dr = new Rectangle(0,0,280 * _scale,192 * _scale);
			g.DrawImage(_screen.Bitmap,dr,
						_corner.X,_corner.Y,280,192,
						GraphicsUnit.Pixel);
		}
	}
}
