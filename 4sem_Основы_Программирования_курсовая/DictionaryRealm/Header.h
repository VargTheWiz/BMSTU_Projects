#pragma once
#include <iostream>
#include <cstdlib>
#include <algorithm>

#include <fstream>
#include <iomanip>
#include <cmath>
#include <vector>
#include <string>

using namespace std;
char YNflag();

class Nidus {
public:
	//����� ������
	//int sNumb;
	//�������� ������
	string en, ru;

	//����������� �� ���������
	Nidus() {
		en = "";
		ru = "";
	}
	//����������� � �����������
	Nidus(string a, string b) {
		en = a;
		ru = b;
	}
	//����������
	~Nidus() {};

	//������
	//����� ������ ���������� ��� ������
	void printNiduses() {
		cout << en << " " << ru << endl;
	}

	string getRu() const {
		return ru;
	}

	string getEn() const {
		return en;
	}
	friend ofstream &operator << (ofstream& out, Nidus& obj)
	{
		out << obj.en << " " << obj.ru << endl;  
		return out;

	}
	friend ifstream &operator >> (	ifstream& in, Nidus& obj) 
	{
		in >> obj.en >> obj.ru;
		return in;
	}
};

int CheckNumNiduses(vector <Nidus> Paras);

bool SortCompareNidusEn(const Nidus &a, const Nidus  &b) {
	return a.getEn() < b.getEn();
}

bool SortCompareNidusRu(const Nidus &a, const Nidus &b) {
	return a.getRu() < b.getRu();
}

class Dictionary {
public:
	//������� ������
	string autor;

	//�������� ������� 
	string name;

	//��� �������
	int date;

	//���������� ���
	int amount;

	//���� ������
	vector <Nidus> niduses;

	//����������� �� ���������
	Dictionary() 
	{
		autor = "";
		name = "";
		date = 0;
		amount = 0;
	}

	//����������� � �����������1
	Dictionary(string autorn, string namen, int daten, int amountn) 
	{
		autor = autorn;
		name = namen;
		date = daten;
		amount = amountn;
	}

	//����������� � �����������2
	Dictionary(string autorn, string namen, int daten, int amountn, vector <Nidus> defdicts)
	{
		autor = autorn;
		name = namen;
		date = daten;
		amount = amountn;
		niduses = defdicts;
	}

	//����������
	~Dictionary() {};

	//����� ������ �������
	void print(){ 
	cout << "    �����: " << autor << "��������: " << name << "  ���� �������: " << date << " �." << "  ���������� ����������� ���:" << amount << endl;
	cout << "���� � �������: " << endl;
	if (niduses.size() > 0)
	{
		for (int i = 0; i < niduses.size(); i++)
		{
			cout << "  ���� �" << i+1 << " ";
			niduses[i].printNiduses();
		}
	}
	else cout << "������� ����!" << endl;
	cout << endl;
	}

	//����� ������ ���������� � �������, ��� ���
	void printS()
	{
		cout << "    �����: " << autor << "  ��������: " << name << "  ���� �������: " << date << " �." << "  ���������� ����������� ���:" << amount << endl;
		cout << endl;
	}

	//����� ������ ��� � �������
	void printPars()
	{
		if (niduses.size() > 0)
		{
			for (int i = 0; i < niduses.size(); i++)
			{
				cout << "  ���� �" << i+1 << " ";
				niduses[i].printNiduses();
			}
		}
		else cout << "������� ����!" << endl;
		cout << endl;
	}

	//���������� ������ � �������
	void AddPars()
	{
		cout << endl << "���������� ����� ���� � �������" << endl;
		Nidus p;
		string e, r;
		cout << "������� ������ �������� �� ����������: ";
		//e = getchar();
		//getline(cin, p.en);
		cin >> p.en;
		cout << "������� ������ �������� �� �������: ";
		//r = getchar();
		//getline(cin, p.ru);
		cin >> p.ru;
		int flag = 1;
		for (int i = 0; i < niduses.size(); i++)
		{
			if ((niduses[i].en == p.en) or (niduses[i].ru == p.ru))
			{
				cout << "� ��� ��� ������� ������ �������� ��� ������� " << i+1  << " - " << niduses[i].en << " = "<< niduses[i].ru<<". ������ �������� ����? (Y/N)";
				if (YNflag() == '1') {
					cout << "������� ����� �������� �� ����������: ";
					cin >> p.en;
					niduses[i].en = p.en;
					cout << "������� ����� �������� �� �������: ";
					cin >> p.ru;
					niduses[i].ru = p.ru;
					flag = 0;
					break;
				}
			}
		}
		if (flag == 1)
		{
			niduses.push_back(p);
		}
		cout << "���� ��������� � �������!" << endl;
		cout << endl;
	}


