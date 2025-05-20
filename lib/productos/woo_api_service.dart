import 'package:woocommerce_api/woocommerce_api.dart';

class WooAPIService {
  final WooCommerceAPI wooAPI;

  WooAPIService(this.wooAPI);

  Future<bool> crearOrden(
    List<Map<String, dynamic>> productos,
    Map<String, dynamic> cliente,
  ) async {
    try {
      List<Map<String, dynamic>> lineItems = [];

      for (var p in productos) {
        final int productId = p['id'];
        final int cantidad = p['cantidad'];
        final Map<String, String> atributos = Map<String, String>.from(p['atributos'] ?? {});
        int? variationId;

        // Buscar variación si hay atributos
        if (atributos.isNotEmpty) {
          final variaciones = await wooAPI.getAsync("products/$productId/variations");

          for (var variacion in variaciones) {
            final attrs = variacion['attributes'] as List;
            bool coincide = true;

            for (var attr in attrs) {
              final nombre = attr['name'];
              final valor = attr['option'];
              if (atributos[nombre] != valor) {
                coincide = false;
                break;
              }
            }

            if (coincide) {
              variationId = variacion['id'];
              break;
            }
          }
        }

        // Construcción del meta_data a partir de atributos
        final metaData = atributos.entries.map((e) {
          return {
            'key': e.key,
            'value': e.value,
          };
        }).toList();

        // Agregar al line_items
        final item = {
        'product_id': productId,
        'quantity': cantidad,
        if (variationId != null) 'variation_id': variationId,
        if (variationId == null && metaData.isNotEmpty) 'meta_data': metaData,
        };

        lineItems.add(item);
      }

      // Construir orden completa
      final order = {
        'payment_method': 'cod',
        'payment_method_title': 'Pago contra entrega',
        'set_paid': true,
        'billing': cliente,
        'shipping': cliente,
        'line_items': lineItems,
      };

      final response = await wooAPI.postAsync('orders', order);

      return response != null && response['id'] != null;
    } catch (e) {
      print('Error al crear orden: $e');
      return false;
    }
  }
}
