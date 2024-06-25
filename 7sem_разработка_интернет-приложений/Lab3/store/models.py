from django.db import models
from django.contrib.auth.models import User


class Genres(models.Model):
    id_genre = models.AutoField(primary_key=True)
    title = models.CharField(max_length=50, blank=True, null=True)

    class Meta:
        managed = True     
        db_table = 'genres'


class Items(models.Model):
    id_item = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100)
    price = models.FloatField()
    description = models.CharField(max_length=1024, blank=True, null=True)
    genre = models.ForeignKey(Genres, on_delete=models.DO_NOTHING)
    photo = models.ImageField(default=None)
    author = models.CharField(max_length=128)

    class Meta:
        managed = True    
        db_table = 'items'


class Order(models.Model):
    item = models.ForeignKey(Items, on_delete=models.DO_NOTHING)
    customer = models.ForeignKey(User, on_delete=models.DO_NOTHING)
    status = models.TextField()
    order_date = models.DateTimeField()
    newDate = models.DateTimeField(null=True)

    class Meta:
        managed = True
        db_table = 'orders'
