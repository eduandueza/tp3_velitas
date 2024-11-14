import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/candle.dart';
import 'package:flutter_application_1/domain/candle_type.dart';
import 'package:flutter_application_1/presentations/providers/candle_provider.dart';
import 'package:flutter_application_1/presentations/providers/candle_type_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/widgets/main_menu.dart';

class AdminProductsScreen extends ConsumerWidget {
  const AdminProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchar los productos de candleProvider
    final products = ref.watch(candleProvider);
    final candleProviderNotifier = ref.read(candleProvider.notifier);
    
    // Escuchar los tipos de vela disponibles desde el candleTypeProvider
    final candleTypes = ref.watch(candleTypeProvider); // Lista de tipos de vela disponibles
    // Escuchar el tipo de vela seleccionado desde el selectedCandleTypeProvider
    final selectedType = ref.watch(selectedCandleTypeProvider); // Tipo de vela seleccionado

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
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () async {
                                      if (product.stock > 0) {
                                        final newStock = product.stock - 1;
                                        await candleProviderNotifier.updateCandleStock(product.id, newStock);
                                      }
                                    },
                                  ),
                                  Text('${product.stock}'),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () async {
                                      final newStock = product.stock + 1;
                                      await candleProviderNotifier.updateCandleStock(product.id, newStock);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: Colors.blueAccent,
                                    onPressed: () {
                                      // Mostrar el formulario de edición
                                      _showEditDialog(context, product, candleProviderNotifier, ref);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(context, product, candleProviderNotifier);
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

  // Función para mostrar el formulario de edición
  void _showEditDialog(BuildContext context, Candle product, CandleProvider candleProviderNotifier, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    String name = product.name;
    String description = product.description;
    double price = product.price;
    int stock = product.stock;
    String imageUrl = product.imageUrl ?? '';

    // Escuchar los tipos de vela disponibles y el tipo seleccionado
    final candleTypes = ref.watch(candleTypeProvider); // Lista de tipos de vela disponibles
    final selectedType = ref.watch(selectedCandleTypeProvider); // Tipo de vela seleccionado

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar producto'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: name,
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
                    initialValue: description,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    onChanged: (value) => description = value,
                    validator: (value) {
                      if (value == null || value.length > 255) {
                        return 'Por favor ingrese una descripción válida';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: price.toString(),
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
                    initialValue: stock.toString(),
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
                  DropdownButtonFormField<CandleType>(
                    value: selectedType,  // Este es el valor actual seleccionado, que es manejado por el provider.
                    decoration: const InputDecoration(labelText: 'Categoría'),
                    onChanged: (CandleType? newValue) {
                      // Aquí actualizas el estado con el tipo de vela seleccionado.
                      print(selectedCandleTypeProvider.state);
                      print(selectedCandleTypeProvider.state);
                      print(selectedCandleTypeProvider.state);
                      ref.read(selectedCandleTypeProvider.state).state = newValue;
                      print(selectedCandleTypeProvider.state);
                      print(selectedCandleTypeProvider.state);
                      print(selectedCandleTypeProvider.state);
                    },
                    items: candleTypes.map((CandleType type) {
                      return DropdownMenuItem<CandleType>(
                        value: type,
                        child: Text(type.name),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor seleccione una categoría';
                      }
                      return null;
                    },
                  ),

                  TextFormField(
                    initialValue: imageUrl,
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
                  final updatedCandle = Candle(
                    id: product.id,
                    name: name,
                    description: description,
                    price: price,
                    stock: stock,
                    scentRef: product.scentRef,
                    typeRef: selectedType?.ref ?? product.typeRef,
                    imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
                    active: product.active,
                  );

                  candleProviderNotifier.updateCandle(updatedCandle);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar cambios'),
            ),
          ],
        );
      },
    );
  }
}

// Método para mostrar el diálogo de confirmación antes de realizar el borrado lógico
void _showDeleteConfirmationDialog(BuildContext context, Candle product, CandleProvider candleProviderNotifier) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Confirmar Borrado Lógico'),
        content: const Text('¿Estás seguro de que deseas desactivar este producto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Desactivar el producto (borrado lógico)
              await candleProviderNotifier.deactivateCandle(product.id);
              Navigator.of(context).pop(); // Cerrar el diálogo
            },
            child: const Text('Confirmar'),
          ),
        ],
      );
    },
  );
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
                validator: (value) {
                  if (value == null || value.length > 255) {
                    return 'Por favor ingrese una descripción válida';
                  }
                  return null;
                },
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
                active: true
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