import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:products_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'product-hunt-ec576-default-rtdb.firebaseio.com';
  final storage = const FlutterSecureStorage();
  final List<Product> _products = [];
  late Product selectedProduct;
  File? newPicture;
  bool _isLoading = true;
  bool _isSaving = false;

  ProductsService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    _isLoading = true;
    notifyListeners();
    final url =
        Uri.https(_baseUrl, 'products.json', {'auth': await storage.read(key: 'token') ?? ''});
    final response = await http.get(url);
    final Map<String, dynamic> dataMap = json.decode(response.body);
    dataMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      _products.add(tempProduct);
    });
    _isLoading = false;
    notifyListeners();
    return _products;
  }

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  bool get isSaving => _isSaving;

  Future<void> saveOrCreateProduct(Product product) async {
    _isSaving = true;
    notifyListeners();

    final String? imgUrl = await uploadImage();

    if (imgUrl != null) product.picture = imgUrl;

    if (product.id == null) {
      await createProduct(product);
    } else {
      await updateProduct(product);
    }

    _isSaving = false;
    notifyListeners();
  }

  Future<String> createProduct(Product product) async {
    final url =
        Uri.https(_baseUrl, 'products.json', {'auth': await storage.read(key: 'token') ?? ''});
    final response = await http.post(url, body: product.toJson());
    product.id = json.decode(response.body)['name'];
    _products.add(product);
    return product.id!;
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(
        _baseUrl, 'products/${product.id}.json', {'auth': await storage.read(key: 'token') ?? ''});
    await http.put(url, body: product.toJson());
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;
    return product.id!;
  }

  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;
    newPicture = File.fromUri(Uri.parse(path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPicture == null) return null;
    final url =
        Uri.parse("https://api.cloudinary.com/v1_1/dfte0tnqy/image/upload?upload_preset=foczjw2p");

    final imageUploadRequest = http.MultipartRequest("POST", url);
    final file = await http.MultipartFile.fromPath("file", newPicture!.path);
    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);
    if (resp.statusCode != 200 && resp.statusCode != 201) return null;
    newPicture = null;
    final responseData = json.decode(resp.body);
    return responseData["secure_url"];
  }
}
