using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;

namespace KursovayaRyabSolAbr
{
    class HummingBirdCode
    {
        /// <summary>
        /// Достает из byte числа бит №pos в двоичном представлении
        /// </summary>
        public static bool getBit(byte inByte, int pos)
        {
            return ((1 << pos) & inByte) == 0 ? false : true;
        }

        /// <summary>
        /// Переводит число byte в BitArray[14]
        /// </summary>
        public static BitArray byte2array(byte num)
        {
            BitArray low_order = new BitArray(4); //младшие разряды
            for (int i = 0; i < low_order.Length; i++)
                low_order[i] = HummingBirdCode.getBit(num, i);
            BitArray low_order_coded = hamming_code(low_order);

            num >>= 4;
            BitArray high_order = new BitArray(4); //старшие разряды
            for (int i = 0; i < high_order.Length; i++)
                high_order[i] = HummingBirdCode.getBit(num, i);
            BitArray high_order_coded = hamming_code(high_order);

            BitArray new_mas = HummingBirdCode.append_bit_array(low_order_coded, high_order_coded);
            return new_mas;
        }

        /// <summary>
        /// Кодирует BitArray[4] в BitArray[7] (Хэмминг[7,4])
        /// </summary>
        /// <returns>BitArray[7]</returns>
        public static BitArray hamming_code(BitArray mas)
        {
            BitArray code_mas = new BitArray(7);
            code_mas[6] = mas[3];
            code_mas[5] = mas[2];
            code_mas[4] = mas[1];
            code_mas[2] = mas[0];

            code_mas[0] = code_mas[2] ^ code_mas[4] ^ code_mas[6];
            code_mas[1] = code_mas[2] ^ code_mas[5] ^ code_mas[6];
            code_mas[3] = code_mas[4] ^ code_mas[5] ^ code_mas[6];

            return code_mas;
        }

        /// <summary>
        /// Проверяет наличие ошибок в полученном BitArray[7]. true-все хорошо, false-ошибка
        /// </summary>
        public static bool hamming_test(BitArray mas)
        {
            bool synd0 = mas[0] ^ mas[2] ^ mas[4] ^ mas[6];
            bool synd1 = mas[1] ^ mas[2] ^ mas[5] ^ mas[6];
            bool synd2 = mas[3] ^ mas[4] ^ mas[5] ^ mas[6];

            if ((synd0 || synd1 || synd2) == false)
                return true;
            else
                return false;
        }

        /// <summary>
        /// Кодирует BitArray[7] в BitArray[4] (Хэмминг[7,4])
        /// </summary>
        /// <returns>BitArray[4]</returns>
        public static BitArray hamming_decode(BitArray mas)
        {
            BitArray decode_mas = new BitArray(4);
            decode_mas[3] = mas[6];
            decode_mas[2] = mas[5];
            decode_mas[1] = mas[4];
            decode_mas[0] = mas[2];

            return decode_mas;
        }

        /// <summary>
        /// Декодирует BitArray[14] в byte
        /// </summary>
        public static byte array2byte(BitArray coded_mas)
        {
            //Извлекаем информационный вектор младших 4х разрядов байта

            BitArray low_order_coded = new BitArray(7);
            for (int i = 0; i < low_order_coded.Length; i++)
                low_order_coded[i] = coded_mas[i];
            BitArray low_order = HummingBirdCode.hamming_decode(low_order_coded);

            //Извлекаем информационный вектор старших 4х разрядов байта
            BitArray high_order_coded = new BitArray(7);
            for (int i = 0; i < high_order_coded.Length; i++)
                high_order_coded[i] = coded_mas[i + 7];
            BitArray high_order = HummingBirdCode.hamming_decode(high_order_coded);


            //Переводим в byte
            byte num = 0;
            byte power = 1;
            for (int i = 0; i < low_order.Length; i++)
            {
                if (low_order[i])
                    num += power;
                power *= 2;
            }

            for (int i = 0; i < high_order.Length; i++)
            {
                if (high_order[i])
                    num += power;
                power *= 2;
            }

            return num;
        }

        /// <summary>
        /// Печатает BitArray[любая размерность] в виде двоичного числа
        /// </summary>
        public static void print_array(BitArray mas)
        {
            for (int i = mas.Length - 1; i >= 0; i--)
            {
                if (mas[i])
                    Console.Write(1);
                else
                    Console.Write(0);

                if (i % 14 == 0)
                    Console.Write('/');
            }
        }

        /// <summary>
        /// Реализует функцию битстаффинга
        /// </summary>
        public static BitArray bitstuffing(BitArray mas)
        {
            int true_counter = 0;
            int i = 14;                     // Используем битстаффинг только между стартовым 
            while (i < mas.Count - 14)      // и стоповым битами
            {
                //Проверяем, набралось ли 13 единиц подряд
                if (true_counter < 13)
                {
                    if (mas[i])
                        true_counter++;
                    else
                        true_counter = 0;
                }

                //Вставляем бит false
                else
                {
                    mas = HummingBirdCode.bit_insertion(mas, false, i);
                    true_counter = 0;
                }
                i++;
            }
            return mas;
        }

        /// <summary>
        /// Реализует функцию, обратную функции битстаффинга
        /// </summary>
        public static BitArray inv_bitstuffing(BitArray mas)
        {
            int true_counter = 0;
            int i = 14;                     // Проверяем только между стартовым 
            while (i < mas.Count - 14)      // и стоповым битами
            {
                //Проверяем, набралось ли 13 единиц подряд
                if (true_counter < 13)
                {
                    if (mas[i])
                        true_counter++;
                    else
                        true_counter = 0;
                }

                //Вставляем бит false
                else
                {
                    mas = HummingBirdCode.bit_deletion(mas, i);
                    true_counter = 0;
                }
                i++;
            }
            return mas;
        }

        /// <summary>
        /// Объединяет 2 BitArray
        /// </summary>
        /// <param name="first">Массив, который будет вставлен первым</param>
        /// <param name="second">Массив, который будет вторым</param>
        public static BitArray append_bit_array(BitArray first, BitArray second)
        {
            var bools = new bool[first.Count + second.Count];
            first.CopyTo(bools, 0);
            second.CopyTo(bools, first.Count);
            return new BitArray(bools);
        }

        /// <summary>
        /// Вставляет бит value по индексу pos в массиве mas. 
        /// </summary>
        /// <param name="mas"></param>
        /// <param name="value"></param>
        /// <param name="pos"></param>
        /// <returns>Новый массив</returns>
        public static BitArray bit_insertion(BitArray mas, bool value, int pos)
        {
            var bools = new bool[mas.Count + 1];

            // Копируем все элементы с индексом до pos
            for (int i = 0; i < pos; i++)
            {
                bools[i] = mas[i];
            }

            // Вставляем бит
            bools[pos] = value;

            // Вставляем элементы с индексом после pos со смещением
            for (int i = pos + 1; i <= mas.Count; i++)
            {
                bools[i] = mas[i - 1];
            }

            return new BitArray(bools);
        }

        /// <summary>
        /// Удаляет бит с позиции pos. 
        /// </summary>
        /// <returns>Новый массив</returns>
        public static BitArray bit_deletion(BitArray mas, int pos)
        {
            var bools = new bool[mas.Count - 1];

            // Копируем все элементы с индексом до pos
            for (int i = 0; i < pos; i++)
            {
                bools[i] = mas[i];
            }

            // Вставляем элементы с индексом после pos со смещением
            for (int i = pos; i < mas.Count - 1; i++)
            {
                bools[i] = mas[i + 1];
            }

            return new BitArray(bools);
        }
    }
}

