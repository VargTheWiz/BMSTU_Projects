using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;

namespace KursovayaRyabSolAbr
{
    class Kadry
    {
        public enum kadr_type : byte
        {
            LINK,
            MAINTAIN,
            DISCONN,
            ACK,
            RET,
            ARGS,
            MSG,
            NAME
        }

        /// <summary>
        /// Возвращает тип кадра
        /// </summary>
        public static kadr_type define_kadr_type(byte[] kadr)
        {
            if (kadr[1] > 127)
                return (kadr_type)(kadr[1] - 128);
            else
                return (kadr_type)kadr[1];
        }

        /// <summary>
        /// Формирует служебный кадр, готовый для отправки
        /// </summary>
        public static BitArray service_kadr_to_send(kadr_type kadr)
        {
            BitArray fr_mas = Kadry.kadr_to_bitarray(Kadry.byte_service_kadr(kadr));  // Создаем служебный кадр данного типа
            fr_mas = HummingBirdCode.bitstuffing(fr_mas);

            //Отделяем стоповый байт от содержимого нулем (чтобы физический уровень мог достоверно определить конец кадра)
            fr_mas = HummingBirdCode.bit_insertion(fr_mas, false, fr_mas.Count - 14);
            fr_mas = HummingBirdCode.bit_insertion(fr_mas, false, 14);

            return fr_mas;
        }

        /// <summary>
        /// Формирует кадр с сообщением, готовый для отправки
        /// </summary>
        public static BitArray message_kadr_to_send(byte[] mas)
        {
            BitArray fr_mas = Kadry.kadr_to_bitarray(Kadry.byte_message_kadr(mas));  // Создаем кадр данного типа
            fr_mas = HummingBirdCode.bitstuffing(fr_mas);

            //Отделяем стоповый байт от содержимого нулем (чтобы физический уровень мог достоверно определить конец кадра)
            fr_mas = HummingBirdCode.bit_insertion(fr_mas, false, fr_mas.Count - 14);
            fr_mas = HummingBirdCode.bit_insertion(fr_mas, false, 14);

            return fr_mas;
        }

        /// <summary>
        /// Формирует кадр с параметрами соединения, готовый для отправки
        /// </summary>
        public static BitArray args_kadr_to_send(byte[] user, byte[] param)
        {
            BitArray fr_mas = Kadry.kadr_to_bitarray(Kadry.byte_arguments_kadr(user, param));  // Создаем кадр данного типа
            fr_mas = HummingBirdCode.bitstuffing(fr_mas);

            //Отделяем стоповый байт от содержимого нулем (чтобы физический уровень мог достоверно определить конец кадра)
            fr_mas = HummingBirdCode.bit_insertion(fr_mas, false, fr_mas.Count - 14);
            fr_mas = HummingBirdCode.bit_insertion(fr_mas, false, 14);

            return fr_mas;
        }

        /// <summary>
        /// Формирует кадр с именем пользователя, готовый для отправки
        /// </summary>
        public static BitArray name_kadr_to_send(byte[] user)
        {
            BitArray fr_mas = Kadry.kadr_to_bitarray(Kadry.byte_name_kadr(user));  // Создаем кадр данного типа
            fr_mas = HummingBirdCode.bitstuffing(fr_mas);

            //Отделяем стоповый байт от содержимого нулем (чтобы физический уровень мог достоверно определить конец кадра)
            fr_mas = HummingBirdCode.bit_insertion(fr_mas, false, fr_mas.Count - 14);
            fr_mas = HummingBirdCode.bit_insertion(fr_mas, false, 14);

            return fr_mas;
        }

        /// <summary>
        /// Формирует кадр с именем пользователя как массив byte (вспомогательная функция)
        /// </summary>
        public static byte[] byte_name_kadr(byte[] mas)
        {
            byte[] name_kadr = new byte[4 + mas.Length];
            name_kadr[0] = 0xFF;
            name_kadr[1] = (byte)kadr_type.NAME;
            name_kadr[2] = (byte)mas.Length;
            for (int i = 3; i < name_kadr.Length - 1; i++)
                name_kadr[i] = mas[i - 3];
            name_kadr[name_kadr.Length - 1] = 0xFF;

            return name_kadr;
        }

        /// <summary>
        /// Переключение флага C/R в состояние Response
        /// </summary>
        public static byte[] set_command_to_response(byte[] kadr)
        {
            kadr[1] += 128;
            return kadr;
        }


