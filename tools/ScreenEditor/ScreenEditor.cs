using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.IO;

namespace ScreenEditor
{
	/// <summary>
	/// Summary description for Form1.
	/// </summary>
	public class Form1 : System.Windows.Forms.Form
	{
		private System.Windows.Forms.MainMenu _mainMenu;
		private System.Windows.Forms.MenuItem _fileMenuItem;
		private System.Windows.Forms.MenuItem _editMenuItem;
		private System.Windows.Forms.MenuItem _fileMenuOpen;
		private System.Windows.Forms.MenuItem _fileMenuExit;
		private System.Windows.Forms.MenuItem menuItem1;
		private System.Windows.Forms.MenuItem _editMenuUndo;
		private System.Windows.Forms.MenuItem _editMenuRedo;
		private System.Windows.Forms.MenuItem menuItem2;
		private System.Windows.Forms.MenuItem _editMenuCut;
		private System.Windows.Forms.MenuItem _editMenuCopy;
		private System.Windows.Forms.MenuItem _editMenuPaste;
		private System.Windows.Forms.MenuItem _editMenuDelete;
		private System.Windows.Forms.MenuItem menuItem3;
		private System.Windows.Forms.MenuItem _editMenuSelectAll;
		private System.Windows.Forms.MenuItem menuItem4;
		private System.Windows.Forms.MenuItem _editMenuReverse;
		private System.Windows.Forms.MenuItem _fileMenuSave;
		private System.Windows.Forms.MenuItem menuItem5;
		private System.Windows.Forms.MenuItem _fileMenuSaveAs;
		private System.Windows.Forms.OpenFileDialog _openFileDialog;
		private System.Windows.Forms.SaveFileDialog _saveFileDialog;
		private System.Windows.Forms.MenuItem _viewMenuItem;
		private System.Windows.Forms.MenuItem _viewMenuScale1x;
		private System.Windows.Forms.MenuItem _viewMenuScale2x;
		private System.Windows.Forms.MenuItem _viewMenuScale4x;
		private System.Windows.Forms.MenuItem _viewMenuScale8x;
		private System.Windows.Forms.StatusBar _statusBar;
		private ScreenEditor.ScreenControl _screenControl;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		private System.Windows.Forms.MenuItem _editMenuCompress;
		private System.Windows.Forms.MenuItem _toolMenuItem;
		private System.Windows.Forms.MenuItem _toolMenuPencilOrange;
		private System.Windows.Forms.MenuItem _toolMenuSelection;
		private System.Windows.Forms.MenuItem _toolMenuPencilGreen;
		
