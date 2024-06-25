using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO.Ports;
using System.Threading;
using System.Collections;

namespace KursovayaRyabSolAbr
{
    public partial class AppSend : Form
    {

        public static bool response_recieved = false;
        private static bool kadr_received = false;
        public static bool maintain_recieved = false;
        public static bool start_maintain = false;
        private static int errors_counter = 0;
        private static bool modal_form_is_open = false;
        public static bool disconn_received = false;
        public static bool disconn_response_received = false;

        Form form = new Reconnect();
        Form AppAReceive = new AppReceive();

        public AppSend()
        {
            InitializeComponent();
            this.KeyPreview = true;
            this.KeyUp += new System.Windows.Forms.KeyEventHandler(this.AppSend_KeyUp);
            this.send.Click += new System.EventHandler(this.send_Click_1);

        }





        private void AppSend_Load(object sender, EventArgs e)
        {

            string message = "Simple MessageBox";
            string title = "Title";
            MessageBox.Show(message, title);


            //установление параметров для передачи/приема сообщений(только для чтения)
            //StringComparer stringComparer = StringComparer.OrdinalIgnoreCase;
            //Thread readThread = new Thread(Read);

            //установления порта в стандыртные значения
            Port._serialPort = new SerialPort();
            Port.set_port_standart(Port._serialPort, Port.port_name);

            //открытие порта
            Port._serialPort.Open();
            Port.is_open = Port._serialPort.IsOpen;

            Message.readThread = new Thread(Message.Read);
            Message.readThread.Start();
            Message.readThread.IsBackground = true;

            //ожидание ответа
            //если ответ получен присвоить глобально параметры
            //установить параметры порта в нужном виде

            view_port_param(this);
            initialize_refresher();
            initialize_refresher2();
            timer3.Enabled = true;

            //откроем окошко после всей лабуды с установлением
            AppAReceive.Show();

            if (!modal_form_is_open)
            {
                modal_form_is_open = true;
                form.ShowDialog();
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            // Создаем кадр с сообщением (c кодированием)
            BitArray kadr = Kadry.service_kadr_to_send(Kadry.kadr_type.DISCONN);
            send_and_resend_disconn_if_timeout(kadr);

            this.Hide();
            AppAReceive.Hide();
            Form Main = Application.OpenForms[0];
            Main.Show();
        }

        private void AppSend_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter) send.PerformClick();
        }

        private void send_Click_1(object sender, EventArgs e)
        {
            if (Message.ack_ok)
            {
                //click_send();
                string sent_message = this.message.Text;

                if (sent_message != "")
                {
                    //Переводим в байты
                    byte[] str_byte = App.string_to_byte(sent_message);


                    // Создаем кадр с сообщением (c кодированием)
                    BitArray kadr = Kadry.message_kadr_to_send(str_byte);

                    //перевод строки для передачи
                    string sting_kadr = PhysicalLevel.bit_to_string(kadr);
                    Message.ack_ok = false;
                    //отправление данных в поток
                    Port._serialPort.WriteLine(sting_kadr);

                    //отображение сообщения на форме
                    send_message.Items.Add(User.this_name + ": " + sent_message);
                    this.message.Text = "";

                    send_and_resend_if_timeout(kadr);//?????????
                }
            }
        }

        private void color_send()
        {
            while (!Message.ack_ok)
            {
                send.BackColor = Color.FromArgb(255, 0, 0);
            }
            send.BackColor = Color.FromArgb(0, 255, 0);

        }

        private void sent_port_args()
        {

            BitArray service_kadr = Kadry.args_kadr_to_send(PortArgs.name, PortArgs.param);
            //самоотправка в string стандартным параметрам
            Port._serialPort.WriteLine(PhysicalLevel.bit_to_string(service_kadr));
        }

        public static void view_port_param(AppSend obj)
        {
            if (Port._serialPort.IsOpen)
            {
                obj.label6.Text = "Порт открыт";
            }
            else obj.label6.Text = "Внимание! Порт закрыт!";

            obj.label7.Text = Port.bound_port;
            obj.label8.Text = Port.data_bits;
            obj.label9.Text = Port.stop_bits;
        }

        private void initialize_refresher()
        {
            // Call this procedure when the application starts.
            timer1.Interval = 50;
            timer1.Enabled = true;
            timer1.Start();
        }

        private void initialize_refresher2()
        {
            // Call this procedure when the application starts.
            // Set to 2 second.
            timer2.Interval = 3000;
            timer2.Enabled = true;
            timer2.Start();
        }

        private void timer1_Tick(object sender, EventArgs e)
        {


        }

