import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/candle.dart';
import 'package:flutter_application_1/presentations/providers/candle_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/widgets/main_menu.dart';

class AdminProductsScreen extends ConsumerWidget {
  const AdminProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(candleProvider);
    final candleProviderNotifier = ref.read(candleProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: products.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () {
                            print('Tapped on ${product.name}');
                          },
                          child: Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: Image.network(
                                product.imageUrl ?? 'https://via.placeholder.com/50',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                product.name,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '\$${product.price}',
                                style: const TextStyle(fontSize: 14, color: Colors.black54),
                              ),
                              trailing: Row( // Modificación aquí: Añadí una fila con botones de incremento y decremento
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () async {
                                      if (product.stock > 0) {
                                        final newStock = product.stock - 1;
                                        await candleProviderNotifier.updateCandleStock(product.id, newStock); // Modificación: Llamada al método para actualizar stock
                                      }
                                    },
                                  ),
                                  Text('${product.stock}'),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () async {
                                      final newStock = product.stock + 1;
                                      await candleProviderNotifier.updateCandleStock(product.id, newStock); // Modificación: Llamada al método para actualizar stock
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AddCandleDialog(
                        onAddCandle: (candle) {
                          candleProviderNotifier.addCandleWithImage(candle, 'path/to/image');
                        },
                      );
                    },
                  );
                },
                child: const Text('Agregar producto'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MainMenu(),
    );
  }
}

class AddCandleDialog extends StatefulWidget {
  final void Function(Candle) onAddCandle;

  const AddCandleDialog({Key? key, required this.onAddCandle}) : super(key: key);

  @override
  _AddCandleDialogState createState() => _AddCandleDialogState();
}

class _AddCandleDialogState extends State<AddCandleDialog> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String description = '';
  double price = 0.0;
  int stock = 0;
  String imageUrl = ''; // Puede ser un campo opcional

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar nuevo producto'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                onChanged: (value) => name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descripción'),
                onChanged: (value) => description = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                onChanged: (value) => price = double.tryParse(value) ?? 0.0,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'Por favor ingrese un precio válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                onChanged: (value) => stock = int.tryParse(value) ?? 0,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return 'Por favor ingrese un stock válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'URL de Imagen (opcional)'),
                onChanged: (value) => imageUrl = value,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newCandle = Candle(
                id: '', // El ID será generado en Firebase
                name: name,
                description: description,
                price: price,
                stock: stock,
                scentRef: FirebaseFirestore.instance.collection('scents').doc('default'), // Cambiar según tu lógica
                typeRef: FirebaseFirestore.instance.collection('types').doc('default'), // Cambiar según tu lógica
                imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
              );
              widget.onAddCandle(newCandle);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}