		public Form1()
		{
			// Required for Windows Form Designer support
			InitializeComponent();
		}

		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if (components != null) 
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
			this._screenControl = new ScreenEditor.ScreenControl();
			this._mainMenu = new System.Windows.Forms.MainMenu();
			this._fileMenuItem = new System.Windows.Forms.MenuItem();
			this._fileMenuOpen = new System.Windows.Forms.MenuItem();
			this.menuItem5 = new System.Windows.Forms.MenuItem();
			this._fileMenuSave = new System.Windows.Forms.MenuItem();
			this._fileMenuSaveAs = new System.Windows.Forms.MenuItem();
			this.menuItem1 = new System.Windows.Forms.MenuItem();
			this._fileMenuExit = new System.Windows.Forms.MenuItem();
			this._editMenuItem = new System.Windows.Forms.MenuItem();
			this._editMenuUndo = new System.Windows.Forms.MenuItem();
			this._editMenuRedo = new System.Windows.Forms.MenuItem();
			this.menuItem2 = new System.Windows.Forms.MenuItem();
			this._editMenuCut = new System.Windows.Forms.MenuItem();
			this._editMenuCopy = new System.Windows.Forms.MenuItem();
			this._editMenuCompress = new System.Windows.Forms.MenuItem();
			this._editMenuPaste = new System.Windows.Forms.MenuItem();
			this._editMenuDelete = new System.Windows.Forms.MenuItem();
			this.menuItem3 = new System.Windows.Forms.MenuItem();
			this._editMenuSelectAll = new System.Windows.Forms.MenuItem();
			this.menuItem4 = new System.Windows.Forms.MenuItem();
			this._editMenuReverse = new System.Windows.Forms.MenuItem();
			this._viewMenuItem = new System.Windows.Forms.MenuItem();
			this._viewMenuScale1x = new System.Windows.Forms.MenuItem();
			this._viewMenuScale2x = new System.Windows.Forms.MenuItem();
			this._viewMenuScale4x = new System.Windows.Forms.MenuItem();
			this._viewMenuScale8x = new System.Windows.Forms.MenuItem();
			this._toolMenuItem = new System.Windows.Forms.MenuItem();
			this._toolMenuSelection = new System.Windows.Forms.MenuItem();
			this._toolMenuPencilGreen = new System.Windows.Forms.MenuItem();
			this._toolMenuPencilOrange = new System.Windows.Forms.MenuItem();
			this._openFileDialog = new System.Windows.Forms.OpenFileDialog();
			this._saveFileDialog = new System.Windows.Forms.SaveFileDialog();
			this._statusBar = new System.Windows.Forms.StatusBar();
			this.SuspendLayout();
			// 
			// _screenControl
			// 
			this._screenControl.Dock = System.Windows.Forms.DockStyle.Fill;
			this._screenControl.Location = new System.Drawing.Point(0, 0);
			this._screenControl.Name = "_screenControl";
			this._screenControl.Size = new System.Drawing.Size(560, 384);
			this._screenControl.TabIndex = 0;
			this._screenControl.ToolMode = ScreenEditor.ToolMode.Selection;
			this._screenControl.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this._screenControl_KeyPress);
			this._screenControl.MouseMove += new System.Windows.Forms.MouseEventHandler(this._screenControl_MouseMove);
			// 
			// _mainMenu
			// 
			this._mainMenu.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					  this._fileMenuItem,
																					  this._editMenuItem,
																					  this._viewMenuItem,
																					  this._toolMenuItem});
			// 
			// _fileMenuItem
			// 
			this._fileMenuItem.Index = 0;
			this._fileMenuItem.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																						  this._fileMenuOpen,
																						  this.menuItem5,
																						  this._fileMenuSave,
																						  this._fileMenuSaveAs,
																						  this.menuItem1,
																						  this._fileMenuExit});
			this._fileMenuItem.Text = "&File";
			// 
			// _fileMenuOpen
			// 
			this._fileMenuOpen.Index = 0;
			this._fileMenuOpen.Shortcut = System.Windows.Forms.Shortcut.CtrlO;
			this._fileMenuOpen.Text = "Open...";
			this._fileMenuOpen.Click += new System.EventHandler(this._fileMenuOpen_Click);
			// 
			// menuItem5
			// 
			this.menuItem5.Enabled = false;
			this.menuItem5.Index = 1;
			this.menuItem5.Text = "-";
			// 
			// _fileMenuSave
			// 
			this._fileMenuSave.Enabled = false;
			this._fileMenuSave.Index = 2;
			this._fileMenuSave.Shortcut = System.Windows.Forms.Shortcut.CtrlS;
			this._fileMenuSave.Text = "Save...";
			// 
			// _fileMenuSaveAs
			// 
			this._fileMenuSaveAs.Enabled = false;
			this._fileMenuSaveAs.Index = 3;
			this._fileMenuSaveAs.Text = "Save As...";
			// 
			// menuItem1
			// 
			this.menuItem1.Enabled = false;
			this.menuItem1.Index = 4;
			this.menuItem1.Text = "-";
			// 
			// _fileMenuExit
			// 
			this._fileMenuExit.Index = 5;
			this._fileMenuExit.Text = "Exit";
			this._fileMenuExit.Click += new System.EventHandler(this._fileMenuExit_Click);
			// 
			// _editMenuItem
			// 
			this._editMenuItem.Index = 1;
			this._editMenuItem.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																						  this._editMenuUndo,
																						  this._editMenuRedo,
																						  this.menuItem2,
																						  this._editMenuCut,
																						  this._editMenuCopy,
																						  this._editMenuCompress,
																						  this._editMenuPaste,
																						  this._editMenuDelete,
																						  this.menuItem3,
																						  this._editMenuSelectAll,
																						  this.menuItem4,
																						  this._editMenuReverse});
			this._editMenuItem.Text = "&Edit";
			// 
			// _editMenuUndo
			// 
			this._editMenuUndo.Enabled = false;
			this._editMenuUndo.Index = 0;
			this._editMenuUndo.Shortcut = System.Windows.Forms.Shortcut.CtrlZ;
			this._editMenuUndo.Text = "Undo";
			// 
			// _editMenuRedo
			// 
			this._editMenuRedo.Enabled = false;
			this._editMenuRedo.Index = 1;
			this._editMenuRedo.Shortcut = System.Windows.Forms.Shortcut.CtrlY;
			this._editMenuRedo.Text = "Redo";
			// 
			// menuItem2
			// 
			this.menuItem2.Enabled = false;
			this.menuItem2.Index = 2;
			this.menuItem2.Text = "-";
			// 
			// _editMenuCut
			// 
			this._editMenuCut.Enabled = false;
			this._editMenuCut.Index = 3;
			this._editMenuCut.Shortcut = System.Windows.Forms.Shortcut.CtrlX;
			this._editMenuCut.Text = "Cut";
			// 
			// _editMenuCopy
			// 
			this._editMenuCopy.Index = 4;
			this._editMenuCopy.Shortcut = System.Windows.Forms.Shortcut.CtrlC;
			this._editMenuCopy.Text = "Copy";
			this._editMenuCopy.Click += new System.EventHandler(this._editMenuCopy_Click);
			// 
			// _editMenuCompress
			// 
			this._editMenuCompress.Index = 5;
			this._editMenuCompress.Shortcut = System.Windows.Forms.Shortcut.CtrlShiftC;
			this._editMenuCompress.Text = "Compress";
			this._editMenuCompress.Click += new System.EventHandler(this._editMenuCompress_Click);
			// 
			// _editMenuPaste
			// 
			this._editMenuPaste.Index = 6;
			this._editMenuPaste.Shortcut = System.Windows.Forms.Shortcut.CtrlV;
			this._editMenuPaste.Text = "Paste";
			this._editMenuPaste.Click += new System.EventHandler(this._editMenuPaste_Click);
			// 
			// _editMenuDelete
			// 
			this._editMenuDelete.Index = 7;
			this._editMenuDelete.Shortcut = System.Windows.Forms.Shortcut.Del;
			this._editMenuDelete.Text = "Delete";
			this._editMenuDelete.Click += new System.EventHandler(this._editMenuDelete_Click);
			// 
			// menuItem3
			// 
			this.menuItem3.Enabled = false;
			this.menuItem3.Index = 8;
			this.menuItem3.Text = "-";
			// 
			// _editMenuSelectAll
			// 
			this._editMenuSelectAll.Index = 9;
			this._editMenuSelectAll.Shortcut = System.Windows.Forms.Shortcut.CtrlA;
			this._editMenuSelectAll.Text = "Select All";
			this._editMenuSelectAll.Click += new System.EventHandler(this._editMenuSelectAll_Click);
			// 
			// menuItem4
			// 
			this.menuItem4.Enabled = false;
			this.menuItem4.Index = 10;
			this.menuItem4.Text = "-";
			// 
			// _editMenuReverse
			// 
			this._editMenuReverse.Index = 11;
			this._editMenuReverse.Shortcut = System.Windows.Forms.Shortcut.CtrlR;
			this._editMenuReverse.Text = "Reverse";
			this._editMenuReverse.Click += new System.EventHandler(this._editMenuReverse_Click);
			// 
			// _viewMenuItem
			// 
			this._viewMenuItem.Index = 2;
			this._viewMenuItem.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																						  this._viewMenuScale1x,
																						  this._viewMenuScale2x,
																						  this._viewMenuScale4x,
																						  this._viewMenuScale8x});
			this._viewMenuItem.Text = "View";
			// 
			// _viewMenuScale1x
			// 
			this._viewMenuScale1x.Index = 0;
			this._viewMenuScale1x.Shortcut = System.Windows.Forms.Shortcut.Ctrl1;
			this._viewMenuScale1x.Text = "Scale 1x";
			this._viewMenuScale1x.Click += new System.EventHandler(this._viewMenuScale1x_Click);
			// 
			// _viewMenuScale2x
			// 
			this._viewMenuScale2x.Index = 1;
			this._viewMenuScale2x.Shortcut = System.Windows.Forms.Shortcut.Ctrl2;
			this._viewMenuScale2x.Text = "Scale 2x";
			this._viewMenuScale2x.Click += new System.EventHandler(this._viewMenuScale2x_Click);
			// 
			// _viewMenuScale4x
			// 
			this._viewMenuScale4x.Index = 2;
			this._viewMenuScale4x.Shortcut = System.Windows.Forms.Shortcut.Ctrl3;
			this._viewMenuScale4x.Text = "Scale 4x";
			this._viewMenuScale4x.Click += new System.EventHandler(this._viewMenuScale4x_Click);
			// 
			// _viewMenuScale8x
			// 
			this._viewMenuScale8x.Index = 3;
			this._viewMenuScale8x.Shortcut = System.Windows.Forms.Shortcut.Ctrl4;
			this._viewMenuScale8x.Text = "Scale 8x";
			this._viewMenuScale8x.Click += new System.EventHandler(this._viewMenuScale8x_Click);
			// 
			// _toolMenuItem
			// 
			this._toolMenuItem.Index = 3;
			this._toolMenuItem.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																						  this._toolMenuSelection,
																						  this._toolMenuPencilGreen,
																						  this._toolMenuPencilOrange});
			this._toolMenuItem.Text = "Tool";
			// 
			// _toolMenuSelection
			// 
			this._toolMenuSelection.Checked = true;
			this._toolMenuSelection.Index = 0;
			this._toolMenuSelection.Shortcut = System.Windows.Forms.Shortcut.F1;
			this._toolMenuSelection.Text = "Selection";
			this._toolMenuSelection.Click += new System.EventHandler(this._toolMenuSelection_Click);
			// 
			// _toolMenuPencilGreen
			// 
			this._toolMenuPencilGreen.Index = 1;
			this._toolMenuPencilGreen.Shortcut = System.Windows.Forms.Shortcut.F2;
			this._toolMenuPencilGreen.Text = "Pencil - Green";
			this._toolMenuPencilGreen.Click += new System.EventHandler(this._toolMenuPencilGreen_Click);
			// 
			// _toolMenuPencilOrange
			// 
			this._toolMenuPencilOrange.Index = 2;
			this._toolMenuPencilOrange.Shortcut = System.Windows.Forms.Shortcut.F3;
			this._toolMenuPencilOrange.Text = "Pencil - Orange";
			this._toolMenuPencilOrange.Click += new System.EventHandler(this._toolMenuPencilOrange_Click);
			// 
			// _statusBar
			// 
			this._statusBar.Location = new System.Drawing.Point(0, 384);
			this._statusBar.Name = "_statusBar";
			this._statusBar.Size = new System.Drawing.Size(560, 22);
			this._statusBar.TabIndex = 1;
			// 
			// Form1
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(6, 15);
			this.ClientSize = new System.Drawing.Size(560, 406);
			this.Controls.Add(this._screenControl);
			this.Controls.Add(this._statusBar);
			this.Menu = this._mainMenu;
			this.Name = "Form1";
			this.Text = "ScreenEditor";
			this.ResumeLayout(false);

		}
		#endregion

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main() 
		{
			Application.Run(new Form1());
		}

		private void _fileMenuOpen_Click(object sender, System.EventArgs e)
		{
			if (_openFileDialog.ShowDialog() == DialogResult.OK)
			{
				Stream stream = _openFileDialog.OpenFile();
				if (stream != null)
				{
					_screenControl.Screen.Load(stream);
					_screenControl.Invalidate();
					stream.Close();
				}
			}
		}

		private void _fileMenuExit_Click(object sender, System.EventArgs e)
		{
			this.Close();
		}
		
		private void _editMenuCopy_Click(object sender, System.EventArgs e)
		{
			Rectangle bounds = _screenControl.Selection;
			if (!bounds.IsEmpty)
			{
				string text = Codec.CaptureToText(_screenControl.Screen,bounds);
				Clipboard.SetDataObject(text);
			}
		}
		
		private void _editMenuCompress_Click(object sender, System.EventArgs e)
		{
			Rectangle bounds = _screenControl.Selection;
			if (!bounds.IsEmpty)
			{
				string text = Codec.CompressToText(_screenControl.Screen,bounds);
				Clipboard.SetDataObject(text);
			}
		}
		
		private void _editMenuPaste_Click(object sender, System.EventArgs e)
		{
			IDataObject data = Clipboard.GetDataObject();
			if (data.GetDataPresent(DataFormats.Text))
			{
				string text = data.GetData(DataFormats.Text).ToString();
				_screenControl.Paste(text);
			}
		}
		
		private void _editMenuDelete_Click(object sender, System.EventArgs e)
		{
			_screenControl.Screen.Clear();
			_screenControl.Invalidate();
		}
		
		private void _editMenuSelectAll_Click(object sender, System.EventArgs e)
		{
			_screenControl.SetSelection(new Point(0,0),new Point(279,191));
		}
		
		private void _editMenuReverse_Click(object sender, System.EventArgs e)
		{
			_screenControl.Screen.Reverse();
			_screenControl.Invalidate();
		}

		private void Zoom(char key)
		{
			Point point = _screenControl.PointToClient(Control.MousePosition);
			_screenControl.Zoom(key,point);
		}

		private void _viewMenuScale1x_Click(object sender, System.EventArgs e)
		{
			Zoom('1');
		}

		private void _viewMenuScale2x_Click(object sender, System.EventArgs e)
		{
			Zoom('2');
		}

		private void _viewMenuScale4x_Click(object sender, System.EventArgs e)
		{
			Zoom('3');
		}

		private void _viewMenuScale8x_Click(object sender, System.EventArgs e)
		{
			Zoom('4');
		}
		
		private void _toolMenuSelection_Click(object sender, System.EventArgs e)
		{
			_toolMenuSelection.Checked = true;
			_toolMenuPencilGreen.Checked = false;
			_toolMenuPencilOrange.Checked = false;
			_screenControl.ToolMode = ToolMode.Selection;
		}
		
		private void _toolMenuPencilGreen_Click(object sender, System.EventArgs e)
		{
			_toolMenuSelection.Checked = false;
			_toolMenuPencilGreen.Checked = true;
			_toolMenuPencilOrange.Checked = false;
			_screenControl.ToolMode = ToolMode.PencilGreen;
		}
		
		private void _toolMenuPencilOrange_Click(object sender, System.EventArgs e)
		{
			_toolMenuSelection.Checked = false;
			_toolMenuPencilGreen.Checked = false;
			_toolMenuPencilOrange.Checked = true;
			_screenControl.ToolMode = ToolMode.PencilOrange;
		}
		
		private void _screenControl_KeyPress(object sender, System.Windows.Forms.KeyPressEventArgs e)
		{
			Zoom(e.KeyChar);
		}
		
		private void _screenControl_MouseMove(object sender, System.Windows.Forms.MouseEventArgs e)
		{
			Point p = _screenControl.PointToScreen(e.X,e.Y);
			
			if (!_screenControl.Selection.IsEmpty)
			{
				Rectangle r = _screenControl.Selection;
				_statusBar.Text = String.Format(
					"X: {0} ({1}), Y: {2}, W: {3} ({4}), H: {5}",
					r.X, r.X / 7, r.Y,
					r.Width, r.Width / 7, r.Height);
			}
			else
			{
				_statusBar.Text = String.Format("X: {0} ({1}), Y: {2}",
					p.X,p.X / 7,p.Y);
			}
		}
	}
}

