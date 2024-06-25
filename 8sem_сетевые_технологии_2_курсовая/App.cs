using System;
using System.Collections.Generic;
using System.Text;

namespace KursovayaRyabSolAbr
{
    class App
    {
        public static int string_to_int_port(string str)
        {
            int num = 0;

            for (int i = 0; i < str.Length; i++)
            {
                num = num * 10 + (int)str[i] - (int)('0');
            }

            return num;
        }

        public static void port_param_byte_to_string(byte[] str_byte)
        {
            string[] parity_list = { "NONE", "EVEN", "MARK", "ODD", "SPACE" };

            int baund = (int)str_byte[0] * 256 + (int)str_byte[1];
            int bitdata_n = (int)str_byte[2];
            int stopbit_n = (int)str_byte[3];
            int parity_n = (int)str_byte[4];
            string parity_t = parity_list[parity_n];

            Port.bound_port = baund.ToString();
            Port.data_bits = bitdata_n.ToString();
            Port.stop_bits = stopbit_n.ToString();
            Port.parity = parity_t;
        }

        public static byte[] string_to_byte(string str)
        {
            byte[] str_byte = new byte[str.Length * 2];

            for (int i = 0; i < str.Length; i++)
            {
                char[] hex = new char[4] { '0', '0', '0', '0' };
                string str2 = ((int)str[i]).ToString("X2");
                for (int j = 0; j < str2.Length; j++)
                {
                    hex[3 - j] = str2[str2.Length - j - 1];
                }

                str_byte[i * 2] = (byte)(hex_to_dec(hex[0]) * 16 + hex_to_dec(hex[1]));
                str_byte[i * 2 + 1] = (byte)(hex_to_dec(hex[2]) * 16 + hex_to_dec(hex[3]));
            }

            return str_byte;
        }

        public static string byte_to_string(byte[] str_byte)
        {
            char[] str_ch = new char[str_byte.Length / 2];

            for (int i = 0; i < str_byte.Length; i += 2)
            {
                char[] hex = new char[4] { '0', '0', '0', '0' };

                hex[0] = dec_to_hex(((int)str_byte[i] - (int)str_byte[i] % 16) / 16);
                hex[1] = dec_to_hex((int)str_byte[i] % 16);
                hex[2] = dec_to_hex(((int)str_byte[i + 1] - (int)str_byte[i + 1] % 16) / 16);
                hex[3] = dec_to_hex((int)str_byte[i + 1] % 16);

                int ch = hex_to_dec(hex[3]) + hex_to_dec(hex[2]) * 16 +
                    hex_to_dec(hex[1]) * 256 + hex_to_dec(hex[0]) * 4096;

                str_ch[i / 2] += (char)ch;
            }
            string str = new string(str_ch);

            return str;
        }

        public static int hex_to_dec(char ch)
        {
            if (ch >= '0' && ch <= '9')
                return (int)(ch - '0');
            if (ch >= 'A' && ch <= 'F')
                return (int)(ch - 'A') + 10;
            return 0;
        }

        public static char dec_to_hex(int dec)
        {
            if (dec >= 0 && dec <= 9)
                return (char)(48 + dec);
            if (dec >= 10 && dec <= 15)
                return (char)((int)('A') + dec - 10);
            return '0';
        }
    }
}
