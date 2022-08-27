import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:products_app/providers/product_form_provider.dart';
import 'package:products_app/services/products_service.dart';
import 'package:products_app/widgets/product_image.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);
    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productService.selectedProduct),
      child: _ProductScreenBody(productService: productService),
    );
    //return _ProductScreenBody(product: product);
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              Stack(
                children: [
                  ProductImage(imgUrl: productService.selectedProduct.picture),
                  Positioned(
                    top: 60,
                    left: 20,
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 40,
                          color: Colors.white,
                        )),
                  ),
                  Positioned(
                    top: 60,
                    right: 20,
                    child: IconButton(
                        onPressed: () async {
                          final ImagePicker _picker = ImagePicker();

                          final XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery, imageQuality: 100);

                          if (image == null) return;

                          print('Image selected: ${image.path}');
                          productService.updateSelectedProductImage(image.path);
                        },
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          size: 40,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
              _ProductForm(
                productService: productService,
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {
    final productFormProvider = Provider.of<ProductFormProvider>(context);
    final product = productFormProvider.product;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
            key: productFormProvider.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: product.name,
                  onChanged: (value) => product.name = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Product name',
                    hintText: 'Enter product name',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  initialValue: product.price.toString(),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                  onChanged: (value) {
                    if (double.tryParse(value) == null) {
                      product.price = 0;
                    } else {
                      product.price = double.parse(value);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Product price',
                    hintText: 'Enter product price: \$77.70',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SwitchListTile.adaptive(
                    value: product.available,
                    title: const Text('Product is available'),
                    onChanged: productFormProvider.updateAvailability),
                const SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  onPressed: productService.isSaving
                      ? null
                      : () {
                          if (!productFormProvider.isValidForm()) return;

                          productService
                              .saveOrCreateProduct(product)
                              .then((_) => {
                                    Navigator.of(context).pop(),
                                  });
                        },
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.save_outlined),
                      const SizedBox(width: 5),
                      Text(productService.isSaving ? 'Waite ...' : 'Save'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            )),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(25),
            bottomLeft: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ]);
}
