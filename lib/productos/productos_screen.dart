import 'package:flutter/material.dart';
import 'package:woocommerce_api/woocommerce_api.dart';

class ProductosScreen extends StatefulWidget {
  @override
  _ProductosScreenState createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  late WooCommerceAPI wooCommerceAPI;
  List productos = [];

  @override
  void initState() {
    super.initState();
    // Configura la conexión con la API de WooCommerce
    wooCommerceAPI = WooCommerceAPI(
      url: "https://clickqueros.com",
      consumerKey: "ck_7d11fc71e62cf84844e1e3504871303d881f4d02",
      consumerSecret: "cs_d1d89a7b67fe75d77cfecf29518e1d0143beca60",
    );
    // Llama la función que obtiene los productos
    obtenerProductos();
  }

  // Función que consume la API y trae la lista de productos
  Future<void> obtenerProductos() async {
    try {
      var response = await wooCommerceAPI.getAsync("products");
      setState(() {
        productos = response;
      });
    } catch (e) {
      print("Error al obtener productos: $e");
    }
  }

  // Construye el widget que muestra el precio con o sin rebaja o mínimo en productos variables
  Widget _buildPrecio(producto) {
    final regular = producto['regular_price'];
    final sale = producto['sale_price'];
    final price = producto['price'];

    // Si es variable y no hay regular/sale, usar price
    if ((regular == null || regular.isEmpty) && (sale == null || sale.isEmpty)) {
      return Text(
        '\$${price ?? 'Sin precio'}',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      );
    }

    if (sale != null && sale.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\$${regular}',
            style: TextStyle(
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
            ),
          ),
          Text(
            '\$${sale}',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      );
    } else {
      return Text(
        '\$${regular ?? 'Sin precio'}',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Productos"),
        actions: [
          // Botón de recarga manual de productos
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: obtenerProductos,
          ),
        ],
      ),
      body: productos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(12),
              itemCount: productos.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                var producto = productos[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Imagen del producto
                        Expanded(
                          child: producto['images'] != null && producto['images'].isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    producto['images'][0]['src'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                )
                              : Icon(Icons.image_not_supported, size: 60),
                        ),
                        SizedBox(height: 8),
                        // Nombre del producto
                        Text(
                          producto['name'] ?? 'Sin nombre',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4),
                        // Precio o rebaja
                        _buildPrecio(producto),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}