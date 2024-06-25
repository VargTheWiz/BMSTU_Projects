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
    public partial class JoinTo : Form
    {
        public JoinTo()
        {
            InitializeComponent();
        }

        public void data_setup()
        {
            //Перекидывание данных последовательного порта в общий доступ.
            Port.port_name = this.comboBox1.Text;
            //Данные пользователя в общий доступ.
            User.this_name = this.textBox1.Text;
            User.is_client = true;
        }

        private void JoinTo_Load(object sender, EventArgs e)
        {

        }

        private void JoinTo_FormClosing(object sender, FormClosingEventArgs e)
        {
            Form Main = Application.OpenForms[0];
            Main.Show();
        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click_1(object sender, EventArgs e)
        {
            User.is_client = true;
            data_setup();
            this.Hide();
            Form chatRoom = new AppSend();
            chatRoom.Owner = this;
            chatRoom.Show();
        }

        private void back_Click_1(object sender, EventArgs e)
        {
            this.Close();
            Form Main = Application.OpenForms[0];
            Main.Show();
        }
    }
}
