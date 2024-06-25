using System.Text;
using System;
using System.IO.Ports;
using System.Threading;
using System.Collections;
using System.Diagnostics;

namespace KursovayaRyabSolAbr
{
    class PhysicalLevel
    {

        public static string bit_to_string(BitArray mass)
        {
            string line = "";
            for (int i = 0; i < mass.Count; i++)
            {
                if (mass[i] == true) line += "1";
                else line += "0";
            }
            return line;
        }

        public static BitArray string_to_bit(string str)
        {

            BitArray bits = new BitArray(str.Length);
            for (int i = 0; i < str.Length; i++)
            {
                if (str[i] == '1') bits[i] = true;
                else bits[i] = false;
            }
            return bits;
        }
    }

    class Port
    {

        public static bool is_setting_params;
        //параметры порта!!!
        public static string port_name;
        public static SerialPort _serialPort;

        //изменяемые параметры
        public static string bound_port;
        public static string data_bits;
        public static string parity;
        public static string stop_bits;

        public static void set_port_standart(SerialPort serial, string portname)
        {
            serial.PortName = portname;
            serial.BaudRate = 9600;
            serial.DataBits = 8;
            serial.Parity = Parity.None;
            serial.StopBits = StopBits.One;
            serial.Handshake = Handshake.None;
            serial.ReadTimeout = 500;
            serial.WriteTimeout = 500;
            Port.is_setting_params = false;
        }
        //Затереть начальные значения порта (для тестирования)

        public static void set_new_param(SerialPort serial)
        {
            serial.BaudRate = Convert.ToInt32(Port.bound_port);
            serial.DataBits = Convert.ToInt32(Port.data_bits);
            switch (Port.stop_bits)
            {
                case "1":
                    serial.StopBits = StopBits.One;
                    break;
                case "2":
                    serial.StopBits = StopBits.Two;
                    break;
                default:
                    serial.StopBits = StopBits.One;
                    break;
            }
            Port.is_setting_params = true;

        }

        public static bool is_open = false;

    }

    class PortArgs
    {
        public static byte[] param = new byte[5];
        public static byte[] name;
        public static bool is_changed = false;

    }
    class User
    {
        public static string this_name;
        public static string friend_name;
        public static bool is_client;//0-server,1-client;
    }
    class Message
    {
        public static Stopwatch timer_patam_setup = new Stopwatch();
        public static StringComparer stringComparer = StringComparer.OrdinalIgnoreCase;
        public static Thread readThread;
        public static string message;
        public static bool ack_ok = true;

        public static bool is_new_kadr = false;

        public static Kadry.kadr_type type_kadr;

        public static bool on_printing = false;
        public static string current_message;
        public static void Read()
        {
            while (Port.is_open)
            {
                try
                {
                    message = Port._serialPort.ReadLine();
                    is_new_kadr = true;
                }
                catch (TimeoutException) { }
            }
        }


