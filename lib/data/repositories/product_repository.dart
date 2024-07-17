import 'package:tadbiroemas/services/firebase_product_service.dart';

import '../models/product.dart';

class ProductRepository {
  final FirebaseProductService _firebaseProductService;

  ProductRepository({
    required FirebaseProductService firebaseProductService,
  }) : _firebaseProductService = firebaseProductService;

  Future<List<Product>> getProducts() async {
    return await _firebaseProductService.getProducts();
  }

  Future<Product> addProduct(String title) async {
    return await _firebaseProductService.addProduct(title);
  }

  Future<void> editProduct(String id, String title) async {
    await _firebaseProductService.editProduct(id, title);
  }

  Future<void> deleteProduct(String id) async {
    await _firebaseProductService.deleteProduct(id);
  }
}
