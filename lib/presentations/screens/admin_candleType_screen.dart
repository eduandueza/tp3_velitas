import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/candle_type.dart';
import 'package:flutter_application_1/presentations/providers/candle_type_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/widgets/main_menu.dart';

class AdminCandleTypeScreen extends ConsumerWidget {
  const AdminCandleTypeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candleTypes = ref.watch(candleTypeProvider);
    final candleTypeProviderNotifier = ref.read(candleTypeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: candleTypes.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: candleTypes.length,
                      itemBuilder: (context, index) {
                        final candleType = candleTypes[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(candleType.name),
                            subtitle: _buildShortDescription(candleType.description, context, candleType.description),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: Colors.blueAccent,
                                  onPressed: () {
                                    _showEditDialog(context, candleType, candleTypeProviderNotifier);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () async {
                                    // Realizar el borrado lógico
                                    await candleTypeProviderNotifier.deactivateCandleType(candleType.id);
                                  },
                                ),
                              ],
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
                  _showAddDialog(context, candleTypeProviderNotifier);
                },
                child: const Text('Agregar tipo de vela'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MainMenu(),
    );
  }

  // Función para mostrar el formulario de edición
  void _showEditDialog(BuildContext context, CandleType candleType, CandleTypeProvider candleTypeProviderNotifier) {
    final _formKey = GlobalKey<FormState>();
    String name = candleType.name;
    String description = candleType.description;
    String size = candleType.size;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar categoría'),
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
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese una descripción';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: size,
                    decoration: const InputDecoration(labelText: 'Tamaño'),
                    onChanged: (value) => size = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un tamaño';
                      }
                      return null;
                    },
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
                  final updatedCandleType = CandleType(
                    id: candleType.id,
                    name: name,
                    description: description,
                    size: size,
                    active: candleType.active, // Mantén el estado 'active' original
                  );
                  candleTypeProviderNotifier.updateCandleType(updatedCandleType);
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


// Función para mostrar la descripción corta con "Ver más"
  Widget _buildShortDescription(String description, BuildContext context, String fullDescription) {
    const int maxLength = 50; // Límite de caracteres para la descripción corta
    if (description.length > maxLength) {
      // Si la descripción es más larga que el límite, mostramos una descripción corta
      final shortDescription = description.substring(0, maxLength) + '...';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            shortDescription, // Muestra solo los primeros caracteres
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis, // Añade "..."
            maxLines: 2, // Límite de líneas visibles
          ),
          // Botón para mostrar la descripción completa
          TextButton(
            onPressed: () {
              // Al hacer click, mostramos el diálogo con la descripción completa
              _showFullDescription(context, fullDescription);
            },
            child: const Text('Ver más'),
          ),
        ],
      );
    } else {
      // Si la descripción es corta, la mostramos completa
      return Text(
        description,
        style: const TextStyle(fontSize: 14),
      );
    }
  }

// Función para mostrar la descripción completa en un diálogo
  void _showFullDescription(BuildContext context, String description) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Descripción Completa'),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  // Función para mostrar el formulario de agregar nuevo tipo
  void _showAddDialog(BuildContext context, CandleTypeProvider candleTypeProviderNotifier) {
    final _formKey = GlobalKey<FormState>();
    String name = '';
    String description = '';
    String size = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar categoría'),
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
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese una descripción';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Tamaño'),
                    onChanged: (value) => size = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un tamaño';
                      }
                      return null;
                    },
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
                  final newCandleType = CandleType(
                    id: '', // El ID se generará en Firestore
                    name: name,
                    description: description,
                    size: size,
                    active: true, // Al crear un nuevo tipo, está activo por defecto
                    
                  );
                  candleTypeProviderNotifier.addCandleType(newCandleType);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }
}