        public static void reading_kadr(string incoming)
        {
            BitArray kadr = new BitArray(incoming.Length);
            kadr = PhysicalLevel.string_to_bit(incoming);
            BitArray last_kadr = new BitArray(incoming.Length);

            // Получили его обратно через физический и декодировали
            byte[] new_str_byte = Kadry.decode_kadr(kadr);
            switch (Kadry.define_kadr_type(new_str_byte))
            {
                case Kadry.kadr_type.MSG:
                    last_kadr = kadr;
                    if (HummingBirdCode.hamming_test(kadr))
                    {
                        // Выбираем содержательную часть
                        int text_size = new_str_byte[2] * 256 + new_str_byte[3];
                        byte[] str_byte = new byte[text_size];
                        for (int i = 0; i < text_size; i++)
                            str_byte[i] = new_str_byte[i + 4];

                        //--------------------------Detranslate------------------------------------------
                        string str_message = App.byte_to_string(str_byte);
                        //-------------------------------------------------------------------------------
                        Message.current_message = str_message;
                        Message.on_printing = true;

                        BitArray answer_kadr = Kadry.service_kadr_to_send(Kadry.kadr_type.ACK);
                        Port._serialPort.WriteLine(PhysicalLevel.bit_to_string(answer_kadr));
                    }
                    else
                    {
                        BitArray answer_kadr = Kadry.service_kadr_to_send(Kadry.kadr_type.RET);
                        Port._serialPort.WriteLine(PhysicalLevel.bit_to_string(answer_kadr));
                    }
                    break;

                case Kadry.kadr_type.LINK:

                    if (HummingBirdCode.getBit(new_str_byte[1], 7) == false)     // Обрaботка LINK-Command
                    {
                        new_str_byte = Kadry.set_command_to_response(new_str_byte);

                        // Кодирование Хэммингом + битстаффинг
                        kadr = Kadry.kadr_to_bitarray(new_str_byte);
                        kadr = HummingBirdCode.bitstuffing(kadr);
                        kadr = HummingBirdCode.bit_insertion(kadr, false, kadr.Count - 14);
                        kadr = HummingBirdCode.bit_insertion(kadr, false, 14);

                        // Отправляем в ответку с флагом Response
                        string string_kadr = PhysicalLevel.bit_to_string(kadr);
                        Port._serialPort.WriteLine(string_kadr);
                    }
                    else if (HummingBirdCode.getBit(new_str_byte[1], 7) == true)  // Обрaботка LINK-Response
                    {

                        BitArray arguments_kadr = Kadry.args_kadr_to_send(PortArgs.name, PortArgs.param);
                        Port._serialPort.WriteLine(PhysicalLevel.bit_to_string(arguments_kadr));
                    }
                    break;

                case Kadry.kadr_type.ACK:
                    ack_ok = true;
                    break;

                case Kadry.kadr_type.MAINTAIN:

                    if (HummingBirdCode.getBit(new_str_byte[1], 7) == false)     // Обрaботка MAINTAIN-Command
                    {

                        new_str_byte = Kadry.set_command_to_response(new_str_byte);

                        // Кодирование Хэммингом + битстаффинг
                        kadr = Kadry.kadr_to_bitarray(new_str_byte);
                        kadr = HummingBirdCode.bitstuffing(kadr);
                        kadr = HummingBirdCode.bit_insertion(kadr, false, kadr.Count - 14);
                        kadr = HummingBirdCode.bit_insertion(kadr, false, 14);

                        // Отправляем в ответку с флагом Response
                        string string_kadr = PhysicalLevel.bit_to_string(kadr);
                        Port._serialPort.WriteLine(string_kadr);

                        AppSend.maintain_recieved = true;
                    }
                    else if (HummingBirdCode.getBit(new_str_byte[1], 7) == true)  // Обрaботка MAINTAIN-Response
                    {
                        AppSend.response_recieved = true;

                    }
                    break;

                case Kadry.kadr_type.DISCONN:

                    if (HummingBirdCode.getBit(new_str_byte[1], 7) == false)     // Обрaботка DISCONN-Command
                    {
                        new_str_byte = Kadry.set_command_to_response(new_str_byte);

                        // Кодирование Хэммингом + битстаффинг
                        kadr = Kadry.kadr_to_bitarray(new_str_byte);
                        kadr = HummingBirdCode.bitstuffing(kadr);
                        kadr = HummingBirdCode.bit_insertion(kadr, false, kadr.Count - 14);
                        kadr = HummingBirdCode.bit_insertion(kadr, false, 14);

                        // Отправляем в ответку с флагом Response
                        string string_kadr = PhysicalLevel.bit_to_string(kadr);
                        Port._serialPort.WriteLine(string_kadr);

                        AppSend.disconn_received = true;
                    }
                    else if (HummingBirdCode.getBit(new_str_byte[1], 7) == true)  // Обрaботка DISCONN-Response
                    {
                        AppSend.disconn_response_received = true;
                    }
                    break;

                case Kadry.kadr_type.ARGS:
                    last_kadr = kadr;

                    Port.bound_port = (new_str_byte[3 + new_str_byte[2]] * 256 + new_str_byte[4 + new_str_byte[2]]).ToString();
                    Port.data_bits = new_str_byte[5 + new_str_byte[2]].ToString();
                    Port.stop_bits = new_str_byte[6 + new_str_byte[2]].ToString();
                    Port.parity = new_str_byte[7 + new_str_byte[2]].ToString();

                    User.friend_name = get_username(new_str_byte);


                    BitArray service_kadr = Kadry.name_kadr_to_send(App.string_to_byte(User.this_name));
                    Port._serialPort.WriteLine(PhysicalLevel.bit_to_string(service_kadr));
                    PortArgs.is_changed = true;
                    timer_patam_setup.Start();

                    break;

                case Kadry.kadr_type.NAME:
                    {
                        last_kadr = kadr;
                        if (HummingBirdCode.hamming_test(kadr))
                        {
                            User.friend_name = get_username(new_str_byte);
                            AppSend.start_maintain = true;

                            BitArray ack_kadr = Kadry.service_kadr_to_send(Kadry.kadr_type.ACK);
                            Port._serialPort.WriteLine(PhysicalLevel.bit_to_string(ack_kadr));
                        }
                        else
                        {
                            BitArray answer_kadr = Kadry.service_kadr_to_send(Kadry.kadr_type.RET);
                            Port._serialPort.WriteLine(PhysicalLevel.bit_to_string(answer_kadr));
                        }
                        timer_patam_setup.Start();
                        break;

                    }

                case Kadry.kadr_type.RET:
                    Port._serialPort.WriteLine(PhysicalLevel.bit_to_string(last_kadr));
                    break;
                default:

                    break;
            }


        }



        //Получение имени
        public static string get_username(byte[] kadr)
        {
            int user_length = kadr[2];
            byte[] name_byte = new byte[user_length];
            for (int i = 3; i < 3 + user_length; i++)
            {
                name_byte[i - 3] = kadr[i];
            }
            return App.byte_to_string(name_byte);
        }


    }
}
