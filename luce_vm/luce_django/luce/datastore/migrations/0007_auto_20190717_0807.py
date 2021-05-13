# Generated by Django 2.2 on 2019-07-17 08:07

from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('datastore', '0006_auto_20190717_0806'),
    ]

    operations = [
        migrations.AlterField(
            model_name='dataset',
            name='access_granted',
            field=models.ManyToManyField(related_name='datasets_accessible', to=settings.AUTH_USER_MODEL),
        ),
    ]
