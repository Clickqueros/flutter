import 'package:flutter/material.dart';
import 'package:woocommerce_api/woocommerce_api.dart';
import 'carrito_global.dart';
import 'appbar_con_carrito.dart';
import 'checkout_screen.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  void eliminarItem(int index) {
    setState(() {
      CarritoGlobal.items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = CarritoGlobal.items;

    return Scaffold(
      appBar: AppBarConCarrito(titulo: 'Mi Carrito'),
      body: items.isEmpty
          ? const Center(child: Text('Tu carrito está vacío'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, index) {
                      final item = items[index];
                      final precioUnitario = double.tryParse(item['precio']) ?? 0;
                      final subtotal = precioUnitario * item['cantidad'];

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: item['imagen'] != null
                              ? Image.network(
                                  item['imagen'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image),
                          title: Text(item['nombre']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Cantidad: ${item['cantidad']}'),
                              Text('Precio unitario: \$${precioUnitario.toStringAsFixed(2)}'),
                              Text('Subtotal: \$${subtotal.toStringAsFixed(2)}'),
                              if (item['atributos'] != null && item['atributos'].isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    item['atributos'].entries.map((e) => '${e.key}: ${e.value}').join(', '),
                                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => eliminarItem(index),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$${CarritoGlobal.totalPrecio().toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.payment),
                          label: const Text('Proceder al checkout'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CheckoutScreen(
                                  wooAPI: WooCommerceAPI(
                                    url: "https://clickqueros.com",
                                    consumerKey:
                                        "ck_7d11fc71e62cf84844e1e3504871303d881f4d02",
                                    consumerSecret:
                                        "cs_d1d89a7b67fe75d77cfecf29518e1d0143beca60",
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
