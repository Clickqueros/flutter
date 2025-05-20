import 'package:flutter/material.dart';
import 'carrito_global.dart';

class AppBarConCarrito extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final VoidCallback? onCarritoPressed;

  const AppBarConCarrito({required this.titulo, this.onCarritoPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(titulo),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: ValueListenableBuilder<List<Map<String, dynamic>>>(
            valueListenable: CarritoGlobal.itemsNotifier,
            builder: (context, items, _) {
              final totalItems = items.fold(0, (sum, item) => sum + item['cantidad'] as int);

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: onCarritoPressed ??
                        () {
                          Navigator.pushNamed(context, '/carrito');
                        },
                  ),
                  if (totalItems > 0)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          '$totalItems',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
