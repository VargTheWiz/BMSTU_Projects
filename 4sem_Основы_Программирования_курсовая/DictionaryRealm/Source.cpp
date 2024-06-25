#include "Header.h"

using namespace std;

//Добавление словаря
void CreateDictionary(vector <Dictionary>& Dictionaries);

//Вывод списка словарей
void PrintDictionaries(vector <Dictionary> Dictionaries);

//Удаление словаря
void DeleteDictionary(vector <Dictionary>& Dictionaries);

//Объединение двух словарей
void MergeDictionaries(vector <Dictionary>& Dictionaries);

//Разделение словарей
void SeparateDictionaries(vector <Dictionary>& Dictionaries);

//Работа с отдельно взятым словарем
void ChangeDictionary(vector <Dictionary>& Dictionaries);

void ReadFromFile(vector <Dictionary>& Dictionaries);
void WriteToFile(vector <Dictionary>& Dictionaries);


int main()
{
	system("chcp 1251 >> null");
	cout << "Система словарей и гнезд(пар значений)" << endl;
	cout << "Разработал: Рябкин А.В" << endl;
	//Вектор для хранения всех словарей
	vector <Dictionary> Dictionaries;
	char flagMain = '1';
	//char flagMenu = '1';
	int flagMenuIn = -1;
	//Меню
	while (flagMain != '0')
	{
		cout << "===Меню операций с словарями===" << endl;
		cout << "1. Просмотреть список словарей" << endl;
		cout << "2. Добавить новый словарь в БД" << endl;
		cout << "3. Удалить словарь из БД" << endl;
		cout << "4. Объединить два словаря" << endl;
		cout << "5. Разделить словарь" << endl;
		cout << "6. Работа со словарями" << endl;
		cout << "7. Ввод словарей из файла" << endl;
		cout << "8. Вывести словари в файл" << endl;

		cout << "9. Выйти из программы" << endl;

		cout << "Выберите пункт меню (1|2|3|4|5|6|7 8 9): ";
		cin >> flagMenuIn;
		switch (flagMenuIn)
		{
			//Вывод списка словарей
		case 1:
			PrintDictionaries(Dictionaries);
			flagMenuIn = -1;
			break;
			//Добавление нового словаря
		case 2:
			CreateDictionary(Dictionaries);
			flagMenuIn = -1;
			break;
			//Удаление словаря
		case 3:
			DeleteDictionary(Dictionaries);
			flagMenuIn = -1;
			break;
			//Объединение двух словарей
		case 4:
			MergeDictionaries(Dictionaries);
			flagMenuIn = -1;
			break;
			//Разделение словарей
		case 5:
			SeparateDictionaries(Dictionaries);
			flagMenuIn = -1;
			break;
			//Работа со словарем
		case 6:
			ChangeDictionary(Dictionaries);
			flagMenuIn = -1;
			break;
			//Прочитать словари из файла
		case 7:
			ReadFromFile(Dictionaries);
			break;
			//ЗАписать словари в файл
		case 8:
			WriteToFile(Dictionaries);
			break;
			//Выход из программы
		case 9:
			flagMain = '0';
			break;
			//Проверка правильности выбора пункта меню
		default:
			cout << endl << "Ошибка ввода! Такого пункта не существует!" << endl << endl;
			break;
		}
	}
	cout << "Работа завершена! ";
	

	system("PAUSE");
	return 0;
}

