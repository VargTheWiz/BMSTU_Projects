using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace KursovayaRyabSolAbr
{
    public partial class Reconnect : Form
    {
        public Reconnect()
        {
            InitializeComponent();
        }

        private void back_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void Reconnect_Load(object sender, EventArgs e)
        {

        }
    }
}
