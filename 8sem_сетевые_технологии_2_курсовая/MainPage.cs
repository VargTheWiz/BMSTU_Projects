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
    public partial class MainPage : Form
    {
        public MainPage()
        {
            InitializeComponent();
        }

        private void Main_Load(object sender, EventArgs e)
        {

        }

        private void about_Click(object sender, EventArgs e)
        {
            Form About = new About();
            About.Show();
            this.Hide();
        }

        private void create_con_Click(object sender, EventArgs e)
        {
            Form CreateCon = new AppCreateLink();
            CreateCon.Show();
            this.Hide();
        }

        private void join_chat_Click(object sender, EventArgs e)
        {
            Form JoinChat = new JoinTo();
            JoinChat.Show();
            this.Hide();
        }

        private void exit_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }
    }
}
