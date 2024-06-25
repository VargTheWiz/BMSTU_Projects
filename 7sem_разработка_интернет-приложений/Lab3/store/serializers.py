from store.models import Genres, Items, Order, User
from rest_framework import serializers
from rest_framework.fields import CharField


class GenresSerializer(serializers.ModelSerializer):
    class Meta:
        model = Genres
        fields = '__all__'


class ItemsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Items
        fields = '__all__'


class ItemsDepthSerializer(serializers.ModelSerializer):
    class Meta:
        model = Items
        fields = '__all__'
        depth = 2


class OrdersSerializer(serializers.ModelSerializer):
    class Meta:
        model = Order
        fields = '__all__'


class OrdersDepthSerializer(serializers.ModelSerializer):
    class Meta:
        model = Order
        fields = '__all__'
        depth=2


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = "__all__"


class LoginRequestSerializer(serializers.Serializer):
    model = User
    username = CharField(required=True)
    password = CharField(required=True)