	//�������� ������ � �������
	void DeletePars()
	{
		cout << endl << "�������� ��� �� �������" << endl;
		cout << "������� ������ ���? <Y/N>: ";
		if (YNflag() == '1')
		{
			printPars();
		}
		Nidus p;
		char c;
		//���� ��������
		char flag = '1';
		//����� ���� � �������
		int num;
		while (flag == '1')
		{
			c = getchar();
			cout << "������� ����� ����, ������� ������ �������: ";		
			num = CheckNumNiduses(niduses);
			for (int i = 0; i < niduses.size(); i++)
			{
				if (i == num)
				{
					flag = '0';
					niduses.erase(niduses.begin() + i);
					vector<Nidus>(niduses).swap(niduses);
					cout << "���� ������� �������!" << endl;
					break;
				}
			}
			if (flag != '0')
				cout << "���� �� �������! ���������� ��� ���!" << endl;
		}
		cout << endl;
	}

	//����� ����� � ������� �������
	int SearchWord() 
	{
		string naidi;
		cout << "������� ��������, ������� ������ �����: ";
		cin >> naidi; 
		for (int i = 0; i < niduses.size(); i++)
		{
			if (naidi == niduses[i].ru)
			{
				cout << "�������� ������� �� ������� �����, ����� ������: " << i+1 << endl;
				return i;
				break;
			}
			if (naidi == niduses[i].en)
			{
				cout << "�������� ������� �� ���������� �����, ����� ������: " << i+1 << endl;
				return i;
				break;
			}
		}
		cout << endl;
		return 0;
	}

	//������������� �������� � ������� �� ������ �����----------------------------------------------------------------------------------------------------------------------------------------------------
	void SortNiduses() 
	{
		cout << "���������� ������� �� ������ ����� ��������. ���� ������� ������������� �� ������� ���������, ������� 1, ���� �� ����������, ������� 2, � ����� ������ ��������, ���� ������ �����: ";
		int choise;
		cin >> choise;
		if (choise == 1) {
			sort(niduses.begin(), niduses.end(), SortCompareNidusRu);
		}
		if (choise == 2) {
			sort(niduses.begin(), niduses.end(), SortCompareNidusEn);
		}
	}

	vector <Nidus> NidusesToSend()
	{
		vector <Nidus> nidusesToSendList;
		//������� ������ ��� � ��������� �������� ���
		cout << "������� ������ ��� ��� ������ ������������ ���? <Y/N> (���� ��� - ����� ���������� ��� ����): ";
		if (YNflag() == '1')
		{
			printPars();
			cout << "������� ������ ��������� ��� ��� ��������: ";
			int zn1;
			zn1 = CheckNumNiduses(niduses);
			cout << "������� ����� ��������� ��� ��� ��������: ";
			int zn2;
			zn2 = CheckNumNiduses(niduses);

			for (int i = 0; i < niduses.size(); i++)
			{
				if ((i > zn1) and (i < zn2))
				{
					nidusesToSendList.push_back(niduses[i]);
					niduses.erase(niduses.begin() + i);
					vector<Nidus>(niduses).swap(niduses);
				}
			}
		}
		else {
			for (int i = 0; i < niduses.size(); i++) {
				nidusesToSendList.push_back(niduses[i]);
				niduses.erase(niduses.begin() + i);
				vector<Nidus>(niduses).swap(niduses);
			}
		}
		return nidusesToSendList;
	}

	int GetDictionaryInfo()	
	{
		if (niduses.size() > 0)
			return 1;
		return 0;
	}

	//���������� ��������
	void operator+(Dictionary &S2)
	{
		for (int i = 0; i < S2.niduses.size(); i++)
		{
			niduses.push_back(S2.niduses[i]);
		}
		//������ ������������� ������������� �������
		//this->autor = S2.autor;
		//this->name = S2.name;
		//this->amount = S2.amount;
		//this->date = S2.date;
	}
	friend ofstream& operator <<(ofstream& out, Dictionary& obj)
	{

		out << obj.autor << " " << obj.name << " " << obj.date << " " << obj.amount << endl;
		for (int i = 0; i < obj.amount; i++) {
			out << obj.niduses[i].en << " " << obj.niduses[i].ru << endl;
		}
		return out;
	}


