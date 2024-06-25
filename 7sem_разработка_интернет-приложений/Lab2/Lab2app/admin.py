from django.contrib import admin

# Register your models here.
from .models import Book
from .models import Uslugi
from .models import Fact

admin.site.register(Book)
admin.site.register(Uslugi)
admin.site.register(Fact)