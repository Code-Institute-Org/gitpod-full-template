from django.urls import path
from newsdisplay import views

urlpatterns = [
    path("", views.home, name="home"),
]