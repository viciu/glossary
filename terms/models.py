# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey has `on_delete` set to the desired behavior.
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Jzyk(models.Model):
    id = models.AutoField(primary_key=True)
    nazwa = models.CharField(max_length=255)
    kod_iso = models.CharField(max_length=2)

    class Meta:
        managed = False
        db_table = 'język'

    def __str__(self):
        return "{} {} {}".format(self.id, self.nazwa, self.kod_iso)


class Okrelenie(models.Model):
    id = models.AutoField(primary_key=True)
    nazwa = models.CharField(max_length=255)
    definicja = models.TextField(blank=True, null=True)
    język = models.ForeignKey(Jzyk, models.DO_NOTHING, db_column='język')

    class Meta:
        managed = False
        db_table = 'określenie'

    def __str__(self):
        return "{} {} {}".format(self.id, self.nazwa, self.język.kod_iso)


class Tumaczenie(models.Model):
    id = models.AutoField(primary_key=True)
    źródło = models.ForeignKey(Okrelenie, models.DO_NOTHING, db_column='źródło', related_name='source_translations')
    cel = models.ForeignKey(Okrelenie, models.DO_NOTHING, db_column='cel', related_name='destination_traslations')

    class Meta:
        managed = False
        db_table = 'tłumaczenie'
        unique_together = (('źródło', 'cel'),)

    def __str__(self):
        return "{} {} ({}) {} ({})".format(
            self.id, self.źródło.nazwa, self.źródło.język.kod_iso, self.cel.nazwa, self.cel.język.kod_iso)
