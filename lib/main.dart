import 'package:flutter/material.dart';
import 'package:products_app/screens/screens.dart';
import 'package:products_app/services/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ProductsService()),
      ChangeNotifierProvider(create: (_) => AuthService()),
    ], child: const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Products',
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {
          'login': (context) => const LoginScreen(),
          'register': (context) => const RegisterScreen(),
          'home': (context) => const HomeScreen(),
          'product': (context) => const ProductScreen(),
        },
        theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: const Color.fromARGB(255, 238, 232, 232),
            appBarTheme: const AppBarTheme(elevation: 0, color: Colors.blue),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.blue, elevation: 0)));
  }
}
