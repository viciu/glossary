from django.contrib import admin
from .models import Tumaczenie, Okrelenie, Jzyk
# Register your models here.

admin.site.register(Jzyk)
admin.site.register(Okrelenie)
admin.site.register(Tumaczenie)
