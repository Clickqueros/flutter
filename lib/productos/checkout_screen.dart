import 'package:flutter/material.dart';
import 'package:woocommerce_api/woocommerce_api.dart';
import 'carrito_global.dart';
import 'appbar_con_carrito.dart';
import 'woo_api_service.dart';

class CheckoutScreen extends StatefulWidget {
  final WooCommerceAPI wooAPI;

  const CheckoutScreen({super.key, required this.wooAPI});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  // Campos del formulario
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _correoController = TextEditingController();

  void confirmarPedido(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final productos = CarritoGlobal.items;

    final datosCliente = {
      'first_name': _nombreController.text.trim(),
      'last_name': _apellidoController.text.trim(),
      'address_1': _direccionController.text.trim(),
      'city': _ciudadController.text.trim(),
      'state': 'CUN',
      'postcode': '000000',
      'country': 'CO',
      'email': _correoController.text.trim(),
      'phone': _telefonoController.text.trim(),
    };

    final apiService = WooAPIService(widget.wooAPI);

    final exito = await apiService.crearOrden(productos, datosCliente);

    if (exito) {
      CarritoGlobal.itemsNotifier.value = [];

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Orden creada exitosamente en WooCommerce!')),
      );

      Navigator.popUntil(context, ModalRoute.withName('/'));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al crear la orden. Intenta de nuevo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = CarritoGlobal.items;
    final total = CarritoGlobal.totalPrecio();
    final cantidadTotal = CarritoGlobal.totalItems();

    return Scaffold(
      appBar: AppBarConCarrito(titulo: 'Checkout'),
      body: items.isEmpty
          ? const Center(child: Text('Tu carrito está vacío'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Datos del Cliente',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nombreController,
                          decoration: const InputDecoration(labelText: 'Nombre'),
                          validator: (value) =>
                              value!.isEmpty ? 'Ingrese su nombre' : null,
                        ),
                        TextFormField(
                          controller: _apellidoController,
                          decoration: const InputDecoration(labelText: 'Apellido'),
                          validator: (value) =>
                              value!.isEmpty ? 'Ingrese su apellido' : null,
                        ),
                        TextFormField(
                          controller: _direccionController,
                          decoration: const InputDecoration(labelText: 'Dirección'),
                          validator: (value) =>
                              value!.isEmpty ? 'Ingrese su dirección' : null,
                        ),
                        TextFormField(
                          controller: _ciudadController,
                          decoration: const InputDecoration(labelText: 'Ciudad'),
                          validator: (value) =>
                              value!.isEmpty ? 'Ingrese su ciudad' : null,
                        ),
                        TextFormField(
                          controller: _telefonoController,
                          decoration: const InputDecoration(labelText: 'Teléfono'),
                          validator: (value) =>
                              value!.isEmpty ? 'Ingrese su teléfono' : null,
                          keyboardType: TextInputType.phone,
                        ),
                        TextFormField(
                          controller: _correoController,
                          decoration: const InputDecoration(labelText: 'Correo electrónico'),
                          validator: (value) =>
                              value!.isEmpty || !value.contains('@')
                                  ? 'Correo inválido'
                                  : null,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Resumen del pedido:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    itemCount: items.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      final item = items[index];
                      final subtotal = (double.tryParse(item['precio']) ?? 0) *
                          item['cantidad'];

                      return ListTile(
                        title: Text(item['nombre']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cantidad: ${item['cantidad']}'),
                            if (item['atributos'] != null && item['atributos'].isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  item['atributos'].entries.map((e) => '${e.key}: ${e.value}').join(', '),
                                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                        trailing: Text('\$${subtotal.toStringAsFixed(2)}'),
                      );
                    },
                  ),
                  const Divider(),
                  Text('Total de artículos: $cantidadTotal'),
                  Text('Total a pagar: \$${total.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text('Confirmar pedido'),
                      onPressed: () => confirmarPedido(context),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
