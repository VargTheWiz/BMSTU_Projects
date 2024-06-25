#include "Header.h"

using namespace std;

//���������� �������
void CreateDictionary(vector <Dictionary>& Dictionaries);

//����� ������ ��������
void PrintDictionaries(vector <Dictionary> Dictionaries);

//�������� �������
void DeleteDictionary(vector <Dictionary>& Dictionaries);

//����������� ���� ��������
void MergeDictionaries(vector <Dictionary>& Dictionaries);

//���������� ��������
void SeparateDictionaries(vector <Dictionary>& Dictionaries);

//������ � �������� ������ ��������
void ChangeDictionary(vector <Dictionary>& Dictionaries);

void ReadFromFile(vector <Dictionary>& Dictionaries);
void WriteToFile(vector <Dictionary>& Dictionaries);


int main()
{
	system("chcp 1251 >> null");
	cout << "������� �������� � �����(��� ��������)" << endl;
	cout << "����������: ������ �.�" << endl;
	//������ ��� �������� ���� ��������
	vector <Dictionary> Dictionaries;
	char flagMain = '1';
	//char flagMenu = '1';
	int flagMenuIn = -1;
	//����
	while (flagMain != '0')
	{
		cout << "===���� �������� � ���������===" << endl;
		cout << "1. ����������� ������ ��������" << endl;
		cout << "2. �������� ����� ������� � ��" << endl;
		cout << "3. ������� ������� �� ��" << endl;
		cout << "4. ���������� ��� �������" << endl;
		cout << "5. ��������� �������" << endl;
		cout << "6. ������ �� ���������" << endl;
		cout << "7. ���� �������� �� �����" << endl;
		cout << "8. ������� ������� � ����" << endl;

		cout << "9. ����� �� ���������" << endl;

		cout << "�������� ����� ���� (1|2|3|4|5|6|7 8 9): ";
		cin >> flagMenuIn;
		switch (flagMenuIn)
		{
			//����� ������ ��������
		case 1:
			PrintDictionaries(Dictionaries);
			flagMenuIn = -1;
			break;
			//���������� ������ �������
		case 2:
			CreateDictionary(Dictionaries);
			flagMenuIn = -1;
			break;
			//�������� �������
		case 3:
			DeleteDictionary(Dictionaries);
			flagMenuIn = -1;
			break;
			//����������� ���� ��������
		case 4:
			MergeDictionaries(Dictionaries);
			flagMenuIn = -1;
			break;
			//���������� ��������
		case 5:
			SeparateDictionaries(Dictionaries);
			flagMenuIn = -1;
			break;
			//������ �� ��������
		case 6:
			ChangeDictionary(Dictionaries);
			flagMenuIn = -1;
			break;
			//��������� ������� �� �����
		case 7:
			ReadFromFile(Dictionaries);
			break;
			//�������� ������� � ����
		case 8:
			WriteToFile(Dictionaries);
			break;
			//����� �� ���������
		case 9:
			flagMain = '0';
			break;
			//�������� ������������ ������ ������ ����
		default:
			cout << endl << "������ �����! ������ ������ �� ����������!" << endl << endl;
			break;
		}
	}
	cout << "������ ���������! ";
	

	system("PAUSE");
	return 0;
}

