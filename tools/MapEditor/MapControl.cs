using System;
using System.Collections;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Windows.Forms;

namespace MapEditor
{
	/// <summary>
	/// Summary description for MapControl.
	/// </summary>
	public class MapControl : System.Windows.Forms.Control
	{
		private Map _map;
		private Map.SegmentType _segmentType = Map.SegmentType.Wall;
		private Point _margin = new Point(16,16);	// in screen pixels
		private Point _corner = new Point(0,0);		// in map cells
		private int _scale = 24;
		private bool _selDragging = false;
		private Point _selStart;
		
		public Map.SegmentType SegmentType
		{
			get { return _segmentType; }
			set { _segmentType = value; }
		}
		
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public MapControl()
		{
			// This call is required by the Windows.Forms Form Designer.
			InitializeComponent();

			_map = new Map();
			// TODO: Add any initialization after the InitComponent call
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
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
		/// <summary>
		/// Required method for Designer support - do not modify 
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			components = new System.ComponentModel.Container();
		}
		#endregion

		protected override void OnPaint(PaintEventArgs pe)
		{
			base.OnPaint(pe);
			
			Graphics g = pe.Graphics;
			Pen pen = new Pen(Brushes.Black,2);
			
			for (int yi = 0; yi < _map.Height + 1; ++yi)
			{
				Map.SegmentType lastSeg = Map.SegmentType.Wall;
				for (int xi = 0; xi < _map.Width + 1; ++xi)
				{
					Map.SegmentType seg;
					
					int x1 = _margin.X + xi * _scale;
					int x2 = _margin.X + (xi + 1) * _scale;
					int y1 = _margin.Y + yi * _scale;
					int y2 = _margin.Y + (yi + 1) * _scale;
					
					if (xi < _map.Width)
					{
						seg = _map.GetSegment(xi,yi,Map.Direction.North);
						switch (seg)
						{
							case Map.SegmentType.Empty:
								if (seg == lastSeg)
								{
									g.DrawLine(pen,x1 - 2,y1,x1 + 2,y1);
									g.DrawLine(pen,x1,y1 - 2,x1,y1 + 2);
								}
								break;
							case Map.SegmentType.Door:
								g.DrawLine(pen,x1 - 2,y1,x1 + _scale / 4,y1);
								g.DrawRectangle(pen,x1 + _scale / 4,y1 - 2,_scale / 2,4);
								g.DrawLine(pen,x2 - _scale / 4,y1,x2 + 2,y1);
								break;
							case Map.SegmentType.Transition:
								g.DrawLine(pen,x1 + _scale / 2,y1 - 3,x1 + _scale / 2,y1 + 3);
								break;
							case Map.SegmentType.Wall:
								g.DrawLine(pen,x1 - 2,y1,x2 + 2,y1);
								g.DrawLine(pen,x1,y1 - 2,x1,y1 + 2);
								break;
						}
						lastSeg = seg;
					}

					if (yi < _map.Height)
					{
						seg = _map.GetSegment(xi,yi,Map.Direction.West);
						switch (seg)
						{
							case Map.SegmentType.Empty:
								break;
							case Map.SegmentType.Door:
								g.DrawLine(pen,x1,y1 - 2,x1,y1 + _scale / 4);
								g.DrawRectangle(pen,x1 - 2,y1 + _scale / 4,4,_scale / 2);
								g.DrawLine(pen,x1,y2 - _scale / 4,x1,y2 + 2);
								break;
							case Map.SegmentType.Transition:
								g.DrawLine(pen,x1 - 3,y1 + _scale / 2,x1 + 3,y1 + _scale / 2);
								break;
							case Map.SegmentType.Wall:
								g.DrawLine(pen,x1,y1 - 2,x1,y2 + 2);
								break;
						}
					}
				}
			}
		}
		
		protected override void OnMouseDown(MouseEventArgs e)
		{
			_selDragging = true;
			_selStart = PointToMap(e.X,e.Y);
			
			base.OnMouseDown(e);
		}
		
		protected override void OnMouseMove(MouseEventArgs e)
		{
			Point p = PointToMap(e.X,e.Y);
			
			if (_selDragging && p != _selStart)
			{
				int x = (_selStart.X < p.X ? _selStart.X : p.X);
				int y = (_selStart.Y < p.Y ? _selStart.Y : p.Y);
				if (_selStart.X != p.X)
					_map.SetSegment(x,y,Map.Direction.North,_segmentType);
				else
					_map.SetSegment(x,y,Map.Direction.West,_segmentType);
				_selStart = p;
				Invalidate();
			}
			
			base.OnMouseMove(e);
		}
		
		protected override void OnMouseUp(MouseEventArgs e)
		{
			_selDragging = false;
			base.OnMouseUp(e);
		}
		
		private Point PointToMap(int x,int y)
		{
			return new Point((x - _margin.X + _scale / 2) / _scale + _corner.X,
							 (y - _margin.Y + _scale / 2) / _scale + _corner.Y);
		}
		
		public string Copy()
		{
			return _map.MapToText();
		}

		public void Paste(string text)
		{
			_map.TextToMap(text);
			this.Invalidate();
		}
	}
}
