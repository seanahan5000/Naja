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
		private ScreenControl screenControl;
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
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public Form1()
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
			this.screenControl = new ScreenEditor.ScreenControl();
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
			this._openFileDialog = new System.Windows.Forms.OpenFileDialog();
			this._saveFileDialog = new System.Windows.Forms.SaveFileDialog();
			this.SuspendLayout();
			// 
			// screenControl
			// 
			this.screenControl.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
				| System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.screenControl.Location = new System.Drawing.Point(0, 0);
			this.screenControl.Name = "screenControl";
			this.screenControl.Size = new System.Drawing.Size(560, 384);
			this.screenControl.TabIndex = 0;
			// 
			// _mainMenu
			// 
			this._mainMenu.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					  this._fileMenuItem,
																					  this._editMenuItem,
																					  this._viewMenuItem});
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
			this._editMenuCopy.Enabled = false;
			this._editMenuCopy.Index = 4;
			this._editMenuCopy.Shortcut = System.Windows.Forms.Shortcut.CtrlC;
			this._editMenuCopy.Text = "Copy";
			// 
			// _editMenuPaste
			// 
			this._editMenuPaste.Enabled = false;
			this._editMenuPaste.Index = 5;
			this._editMenuPaste.Shortcut = System.Windows.Forms.Shortcut.CtrlV;
			this._editMenuPaste.Text = "Paste";
			// 
			// _editMenuDelete
			// 
			this._editMenuDelete.Index = 6;
			this._editMenuDelete.Shortcut = System.Windows.Forms.Shortcut.Del;
			this._editMenuDelete.Text = "Delete";
			this._editMenuDelete.Click += new System.EventHandler(this._editMenuDelete_Click);
			// 
			// menuItem3
			// 
			this.menuItem3.Enabled = false;
			this.menuItem3.Index = 7;
			this.menuItem3.Text = "-";
			// 
			// _editMenuSelectAll
			// 
			this._editMenuSelectAll.Enabled = false;
			this._editMenuSelectAll.Index = 8;
			this._editMenuSelectAll.Shortcut = System.Windows.Forms.Shortcut.CtrlA;
			this._editMenuSelectAll.Text = "Select All";
			// 
			// menuItem4
			// 
			this.menuItem4.Enabled = false;
			this.menuItem4.Index = 9;
			this.menuItem4.Text = "-";
			// 
			// _editMenuReverse
			// 
			this._editMenuReverse.Index = 10;
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
			// 
			// _viewMenuScale2x
			// 
			this._viewMenuScale2x.Index = 1;
			this._viewMenuScale2x.Shortcut = System.Windows.Forms.Shortcut.Ctrl2;
			this._viewMenuScale2x.Text = "Scale 2x";
			// 
			// _viewMenuScale4x
			// 
			this._viewMenuScale4x.Index = 2;
			this._viewMenuScale4x.Shortcut = System.Windows.Forms.Shortcut.Ctrl4;
			this._viewMenuScale4x.Text = "Scale 4x";
			// 
			// _viewMenuScale8x
			// 
			this._viewMenuScale8x.Index = 3;
			this._viewMenuScale8x.Shortcut = System.Windows.Forms.Shortcut.Ctrl8;
			this._viewMenuScale8x.Text = "Scale 8x";
			// 
			// Form1
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(6, 15);
			this.ClientSize = new System.Drawing.Size(560, 384);
			this.Controls.Add(this.screenControl);
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
					screenControl.Screen.Load(stream);
					screenControl.Invalidate();
					stream.Close();
				}
			}
		}

		private void _editMenuDelete_Click(object sender, System.EventArgs e)
		{
			screenControl.Screen.Clear();
			screenControl.Invalidate();
		}

		private void _editMenuReverse_Click(object sender, System.EventArgs e)
		{
			screenControl.Screen.Reverse();
			screenControl.Invalidate();
		}

		private void _fileMenuExit_Click(object sender, System.EventArgs e)
		{
			this.Close();
		}
	}
}
