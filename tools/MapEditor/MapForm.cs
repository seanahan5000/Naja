using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace MapEditor
{
	/// <summary>
	/// Summary description for MapEditor.
	/// </summary>
	public class MapForm : System.Windows.Forms.Form
	{
		private MapEditor.MapControl _mapControl;
		private System.Windows.Forms.MainMenu _mainMenu;
		private System.Windows.Forms.MenuItem _fileMenuItem;
		private System.Windows.Forms.MenuItem _editMenuItem;
		private System.Windows.Forms.MenuItem _fileMenuExit;
		private System.Windows.Forms.MenuItem _editMenuUndo;
		private System.Windows.Forms.MenuItem menuItem1;
		private System.Windows.Forms.MenuItem _editMenuCut;
		private System.Windows.Forms.MenuItem _editMenuCopy;
		private System.Windows.Forms.MenuItem _editMenuPaste;
		private System.Windows.Forms.MenuItem _toolMenuItem;
		private System.Windows.Forms.MenuItem _emptyMenuItem;
		private System.Windows.Forms.MenuItem _wallMenuItem;
		private System.Windows.Forms.MenuItem _doorMenuItem;
		private System.Windows.Forms.MenuItem _transitionMenuItem;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public MapForm()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			//
			// TODO: Add any constructor code after InitializeComponent call
			//
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if(components != null)
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this._mapControl = new MapEditor.MapControl();
			this._mainMenu = new System.Windows.Forms.MainMenu();
			this._fileMenuItem = new System.Windows.Forms.MenuItem();
			this._fileMenuExit = new System.Windows.Forms.MenuItem();
			this._editMenuItem = new System.Windows.Forms.MenuItem();
			this._editMenuUndo = new System.Windows.Forms.MenuItem();
			this.menuItem1 = new System.Windows.Forms.MenuItem();
			this._editMenuCut = new System.Windows.Forms.MenuItem();
			this._editMenuCopy = new System.Windows.Forms.MenuItem();
			this._editMenuPaste = new System.Windows.Forms.MenuItem();
			this._toolMenuItem = new System.Windows.Forms.MenuItem();
			this._emptyMenuItem = new System.Windows.Forms.MenuItem();
			this._wallMenuItem = new System.Windows.Forms.MenuItem();
			this._doorMenuItem = new System.Windows.Forms.MenuItem();
			this._transitionMenuItem = new System.Windows.Forms.MenuItem();
			this.SuspendLayout();
			// 
			// _mapControl
			// 
			this._mapControl.Dock = System.Windows.Forms.DockStyle.Fill;
			this._mapControl.Location = new System.Drawing.Point(0, 0);
			this._mapControl.Name = "_mapControl";
			this._mapControl.SegmentType = MapEditor.Map.SegmentType.Wall;
			this._mapControl.Size = new System.Drawing.Size(440, 437);
			this._mapControl.TabIndex = 0;
			this._mapControl.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this._mapControl_KeyPress);
			// 
			// _mainMenu
			// 
			this._mainMenu.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					  this._fileMenuItem,
																					  this._editMenuItem,
																					  this._toolMenuItem});
			// 
			// _fileMenuItem
			// 
			this._fileMenuItem.Index = 0;
			this._fileMenuItem.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																						  this._fileMenuExit});
			this._fileMenuItem.Text = "&File";
			// 
			// _fileMenuExit
			// 
			this._fileMenuExit.Index = 0;
			this._fileMenuExit.Text = "Exit";
			// 
			// _editMenuItem
			// 
			this._editMenuItem.Index = 1;
			this._editMenuItem.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																						  this._editMenuUndo,
																						  this.menuItem1,
																						  this._editMenuCut,
																						  this._editMenuCopy,
																						  this._editMenuPaste});
			this._editMenuItem.Text = "&Edit";
			// 
			// _editMenuUndo
			// 
			this._editMenuUndo.Enabled = false;
			this._editMenuUndo.Index = 0;
			this._editMenuUndo.Shortcut = System.Windows.Forms.Shortcut.CtrlZ;
			this._editMenuUndo.Text = "Undo";
			// 
			// menuItem1
			// 
			this.menuItem1.Index = 1;
			this.menuItem1.Text = "-";
			// 
			// _editMenuCut
			// 
			this._editMenuCut.Enabled = false;
			this._editMenuCut.Index = 2;
			this._editMenuCut.Shortcut = System.Windows.Forms.Shortcut.CtrlX;
			this._editMenuCut.Text = "Cut";
			// 
			// _editMenuCopy
			// 
			this._editMenuCopy.Index = 3;
			this._editMenuCopy.Shortcut = System.Windows.Forms.Shortcut.CtrlC;
			this._editMenuCopy.Text = "Copy";
			this._editMenuCopy.Click += new System.EventHandler(this._editMenuCopy_Click);
			// 
			// _editMenuPaste
			// 
			this._editMenuPaste.Index = 4;
			this._editMenuPaste.Shortcut = System.Windows.Forms.Shortcut.CtrlV;
			this._editMenuPaste.Text = "Paste";
			this._editMenuPaste.Click += new System.EventHandler(this._editMenuPaste_Click);
			// 
			// _toolMenuItem
			// 
			this._toolMenuItem.Index = 2;
			this._toolMenuItem.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																						  this._wallMenuItem,
																						  this._doorMenuItem,
																						  this._transitionMenuItem,
																						  this._emptyMenuItem});
			this._toolMenuItem.Text = "Tool";
			// 
			// _emptyMenuItem
			// 
			this._emptyMenuItem.Index = 3;
			this._emptyMenuItem.Shortcut = System.Windows.Forms.Shortcut.CtrlE;
			this._emptyMenuItem.Text = "Empty";
			this._emptyMenuItem.Click += new System.EventHandler(this._emptyMenuItem_Click);
			// 
			// _wallMenuItem
			// 
			this._wallMenuItem.Checked = true;
			this._wallMenuItem.Index = 0;
			this._wallMenuItem.Shortcut = System.Windows.Forms.Shortcut.CtrlW;
			this._wallMenuItem.Text = "Wall";
			this._wallMenuItem.Click += new System.EventHandler(this._wallMenuItem_Click);
			// 
			// _doorMenuItem
			// 
			this._doorMenuItem.Index = 1;
			this._doorMenuItem.Shortcut = System.Windows.Forms.Shortcut.CtrlD;
			this._doorMenuItem.Text = "Door";
			this._doorMenuItem.Click += new System.EventHandler(this._doorMenuItem_Click);
			// 
			// _transitionMenuItem
			// 
			this._transitionMenuItem.Index = 2;
			this._transitionMenuItem.Shortcut = System.Windows.Forms.Shortcut.CtrlT;
			this._transitionMenuItem.Text = "Transition";
			this._transitionMenuItem.Click += new System.EventHandler(this._transitionMenuItem_Click);
			// 
			// MapForm
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(6, 15);
			this.ClientSize = new System.Drawing.Size(440, 437);
			this.Controls.Add(this._mapControl);
			this.Menu = this._mainMenu;
			this.Name = "MapForm";
			this.Text = "MapEditor";
			this.ResumeLayout(false);

		}
		#endregion
		
		[STAThread]
		static void Main() 
		{
			Application.Run(new MapForm());
		}

		private void _editMenuCopy_Click(object sender, System.EventArgs e)
		{
			string text = _mapControl.Copy();
			Clipboard.SetDataObject(text);
		}

		private void _editMenuPaste_Click(object sender, System.EventArgs e)
		{
			IDataObject data = Clipboard.GetDataObject();
			if (data.GetDataPresent(DataFormats.Text))
			{
				string text = data.GetData(DataFormats.Text).ToString();
				_mapControl.Paste(text);
			}
		}

		private void CheckToolMenu()
		{
			Map.SegmentType segType = _mapControl.SegmentType;
			_emptyMenuItem.Checked = (segType == Map.SegmentType.Empty);
			_wallMenuItem.Checked = (segType == Map.SegmentType.Wall);
			_doorMenuItem.Checked = (segType == Map.SegmentType.Door);
			_transitionMenuItem.Checked = (segType == Map.SegmentType.Transition);
		}

		private void _emptyMenuItem_Click(object sender, System.EventArgs e)
		{
			_mapControl.SegmentType = Map.SegmentType.Empty;
			CheckToolMenu();
		}

		private void _wallMenuItem_Click(object sender, System.EventArgs e)
		{
			_mapControl.SegmentType = Map.SegmentType.Wall;
			CheckToolMenu();
		}

		private void _doorMenuItem_Click(object sender, System.EventArgs e)
		{
			_mapControl.SegmentType = Map.SegmentType.Door;
			CheckToolMenu();
		}

		private void _transitionMenuItem_Click(object sender, System.EventArgs e)
		{
			_mapControl.SegmentType = Map.SegmentType.Transition;
			CheckToolMenu();
		}

		private void _mapControl_KeyPress(object sender, System.Windows.Forms.KeyPressEventArgs e)
		{
			switch (char.ToLower(e.KeyChar))
			{
				case 'w':
					_mapControl.SegmentType = Map.SegmentType.Wall;
					break;
				case 'd':
					_mapControl.SegmentType = Map.SegmentType.Door;
					break;
				case 'e':
					_mapControl.SegmentType = Map.SegmentType.Empty;
					break;
				case 't':
					_mapControl.SegmentType = Map.SegmentType.Transition;
					break;
				default:
					return;
			}
			CheckToolMenu();
		}
	}
}