	friend ifstream& operator >>(ifstream& in, Dictionary& obj)
	{
		in >> obj.autor >> obj.name >> obj.date >> obj.amount;
		Nidus temp;
		for (int i = 0; i < obj.amount; i++) {
			in >> temp.en >> temp.ru;
			obj.niduses.push_back(temp);
		}
		return in;
	}
	
};


//----------------------------�������--------------------------
int CheckNumNiduses(vector <Nidus> Paras)
{
	int flag = 1;
	int num;
	while (flag == 1)
	{
		cin >> num;
		if ((num - 1 <= Paras.size()) && (num > 0))
		{
			flag = 0;
			return num - 1;
		}
		else cout << "������! ����� ���� �� ����������. ������� ������: " << endl;
	}
	return num - 1;
}

int CheckNum(vector <Dictionary> Dictionaries)
{
	int flag = 1;
	int num;
	while (flag == 1)
	{
		cin >> num;
		if ((num - 1 <= Dictionaries.size()) && (num > 0))
		{
			flag = 0;
			return num - 1;
		}
		else cout << "������! ������ ������� �� ����������. ������� ������: " << endl;
	}
	return num - 1;
}

//����� ������ ��������
void PrintDictionaries(vector <Dictionary> Dictionaries)
{
	int i = 0;
	cout << endl << "������ ��������� ��������: " << endl;
	if (Dictionaries.size() != 0)
	{
		for (i; i < Dictionaries.size(); i++)
		{
			cout << i+1 << ". ";
			Dictionaries[i].printS();
			cout << endl;
		}
		//cout << endl;
	}
	else cout << "�� ������ ������ �� ������ ������� � �� ���" << endl << endl;
}

//��������� ������ �������
void CreateDictionary(vector <Dictionary>& Dictionaries)
{
	cout << endl << "���������� ������ ������� � ��" << endl;
	string name, autor;
	int date, amount;
	cout << "������� ������� ������: ";
	cin >> autor;
	cout << "������� ������������ �������: ";
	cin >> name;
	cout << "������� ��� ������� �������: ";
	cin >> date;
	cout << "������� ���������� ��� � �������: ";
	cin >> amount;
	Dictionary s(autor, name, date, amount);
	Dictionaries.push_back(s);
	cout << "��� ������ ������� " << name << endl; 
	cout << endl;
}

//�������� �������
void DeleteDictionary(vector <Dictionary>& Dictionaries)
{
	cout << endl << "�������� ������� �� ��" << endl;
	cout << "������� ������ ��������? <Y/N>?: ";
	if (YNflag() == '1')
	{
		PrintDictionaries(Dictionaries);
	}
	char flag = '1';
	int num;
	while (flag == '1')
	{
		cout << "������� ����� �������, ������� ������ ������� �� �� ��� ������� 0 ����� ������� � ����: ";
		cin >> num;
		if ((num - 1 <= Dictionaries.size()) && (num > 0))
		{
			if (Dictionaries[num - 1].GetDictionaryInfo() >= 1)
			{
				cout << "� ������� ������� ����. �� ����� �������? <Y/N>?: ";
				if (YNflag() == '1')
				{
					Dictionaries.erase(Dictionaries.begin() + num - 1);
					vector<Dictionary>(Dictionaries).swap(Dictionaries);
					flag = '0';
					cout << "����� � ����..." << endl;
				}
				flag = '0';
				cout << "����� � ����..." << endl;
			}
			else
			{
				Dictionaries.erase(Dictionaries.begin() + num - 1);
				vector<Dictionary>(Dictionaries).swap(Dictionaries);
				flag = '0';
				//cout << "����� � ����..." << endl;
			}
		}
		else
		{
			if (num == 0)
			{
				flag = '0';
				cout << "����� � ����..." << endl;
			}
			else cout << "������! ������ ������� � �� �� ����������" << endl;
		}
	}
}