        private void timer2_Tick_1(object sender, EventArgs e)
        {
            ///
            /// Проверка состояния порта
            ///
            if (PortArgs.is_changed)
                view_port_param(this);
            //Port.set_param(Port._serialPort);
            PortArgs.is_changed = false;

            if (Message.timer_patam_setup.Elapsed.Seconds > 1 && !Port.is_setting_params)
            {
                Port.set_new_param(Port._serialPort);
                Message.timer_patam_setup.Reset();
                Port.is_setting_params = true;
            }

            if (User.is_client && !maintain_recieved)
            {
                //MessageBox.Show("Подождите, идет подключение...", "Чат", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
                if (!modal_form_is_open)
                {
                    modal_form_is_open = true;
                    form.ShowDialog();
                }
            }

            if (User.is_client && maintain_recieved)
            {
                //MessageBox.Show("Подождите, идет подключение...", "Чат", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
                if (modal_form_is_open)
                {
                    modal_form_is_open = false;
                    form.Close();
                }
            }

            if (!User.is_client && start_maintain) // Если соединение уже установлено
            {
                // Создаем кадр с сообщением (c кодированием)
                BitArray kadr = Kadry.service_kadr_to_send(Kadry.kadr_type.MAINTAIN);
                send_and_resend_if_timeout(kadr);
            }
            else if (!User.is_client && !start_maintain)
            {
                BitArray kadr = Kadry.service_kadr_to_send(Kadry.kadr_type.LINK);
                send_and_resend_if_timeout(kadr);
            }

            maintain_recieved = false;

            if (disconn_response_received)
            {
                Port.is_open = false;

                Port._serialPort.Close();
                timer1.Stop();
                timer2.Stop();
                timer3.Stop();
                this.Hide();
                AppAReceive.Hide();
                Form Main = Application.OpenForms[0];
                Main.Show();
            }

            if (disconn_received)
            {
                Port.is_open = false;
                timer1.Stop();
                timer2.Stop();
                timer3.Stop();
                this.Hide();
                AppAReceive.Hide();
                Form Main = Application.OpenForms[0];
                Main.Show();
            }
        }

        private void timer3_Tick_1(object sender, EventArgs e)
        {
            if (!response_recieved)
            {
                (sender as System.Windows.Forms.Timer).Stop();
                kadr_received = false;
            }
            else
            {
                (sender as System.Windows.Forms.Timer).Stop();
                kadr_received = true;
                if (modal_form_is_open)
                {
                    modal_form_is_open = false;
                    form.Close();
                }
            }
        }

        private void send_kadr_and_wait_timeout(BitArray kadr)
        {

            //перевод строки для передачи
            string sting_kadr = PhysicalLevel.bit_to_string(kadr);

            //отправление данных в поток
            Port._serialPort.WriteLine(sting_kadr);

            timer3.Interval = 1000;
            timer3.Start();

            response_recieved = false;
        }

        private void send_and_resend_if_timeout(BitArray kadr)
        {
            send_kadr_and_wait_timeout(kadr);
            int resend_counter = 0;
            while (!kadr_received && resend_counter < 2)
            {
                resend_counter++;
                send_kadr_and_wait_timeout(kadr);
            }

            if (resend_counter == 2 && !kadr_received)
            {
                if (!modal_form_is_open)
                {
                    modal_form_is_open = true;
                    form.ShowDialog();
                }
            }
        }

        private void send_disconn_and_wait_timeout(BitArray kadr)
        {

            //перевод строки для передачи
            string sting_kadr = PhysicalLevel.bit_to_string(kadr);

            //отправление данных в поток
            Port._serialPort.WriteLine(sting_kadr);

            timer3.Interval = 1000;
            timer3.Start();

            disconn_response_received = false;
        }

        private void send_and_resend_disconn_if_timeout(BitArray kadr)
        {
            send_disconn_and_wait_timeout(kadr);
            int resend_counter = 0;
            while (!disconn_response_received && resend_counter < 2)
            {
                resend_counter++;
                send_disconn_and_wait_timeout(kadr);
            }
        }

        private void AppSend_FormClosing(object sender, FormClosingEventArgs e)
        {
            this.Hide();
            AppAReceive.Hide();
            Form Main = Application.OpenForms[0];
            Main.Show();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            //Port.set_new_param(Port._serialPort);
        }

        private void label1_Click(object sender, EventArgs e)
        {
         
        }

        private void label2_Click(object sender, EventArgs e)
        {
         
        }

        private void label5_Click(object sender, EventArgs e)
        {

        }

        private void label6_Click(object sender, EventArgs e)
        {

        }

        private void timer1_Tick_1(object sender, EventArgs e)
        {

        }




    }
}
