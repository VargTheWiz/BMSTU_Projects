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
    public partial class AppReceive : Form
    {
        public AppReceive()
        {
            InitializeComponent();
        }

        private void AppReceive_Load(object sender, EventArgs e)
        {
            initialize_refresher();
        }

        private void print_message()
        {
            receive_message.Items.Add(User.friend_name + ": " + Message.current_message);
            Message.on_printing = false;
        }

        private void initialize_refresher()
        {
            // Call this procedure when the application starts.
            // Set to 1 second.
            timer1.Interval = 50;
            timer1.Tick += new EventHandler(timer1_Tick_1);
            timer1.Enabled = true;
            timer1.Start();
        }

        private void timer1_Tick_1(object sender, EventArgs e)
        {
            if (Message.is_new_kadr)
                Message.reading_kadr(Message.message);
            Message.is_new_kadr = false;
            if (Message.on_printing) print_message();
        }

        private void AppReceive_FormClosing(object sender, FormClosingEventArgs e)
        {
            Application.Exit();
        }


        private void label1_Click(object sender, EventArgs e)
        {

        }


    }
}
