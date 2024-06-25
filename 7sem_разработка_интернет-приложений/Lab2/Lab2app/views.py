from django.shortcuts import render
from datetime import date
from Lab2app.models import Book


def bookList(request):
    return render(request, 'books.html', {'data' : {
        'current_date': date.today(),
        'books': Book.objects.all()
    }})


def GetBook(request, id):
    return render(request, 'book.html', {'data' : {
        'current_date': date.today(),
        'book': Book.objects.filter(id=id)[0]
    }})


def UslugiList(request):
    return render(request, 'uslugis.html', {'data' : {
        'current_date': date.today(),
        'uslugi': Uslugi.objects.all(),
        'uslugis_id': Uslugi.filter(id=id)[0]
    }})


def GetUslugi(request, id):
    return render(request, 'uslugi.html', {'data' : {
        'current_date': date.today(),
        'uslugi': Uslugi.objects.filter(id=id)[0]
    }})
