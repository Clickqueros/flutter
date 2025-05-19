import 'package:flutter/material.dart';

class ProductoDetalle extends StatefulWidget {
  final Map producto;

  const ProductoDetalle({required this.producto});

  @override
  State<ProductoDetalle> createState() => _ProductoDetalleState();
}

class _ProductoDetalleState extends State<ProductoDetalle> {
  int cantidad = 1;
  Map<String, String> seleccionados = {};

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;
    final atributos = producto['attributes'] ?? [];
    final tipo = producto['type'];

    return Scaffold(
      appBar: AppBar(title: Text(producto['name'] ?? 'Detalle')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (producto['images'] != null && producto['images'].isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  producto['images'][0]['src'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 20),
            Text(producto['name'] ?? '', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
              producto['price'] != null ? '\$${producto['price']}' : 'Sin precio',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 20),

            // Atributos (solo si es variable)
            if (tipo == 'variable')
              ...atributos.map<Widget>((attr) {
                final nombre = attr['name'];
                final opciones = List<String>.from(attr['options']);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nombre, style: TextStyle(fontWeight: FontWeight.w600)),
                    DropdownButton<String>(
                      value: seleccionados[nombre],
                      hint: Text("Seleccionar $nombre"),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() => seleccionados[nombre] = value!);
                      },
                      items: opciones.map((op) {
                        return DropdownMenuItem(value: op, child: Text(op));
                      }).toList(),
                    ),
                  ],
                );
              }).toList(),

            SizedBox(height: 20),

            // Campo de cantidad
            Row(
              children: [
                Text("Cantidad:"),
                SizedBox(width: 12),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (cantidad > 1) setState(() => cantidad--);
                  },
                ),
                Text('$cantidad', style: TextStyle(fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => setState(() => cantidad++),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Botón agregar al carrito (sin lógica aún)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Aquí se podría implementar la lógica de agregar al carrito con WooCommerce
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Producto agregado al carrito (demo)")),
                  );
                },
                icon: Icon(Icons.shopping_cart),
                label: Text("Agregar al carrito"),
              ),
            ),

            SizedBox(height: 20),
            Text(producto['description'] ?? '', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
