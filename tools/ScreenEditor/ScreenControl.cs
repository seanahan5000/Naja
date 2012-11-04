
using System;
using System.Collections;
using System.ComponentModel;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Data;
using System.Windows.Forms;

namespace ScreenEditor
{
	public enum ToolMode
	{
		Selection,
		PencilGreen,
		PencilOrange,
	}
	
	public class ScreenControl : System.Windows.Forms.Control
	{
		private System.ComponentModel.Container components = null;
		
		private Screen _screen;
		private Point _corner = new Point(0,0);	// in 280x192 coords
		private int _scale = 2;
		private Rectangle _selRect = Rectangle.Empty;
		private HatchBrush _selBrush = new HatchBrush(
											HatchStyle.LargeCheckerBoard,
											Color.Black,
											Color.White);
		private ToolMode _toolMode = ToolMode.Selection;
		private Cursor _pencilCursor = new Cursor(typeof(ScreenControl),"pencil.cur");
		private bool _selDragging = false;
		private Point _selStart;
		private bool _setPixel;
		
		public Screen Screen
		{
			get { return _screen; }
		}
		
		public Rectangle Selection
		{
			get { return _selRect; }
		}
		
		public ToolMode ToolMode
		{
			get { return _toolMode; }
			set
			{
				_toolMode = value;
				if (_toolMode == ToolMode.Selection)
					Cursor = Cursors.Cross;
				else
					Cursor = _pencilCursor;
			}
		}
		
		public void SetSelection(Point p1,Point p2)
		{
			int x1 = p1.X;
			int y1 = p1.Y;
			int x2 = p2.X;
			int y2 = p2.Y;
			
			if (x1 > x2)
			{
				int t = x1;
				x1 = x2;
				x2 = t;
			}
			x2 += 1;
			if (x1 < 0)
				x1 = 0;
			if (x2 > 280)
				x2 = 280;
			
			if (y1 > y2)
			{
				int t = y1;
				y1 = y2;
				y2 = t;
			}
			y2 += 1;
			if (y1 < 0)
				y1 = 0;
			if (y2 > 192)
				y2 = 192;
			
			Rectangle oldSel = _selRect;
			_selRect = Rectangle.Empty;
			
			if (x1 + 1 != x2 || y1 + 1 != y2)
			{
				x1 -= (x1 % 7);
				x2 -= (x2 % 7);
				_selRect.X = x1;
				_selRect.Y = y1;
				_selRect.Width = x2 - x1;
				_selRect.Height = y2 - y1;
			}
			
			if (_selRect != oldSel)
				this.Invalidate();
		}
		
		public Point PointToScreen(int x,int y)
		{
			return new Point(x / _scale + _corner.X,
							 y / _scale + _corner.Y);
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
			
			if (x + w >= 280)
				x = 280 - w;
			if (x < 0)
				x = 0;
			
			if (y + h >= 192)
				y = 192 - h;
			if (y < 0)
				y = 0;
			
			_corner.X = x;
			_corner.Y = y;
			_screen.Interpolate = (_scale == 2);
			this.Invalidate();
		}
		
		public bool Paste(string text)
		{
			Rectangle bounds;
			if (Codec.TextToScreen(text,_screen,out bounds))
			{
				_selRect = bounds;
				this.Invalidate();
				return true;
			}
			return false;
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
			g.PixelOffsetMode = PixelOffsetMode.Half;
			
			Rectangle dr = new Rectangle(0,0,280 * _scale,192 * _scale);
			g.DrawImage(_screen.Bitmap,dr,
						_corner.X,
						_corner.Y,
						280,192,
						GraphicsUnit.Pixel);
			
			DrawSelection(g);
		}
		
		protected override void OnMouseDown(MouseEventArgs e)
		{
			_selDragging = true;
			_selStart = PointToScreen(e.X,e.Y);
			
			if (_toolMode == ToolMode.PencilGreen ||
				_toolMode == ToolMode.PencilOrange)
			{
				_setPixel = (e.Button == MouseButtons.Left);
				_screen.SetPixel(_selStart,_setPixel,_toolMode == ToolMode.PencilOrange);
				Invalidate();
			}
			
			base.OnMouseDown(e);
		}
		
		protected override void OnMouseMove(MouseEventArgs e)
		{
			Point p = PointToScreen(e.X,e.Y);
			if (_toolMode == ToolMode.Selection)
			{
				if (_selDragging)
					SetSelection(_selStart,p);
			}
			else if (_toolMode == ToolMode.PencilGreen ||
					 _toolMode == ToolMode.PencilOrange)
			{
				if (_selDragging && p != _selStart)
				{
					_selStart = p;
					_screen.SetPixel(p,_setPixel,_toolMode == ToolMode.PencilOrange);
					Invalidate();
				}
			}
			
			base.OnMouseMove(e);
		}
		
		protected override void OnMouseUp(MouseEventArgs e)
		{
			if (_toolMode == ToolMode.Selection)
				SetSelection(_selStart,PointToScreen(e.X,e.Y));
			
			_selDragging = false;
			base.OnMouseUp(e);
		}
		
		private void DrawSelection(Graphics g)
		{
			if (!_selRect.IsEmpty)
			{
				int x1 = (_selRect.Left - _corner.X) * _scale + 1;
				int y1 = (_selRect.Top - _corner.Y) * _scale + 1;
				int x2 = (_selRect.Right - _corner.X) * _scale;
				int y2 = (_selRect.Bottom - _corner.Y) * _scale;
				
				Pen selPen = new Pen(_selBrush,1);
				g.DrawRectangle(selPen,x1,y1,x2 - x1,y2 - y1);
			}
		}
	}
}

