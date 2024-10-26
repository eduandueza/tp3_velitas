class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}

final List<Product> products = [
  Product(
    id: '1',
    name: 'Producto 1',
    description: 'Descripción del producto 1',
    price: 29.99,
    imageUrl: 'lib/assets/aro2.webp',

  ),
  Product(
    id: '2',
    name: 'Producto 2',
    description: 'Descripción del producto 2',
    price: 49.99,
    imageUrl: 'lib/assets/aro3.webp',
  ),
    Product(
    id: '3',
    name: 'Producto 1',
    description: 'Descripción del producto 3',
    price: 29.99,
    imageUrl: 'lib/assets/aroo1.webp',
  ),
  Product(
    id: '4',
    name: 'Producto 2',
    description: 'Descripción del producto 4',
    price: 49.99,
    imageUrl: 'lib/assets/velas-home.webp',
  ),
];