//������ � �������� ������ ��������
void ChangeDictionary(vector <Dictionary> & Dictionaries)
{
	cout << endl << "��������� ������ ������ �������" << endl;
	cout << "������� ������ �������� <Y/N>?: ";
	if (YNflag() == '1')
	{
		PrintDictionaries(Dictionaries);
	}
	//����� ������
	int num;
	cout << "������� ����� �������: ";
	num = CheckNum(Dictionaries);
	int flag = 1;
	int flagMenu = 1;
	int flagMenuIn = -1;
	while (flag != 0)
	{
		cout << "�������� � ���������: " << endl;
		cout << "1. ����������� ������ ��� � �������" << endl;
		cout << "2. �������� ����� ����" << endl;
		cout << "3. ������ ���� �� �������" << endl;
		cout << "4. ����� �������� � �������" << endl;
		cout << "5. ������������� �������� � ������� �� ������ �����" << endl;
	
		cout << "6. ����� � ������� ����" << endl;
		cout << "�������� ����� ���� (1|2|3|4|5|6): ";
		cin >> flagMenuIn;
		switch (flagMenuIn)
		{
			//����������� ������ ��� � �������
		case 1:
			Dictionaries[num].printPars();
			break;
			//�������� �����  ����
		case 2:
			Dictionaries[num].AddPars();
			break;
			//������ ���� �� �������
		case 3:
			Dictionaries[num].DeletePars();
			break;
			//����� �������� � �������
		case 4:
			Dictionaries[num].SearchWord();
			break;
			//������������� �������� � ������� �� ������ �����
		case 5:
			Dictionaries[num].SortNiduses();
			break;
			//����� � ������� ����
		case 6:
			flag = 0;
			cout << endl;
			break;
		default:
			cout << "������ �����! ������ ������ �� ����������!" << endl;
			break;
		}
	}
}


void MergeDictionaries(vector <Dictionary> & Dictionaries)
{
	cout << endl << "����������� ���� ��������" << endl;
	cout << "������� ������ ��������? <Y/N>: ";
	if (YNflag() == '1')
	{
		PrintDictionaries(Dictionaries);
	}
	//����� ������� �������
	int num1;
	cout << "������� ����� ������� �������: ";
	num1 = CheckNum(Dictionaries);
	//����� ������� �������
	int num2;
	cout << "������� ����� ������� �������: ";
	num2 = CheckNum(Dictionaries);
	Dictionaries[num1] + Dictionaries[num2];
	Dictionaries.erase(Dictionaries.begin() + num2);
	vector<Dictionary>(Dictionaries).swap(Dictionaries);
	cout << "����������� �������� ������� ���������!" << endl << endl;
}

void SeparateDictionaries(vector <Dictionary>& Dictionaries) 
{
	cout << endl << "�������� ������ ������� �� ������ �������(����������)" << endl;
	cout << "������� ������ ��������? <Y/N>: ";
	if (YNflag() == '1')
	{
		PrintDictionaries(Dictionaries);
	}
	//����� ������� �������
	int num;
	cout << "������� ����� ������������ �������: ";
	num = CheckNum(Dictionaries);
	string name, autor;
	int date, amount;
	cout << "������� �������������� ������ �������: " << endl;
	cout << "������� ������� ������: ";
	cin >> autor;
	cout << "������� ������������ �������: ";
	cin >> name;
	cout << "������� ��� ������� �������: ";
	cin >> date;
	cout << "������� ���������� ��� � �������: ";
	cin >> amount;
	Dictionary s(autor, name,  date,  amount, Dictionaries[num].NidusesToSend());
	Dictionaries.push_back(s);
	cout << "��� ������ ����� �������: " << name << endl;
	cout << endl;
}

void ReadFromFile(vector <Dictionary>& Dictionaries)
{
	Dictionaries.clear();
	string filename;
	cout << "������� �������� ������ �����: ";
	cin >> filename;
	ifstream in(filename);
	int count;
	//cout << "������� ���������� �������� � �����";
	in >> count;
	Dictionary temp;
	for (int i = 0; i < count; i++) 
	{
		in >> temp;
		Dictionaries.push_back(temp);
	}
	cout << endl;
}

void WriteToFile(vector <Dictionary>& Dictionaries)
{
	string filename;
	cout << "������� �������� ������ ����� ��� ������: ";
	cin >> filename;
	ofstream out(filename);
	out << Dictionaries.size() << endl;
	for (int i = 0; i < Dictionaries.size(); i++)
	{
		out << Dictionaries[i];
	}
	cout << endl;
	Dictionaries.clear();

}

//YES-NO flag
char YNflag()
{
	char c = '0';
	char r;
	char flag = '1';
	while (flag == '1')
	{
		cin >> c;
		if (c == 'N')
		if (c == 'N')
		{
			flag = '0';
			r = '0';
		}
		else {
			if (c == 'Y')
			{
				flag = '0';
				r = '1';
			}
			else cout << "������! ������� ������ ��������� Y(es) ��� N(o): ";
		}
	}
	return r;
}