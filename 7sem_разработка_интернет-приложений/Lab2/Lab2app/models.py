from django.db import models


# Create your models here.


class Book(models.Model):
    name = models.CharField(max_length=30)
    description = models.CharField(max_length=255)
    uslugis_id = models.IntegerField

    class Meta:
        managed = False
        db_table = 'books'


class Uslugi(models.Model):
    name = models.CharField(max_length=30)
    description = models.CharField(max_length=255)
    facts_id = models.IntegerField

    class Meta:
        managed = False
        db_table = 'uslugis'


class Fact(models.Model):
    managerdicription = models.CharField(max_length=255)
    status = models.CharField(max_length=25)
    datecreated = models.DateField()
    dateshipped = models.DateField()
    dateclosed = models.DateField()

    class Meta:
        managed = False
        db_table = 'facts'




