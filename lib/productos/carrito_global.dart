import 'package:flutter/material.dart';

class CarritoGlobal {
  static final ValueNotifier<List<Map<String, dynamic>>> _itemsNotifier =
      ValueNotifier<List<Map<String, dynamic>>>([]);

  static ValueNotifier<List<Map<String, dynamic>>> get itemsNotifier => _itemsNotifier;

  static List<Map<String, dynamic>> get items => _itemsNotifier.value;

  static void agregarProducto({
    required int id, // 👈 nuevo campo
    required String nombre,
    required String imagen,
    required String precio,
    required int cantidad,
    required Map<String, String> atributos,
  }) {
    final nuevoItem = {
      'id': id, // 👈 lo guardamos en el carrito
      'nombre': nombre,
      'imagen': imagen,
      'precio': precio,
      'cantidad': cantidad,
      'atributos': atributos,
    };

    _itemsNotifier.value = [..._itemsNotifier.value, nuevoItem];
  }

  static void eliminarProducto(int index) {
    final copia = [..._itemsNotifier.value];
    copia.removeAt(index);
    _itemsNotifier.value = copia;
  }

  static int totalItems() {
    return _itemsNotifier.value.fold(0, (total, item) => total + item['cantidad'] as int);
  }

  static double totalPrecio() {
    return _itemsNotifier.value.fold(0.0, (total, item) {
      final precio = double.tryParse(item['precio'].toString()) ?? 0;
      return total + (precio * item['cantidad']);
    });
  }
}
