from django.shortcuts import render
from django.http import HttpResponse

"""def hello(request):
    return HttpResponse('Hello world!aasdgfagsdfasdgfasfd')"""

"""def hello(request):
    return render(request, 'index.html')"""

from datetime import date


def hello(request):
    return render(request, 'index.html', {'data': {
        'current_date': date.today(),
        'list': ['python', 'django', 'html'],
        'list2': ['alpha', 'beta', 'gamma']
    }})


def GetOrders(request):
    return render(request, 'orders.html', {'data': {
        'current_date': date.today(),
        'orders': [
            {'title': 'Приключения Нильса', 'id': 1},
            {'title': 'Гарри Поттер и Философский Камень', 'id': 2},
            {'title': 'Айвенго', 'id': 3},
            {'title': 'Sufficiently Advanced Magic', 'id': 4},
            {'title': 'Harry Potter and Methods of Rationality', 'id': 5},
            {'title': 'The Wandering Inn', 'id': 6},
            {'title': 'Lord of the Mysteries', 'id': 7},
            {'title': 'Paranoid Mage', 'id': 8},
            {'title': 'Mother Of Learning', 'id': 9},
            {'title': 'Астровитянка', 'id': 10},
            {'title': 'The Color of Magic', 'id': 11},
            {'title': 'The Name of The Wind', 'id': 12},
            {'title': 'The Golem’s Eye', 'id': 13},  # U+2019 (RIGHT SINGLE QUOTATION MARK) instead U+0027 (APOSTROPHE)
            {'title': 'Роза и Червь', 'id': 14},
            {'title': 'Юнона', 'id': 15},
            {'title': 'The Martianin', 'id': 16},
            {'title': 'Morningwood', 'id': 17},  # please do not consider reading that.
        ]
    }})


def GetOrder(request, id):
    return render(request, 'order.html', {'data': {
        'current_date': date.today(),
        'id': id,
        'orders': [
            {'title': 'Приключения Нильса', 'id': 1, 'author': 'Selma Lagerlöf', 'pathtopic': '/nils.jpg'},
            {'title': 'Гарри Поттер и Философский Камень', 'id': 2, 'author': 'J. K. Rowling', 'pathtopic': '/2.jpg'},
            {'title': 'Айвенго', 'id': 3, 'author': 'Walter Scott', 'pathtopic': '/3.jpg'},
            {'title': 'Sufficiently Advanced Magic', 'id': 4, 'author': 'Salaris', 'pathtopic': '/4.jpg'},
            {'title': 'Harry Potter and Methods of Rationality', 'id': 5, 'author': 'Eliezer Yudkowsky', 'pathtopic': '/5.jpg'},
            {'title': 'The Wandering Inn', 'id': 6, 'author': 'PirateAba', 'pathtopic': '/6.jpg'},
            {'title': 'Lord of the Mysteries', 'id': 7, 'author': 'Cuttlefish That Loves Diving', 'pathtopic': '/7.jpg'},
            {'title': 'Paranoid Mage', 'id': 8, 'author': 'Inadvisably Compelled', 'pathtopic': '/8.jpg'},
            {'title': 'Mother Of Learning', 'id': 9, 'author': 'nobody113', 'pathtopic': '/9.jpg'},
            {'title': 'Астровитянка', 'id': 10, 'author': 'Николай Горькавый', 'pathtopic': '/10.jpg'},
            {'title': 'The Color of Magic', 'id': 11, 'author': 'Terry Pratchett', 'pathtopic': '/11.jpg'},
            {'title': 'The Name of The Wind', 'id': 12, 'author': 'Patrick Rothfuss', 'pathtopic': '/12.jpg'},
            {'title': 'The Amulet of Samarkand', 'id': 13, 'author': 'Jonathan Stroud', 'pathtopic': '/13.jpg'},  # U+2019 (RIGHT SINGLE QUOTATION MARK) instead U+0027 (APOSTROPHE)
            {'title': 'Роза и Червь', 'id': 14, 'author': 'Роберт Ибатуллин', 'pathtopic': '/14.jpg'},
            {'title': 'Юнона', 'id': 15, 'author': 'Виктория Воробьева', 'pathtopic': '/15.jpg'},  # no pic so be it
            {'title': 'The Martianin', 'id': 16, 'author': 'Andy Weir', 'pathtopic': '/16.jpg'},
            {'title': 'Morningwood', 'id': 17, 'author': 'Nevan Iliev', 'pathtopic': '/17.jpg'},  # please do not consider reading that.
        ]
    }})


def sendText(request):
    input_text = request.POST['text']
    return render(request, 'orders.html')
    #return render(request, 'orders.html'+'?input_text='+input_text)
# Create your views here.
"""
from django.http import HttpResponse

def hello(request):
    return HttpResponse('Hello world!')
"""