        /// <summary>
        /// Создает кадр с сообщением как массив byte (вспомогательная функция)
        /// </summary>
        public static byte[] byte_message_kadr(byte[] mas)
        {
            byte[] message_kadr = new byte[5 + mas.Length];
            message_kadr[0] = 0xFF;
            message_kadr[1] = (byte)kadr_type.MSG;
            message_kadr[2] = (byte)(mas.Length >> 8);
            message_kadr[3] = (byte)(mas.Length & 0x00FF);
            for (int i = 4; i < message_kadr.Length - 1; i++)
                message_kadr[i] = mas[i - 4];
            message_kadr[message_kadr.Length - 1] = 0xFF;

            return message_kadr;
        }

        /// <summary>
        /// Создает кадр с параметрами соединения как массив byte (вспомогательная функция)
        /// </summary>
        public static byte[] byte_arguments_kadr(byte[] user, byte[] param)
        {
            byte[] args_kadr = new byte[4 + user.Length + param.Length]; // 3 служебных байта 
            args_kadr[0] = 0xFF;
            args_kadr[1] = (byte)kadr_type.ARGS;
            args_kadr[2] = (byte)user.Length;
            for (int i = 3; i - 3 < user.Length; i++)       // имя пользователя
                args_kadr[i] = user[i - 3];

            for (int i = 3 + user.Length; i - 3 - user.Length < param.Length; i++)  // массив параметров
                args_kadr[i] = param[i - 3 - user.Length];

            args_kadr[args_kadr.Length - 1] = 0xFF;

            return args_kadr;
        }

        /// <summary>
        /// Осуществляет декодирование полученного через физический канал кадра
        /// </summary>
        public static byte[] decode_kadr(BitArray recieved_kadr)
        {
            // Проводим махинации по удалению вспомогательных нулей, добавленных при битстаффинге
            BitArray decoded_kadr = HummingBirdCode.inv_bitstuffing(recieved_kadr);

            // Удаляем ноль перед стоповым битом
            decoded_kadr = HummingBirdCode.bit_deletion(decoded_kadr, decoded_kadr.Count - 15);
            decoded_kadr = HummingBirdCode.bit_deletion(decoded_kadr, 14);

            byte[] result = Kadry.bitarray_to_kadr(decoded_kadr);
            return result;
        }

        /// <summary>
        /// Просто печает массив байт
        /// </summary>
        /// <param name="mas"></param>
        public static void print_byte(byte[] mas)
        {
            for (int i = 0; i < mas.Length; i++)
            {
                Console.Write(mas[i]);
                Console.Write(' ');
            }
            Console.WriteLine();
        }

        /// <summary>
        /// Создает служебный кадр как массив byte (вспомогательная функция)
        /// </summary>
        public static byte[] byte_service_kadr(kadr_type kadr)
        {
            byte[] service_kadr = new byte[3];
            service_kadr[0] = 255;   //0xFF - стартовый байт
            service_kadr[1] = (byte)kadr;
            service_kadr[2] = 255;   //0xFF - стоповый байт

            return service_kadr;
        }

        /// <summary>
        /// Преобразует массив byte в BitArray, закодированный кодом Хэмминга (вспомогательная функция)
        /// </summary>
        public static BitArray kadr_to_bitarray(byte[] kadr)
        {
            BitArray mas = new BitArray(0);
            for (int i = 0; i < kadr.Length; i++)
                mas = HummingBirdCode.append_bit_array(mas, HummingBirdCode.byte2array(kadr[i]));

            return mas;
        }

        /// <summary>
        /// Преобразует BitArray в  массив byte, закодированный кодом Хэмминга (вспомогательная функция)
        /// </summary>
        public static byte[] bitarray_to_kadr(BitArray mas)
        {
            byte[] res = new byte[mas.Count / 14];
            BitArray buffer = new BitArray(14);
            int i = 0;
            while (i < mas.Count)
            {
                // Пока не кратно размерности буфера(14), наполняем буфер
                if (i % 14 < 13)
                {
                    buffer[i % 14] = mas[i];
                    i++;
                }
                // Когда кратно 14, выгружаем из буфера и переводим в байт
                else
                {
                    buffer[i % 14] = mas[i];
                    res[i / 14] = HummingBirdCode.array2byte(buffer);
                    buffer.SetAll(false);
                    i++;

                }
            }
            return res;
        }
    }
}