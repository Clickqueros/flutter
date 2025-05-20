import 'package:flutter/material.dart';
import 'appbar_con_carrito.dart';
import 'carrito_global.dart';
import 'package:woocommerce_api/woocommerce_api.dart';

class ProductoDetalle extends StatefulWidget {
  final Map producto;

  const ProductoDetalle({required this.producto, super.key});

  @override
  State<ProductoDetalle> createState() => _ProductoDetalleState();
}

class _ProductoDetalleState extends State<ProductoDetalle> {
  int cantidad = 1;
  Map<String, String> seleccionados = {};
  List variaciones = [];
  String? precioActual;

  @override
  void initState() {
    super.initState();
    if (widget.producto['type'] == 'variable') {
      cargarVariaciones();
    } else {
      precioActual = widget.producto['price'];
    }
  }

  Future<void> cargarVariaciones() async {
    try {
      final woo = WooCommerceAPI(
        url: "https://clickqueros.com",
        consumerKey: "ck_7d11fc71e62cf84844e1e3504871303d881f4d02",
        consumerSecret: "cs_d1d89a7b67fe75d77cfecf29518e1d0143beca60",
      );

      final id = widget.producto['id'];
      final response = await woo.getAsync("products/$id/variations");

      setState(() {
        variaciones = response;
        actualizarPrecio();
      });
    } catch (e) {
      print("Error al cargar variaciones: $e");
    }
  }

  void actualizarPrecio() {
    final seleccion = seleccionados;
    for (var variacion in variaciones) {
      final attrs = variacion['attributes'] as List;
      bool coincide = true;

      for (var attr in attrs) {
        final nombre = attr['name'];
        final valor = attr['option'];
        if (seleccion[nombre] != valor) {
          coincide = false;
          break;
        }
      }

      if (coincide) {
        setState(() {
          precioActual = variacion['price'];
        });
        return;
      }
    }

    setState(() {
      precioActual = widget.producto['price']; // default
    });
  }

  void agregarAlCarrito() {
    final producto = widget.producto;
    final atributos = producto['attributes'] ?? [];

    for (var atributo in atributos) {
      final nombre = atributo['name'];
      if (!seleccionados.containsKey(nombre)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor selecciona $nombre')),
        );
        return;
      }
    }

    final nombre = producto['name'] ?? 'Producto';
    final imagen = (producto['images'] != null && producto['images'].isNotEmpty)
        ? producto['images'][0]['src']
        : '';
    final id = producto['id'];
    final precio = precioActual ?? producto['price'] ?? '0';

    CarritoGlobal.agregarProducto(
      id: id,
      nombre: nombre,
      imagen: imagen,
      precio: precio,
      cantidad: cantidad,
      atributos: Map.from(seleccionados),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Agregado $cantidad x $nombre (\$$precio) al carrito')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;
    final atributos = producto['attributes'] ?? [];

    return Scaffold(
      appBar: AppBarConCarrito(titulo: producto['name'] ?? 'Detalle'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (producto['images'] != null && producto['images'].isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(producto['images'][0]['src']),
              ),
            const SizedBox(height: 16),
            Text(
              producto['name'] ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              precioActual != null ? '\$$precioActual' : '',
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 16),
            const Text('Cantidad:', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (cantidad > 1) setState(() => cantidad--);
                  },
                ),
                Text(cantidad.toString()),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() => cantidad++),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (atributos.isNotEmpty)
              ...atributos.map<Widget>((atributo) {
                final nombre = atributo['name'];
                final opciones = atributo['options'] ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8.0,
                      children: opciones.map<Widget>((opcion) {
                        final seleccionada = seleccionados[nombre] == opcion;
                        return ChoiceChip(
                          label: Text(opcion),
                          selected: seleccionada,
                          onSelected: (_) {
                            setState(() {
                              seleccionados[nombre] = opcion;
                              actualizarPrecio(); // 🔄 actualizar precio cuando selecciona
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              }).toList(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Agregar al carrito'),
                onPressed: agregarAlCarrito,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
