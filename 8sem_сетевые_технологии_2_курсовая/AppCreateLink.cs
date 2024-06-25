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
    public partial class AppCreateLink : Form
    {

        public string get_COM_name()
        {
            string name = this.comboBox1.Text;
            return name;
        }

        public AppCreateLink()
        {
            InitializeComponent();
        }

        private void back_Click_1(object sender, EventArgs e)
        {
            this.Close();
            Form Main = Application.OpenForms[0];
            Main.Show();
        }

        private void create_connection_Click(object sender, EventArgs e)
        {
            User.is_client = false;
            trasmit_data();
            this.Hide();
            Form chatRoom = new AppSend();
            chatRoom.Owner = this;
            chatRoom.Show();
        }

        //Данные функции кидают все параметры порта в отдельный класс к которому будем обращаться
        public void trasmit_data()
        {
            //Перекидывание данных последовательного порта в общий доступ.
            Port.port_name = this.comboBox1.Text;
            Port.bound_port = this.comboBox2.Text;
            Port.data_bits = this.comboBox3.Text;
            Port.stop_bits = this.comboBox4.Text;

            //Данные пользователя в общий доступ.
            User.this_name = this.textBox1.Text;
            User.is_client = false;

            byte[] speed_num = BitConverter.GetBytes(App.string_to_int_port(Port.bound_port));
            byte bitdata_num = (byte)App.string_to_int_port(Port.data_bits);
            byte stopbit_num = (byte)App.string_to_int_port(Port.stop_bits);

            //имя пользователя в байты
            PortArgs.name = App.string_to_byte(User.this_name);

            PortArgs.param[0] = speed_num[1];
            PortArgs.param[1] = speed_num[0];
            PortArgs.param[2] = bitdata_num;
            PortArgs.param[3] = stopbit_num;

            for (int i = 0; i < 4; i++)
            {
                Console.WriteLine(PortArgs.param[i]);
            }
        }

        private void AppCreateLink_FormClosing(object sender, FormClosingEventArgs e)
        {
            Form Main = Application.OpenForms[0];
            Main.Show();
        }

        private void label7_Click(object sender, EventArgs e)
        {

        }
    }
}
