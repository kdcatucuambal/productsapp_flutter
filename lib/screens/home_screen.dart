import 'package:flutter/material.dart';
import 'package:products_app/models/product_dart.dart';
import 'package:products_app/screens/loading_screen.dart';
import 'package:products_app/services/services.dart';
import 'package:products_app/widgets/product_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    if (productsService.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.login_outlined),
            onPressed: () {
              authService.logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
          )
        ],
      ),
      body: ListView.builder(
          itemCount: productsService.products.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: GestureDetector(
                child: ProductCard(
                  product: productsService.products[index],
                ),
                onTap: () {
                  productsService.selectedProduct = productsService.products[index].copy();
                  Navigator.pushNamed(context, 'product');
                },
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productsService.selectedProduct = Product(available: false, name: "", price: 0.0);
          Navigator.pushNamed(context, 'product');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
