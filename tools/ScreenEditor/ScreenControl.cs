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
		private int _scale = 2;		// 2,4,8,16?
		
		public Screen Screen
		{
			get { return _screen; }
		}
		
		public new int Scale
		{
			get { return _scale; }
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
			g.DrawImage(_screen.Bitmap,dr,0,0,280,192,GraphicsUnit.Pixel);
			
			// Calling the base class OnPaint
//			base.OnPaint(pe);
		}
	}
}
