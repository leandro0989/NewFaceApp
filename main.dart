import 'package:flutter/material.dart';

void main() {
  runApp(const NewFaceApp());
}

class NewFaceApp extends StatelessWidget {
  const NewFaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'New Face - Limpieza',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// Modelos de datos
class Product {
  final String id;
  final String name;
  final String category;
  final Map<String, double> presentationsUSD;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.presentationsUSD,
  });
}

class CartItem {
  final Product product;
  final String presentation;
  final double priceUSD;
  int quantity;

  CartItem({
    required this.product,
    required this.presentation,
    required this.priceUSD,
    this.quantity = 1,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Tasa del día (Modificable desde el panel matriz)
  double exchangeRateBs = 36.50; 

  String selectedCategory = 'Todos';
  final List<String> categories = [
    'Todos',
    'Limpieza Hogar',
    'Higiene Personal',
    'Automotriz',
    'Reventa / Artículos'
  ];

  // Base de datos de productos New Face
  final List<Product> products = [
    Product(
      id: '1',
      name: 'Cloro Concentrado',
      category: 'Limpieza Hogar',
      presentationsUSD: {'500 ml': 0.6, '1 L': 1.0, '1.5 L': 1.4, '2 L': 1.8, 'Galón': 3.5, '20 L': 15.0},
    ),
    Product(
      id: '2',
      name: 'Jabón Líquido Premium',
      category: 'Limpieza Hogar',
      presentationsUSD: {'500 ml': 0.8, '1 L': 1.5, '1.5 L': 2.1, '2 L': 2.7, 'Galón': 5.0, '20 L': 22.0},
    ),
    Product(
      id: '3',
      name: 'Jabón Líquido Económico',
      category: 'Limpieza Hogar',
      presentationsUSD: {'500 ml': 0.5, '1 L': 1.0, '1.5 L': 1.4, '2 L': 1.8, 'Galón': 3.8, '20 L': 16.0},
    ),
    Product(
      id: '4',
      name: 'Lavaplatos Tipo Brisol Premium',
      category: 'Limpieza Hogar',
      presentationsUSD: {'500 ml': 1.0, '1 L': 1.8, '1.5 L': 2.5, '2 L': 3.2, 'Galón': 6.0, '20 L': 25.0},
    ),
    Product(
      id: '5',
      name: 'Desengrasante Multiuso',
      category: 'Limpieza Hogar',
      presentationsUSD: {'500 ml': 1.0, '1 L': 1.8, '1.5 L': 2.5, '2 L': 3.2, 'Galón': 6.0, '20 L': 28.0},
    ),
    Product(
      id: '6',
      name: 'Shampoo Neutro Automotriz',
      category: 'Automotriz',
      presentationsUSD: {'500 ml': 1.2, '1 L': 2.0, '1.5 L': 2.8, '2 L': 3.5, 'Galón': 7.0, '20 L': 30.0},
    ),
    Product(
      id: '7',
      name: 'Silicona para Plásticos',
      category: 'Automotriz',
      presentationsUSD: {'500 ml': 2.5, '1 L': 4.5, 'Galón': 15.0},
    ),
    Product(
      id: '8',
      name: 'Abrillantador de Cauchos',
      category: 'Automotriz',
      presentationsUSD: {'500 ml': 1.5, '1 L': 2.8, 'Galón': 9.0},
    ),
    Product(
      id: '9',
      name: 'Crema Corporal',
      category: 'Higiene Personal',
      presentationsUSD: {'500 ml': 2.0, '1 L': 3.5},
    ),
  ];

  List<CartItem> cart = [];

  void addToCart(Product product, String presentation, double price) {
    setState(() {
      int index = cart.indexWhere((item) =>
          item.product.id == product.id && item.presentation == presentation);
      if (index != -1) {
        cart[index].quantity++;
      } else {
        cart.add(CartItem(
            product: product, presentation: presentation, priceUSD: price));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} ($presentation) agregado al carrito'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  double get totalUSD =>
      cart.fold(0, (sum, item) => sum + (item.priceUSD * item.quantity));

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = selectedCategory == 'Todos'
        ? products
        : products.where((p) => p.category == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Face - Limpieza', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(
                        cart: cart,
                        exchangeRate: exchangeRateBs,
                        onUpdateCart: () => setState(() {}),
                      ),
                    ),
                  );
                },
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${cart.length}',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                )
            ],
          )
        ],
      ),
      body: Column(
        children: [
          // Banner Tasa y Delivery
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.blue.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('📍 La Victoria, Aragua | Delivery Gratis',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Text('Tasa: 1\$ = ${exchangeRateBs.toStringAsFixed(2)} Bs.',
                    style: const TextStyle(fontSize: 12, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // Categorías
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedCategory == categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: ChoiceChip(
                    label: Text(categories[index]),
                    selected: isSelected,
                    selectedColor: Colors.black,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    onSelected: (bool selected) {
                      setState(() {
                        selectedCategory = categories[index];
                      });
                    },
                  ),
                );
              },
            ),
          ),
          // Catálogo de Productos
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                Product product = filteredProducts[index];
                return ProductCard(
                  product: product,
                  exchangeRate: exchangeRateBs,
                  onAddToCart: addToCart,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget Tarjeta de Producto
class ProductCard extends StatefulWidget {
  final Product product;
  final double exchangeRate;
  final Function(Product, String, double) onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.exchangeRate,
    required this.onAddToCart,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late String selectedPresentation;

  @override
  void initState() {
    super.initState();
    selectedPresentation = widget.product.presentationsUSD.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    double priceUSD = widget.product.presentationsUSD[selectedPresentation]!;
    double priceBs = priceUSD * widget.exchangeRate;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            Text(widget.product.name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(widget.product.category,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Presentación: ', style: TextStyle(fontSize: 13)),
                DropdownButton<String>(
                  value: selectedPresentation,
                  items: widget.product.presentationsUSD.keys.map((p) {
                    return DropdownMenuItem(value: p, child: Text(p));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => selectedPresentation = val);
                  },
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    Text('\$${priceUSD.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                    Text('${priceBs.toStringAsFixed(2)} Bs.',
                        style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => widget.onAddToCart(widget.product, selectedPresentation, priceUSD),
                  icon: const Icon(Icons.add_shopping_cart, size: 18),
                  label: const Text('Agregar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Pantalla del Carrito y Checkout
class CartScreen extends StatefulWidget {
  final List<CartItem> cart;
  final double exchangeRate;
  final VoidCallback onUpdateCart;

  const CartScreen({
    super.key,
    required this.cart,
    required this.exchangeRate,
    required this.onUpdateCart,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String selectedPaymentMethod = 'Pago Móvil';
  final List<String> paymentMethods = [
    'Pago Móvil',
    'Zelle',
    'USDT (Binance Pay)',
    'Efectivo USD',
    'Efectivo Bs.',
    'Punto de Venta (Delivery)'
  ];

  double get totalUSD => widget.cart.fold(0, (sum, item) => sum + (item.priceUSD * item.quantity));

  @override
  Widget build(BuildContext context) {
    double totalBs = totalUSD * widget.exchangeRate;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu Carrito de Compra'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: widget.cart.isEmpty
          ? const Center(child: Text('El carrito está vacío'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cart.length,
                    itemBuilder: (context, index) {
                      CartItem item = widget.cart[index];
                      return ListTile(
                        title: Text('${item.product.name} (${item.presentation})'),
                        subtitle: Text('\$${item.priceUSD} x ${item.quantity} = \$${(item.priceUSD * item.quantity).toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                setState(() {
                                  if (item.quantity > 1) {
                                    item.quantity--;
                                  } else {
                                    widget.cart.removeAt(index);
                                  }
                                });
                                widget.onUpdateCart();
                              },
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                setState(() => item.quantity++);
                                widget.onUpdateCart();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total en USD:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('\$${totalUSD.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total en Bolívares:', style: TextStyle(fontSize: 14)),
                          Text('${totalBs.toStringAsFixed(2)} Bs.', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text('Método de Pago:', style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: selectedPaymentMethod,
                        items: paymentMethods.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedPaymentMethod = val);
                        },
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('¡Pedido Enviado a New Face! 🚀'),
                                content: Text('Tu pedido por \$${totalUSD.toStringAsFixed(2)} ($selectedPaymentMethod) ha sido recibido. Te llegará notificación cuando esté en camino.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Aceptar'),
                                  )
                                ],
                              ),
                            );
                          },
                          child: const Text('Finalizar Pedido (Delivery Gratis)', style: TextStyle(fontSize: 16)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
