import 'package:flutter/material.dart';

import '../DB/db_helper.dart';
import '../Model/Product.dart';

class ProductViewModel extends ChangeNotifier {
  List<Product> _allProducts = [];
  List<Product> _products = [];
  List<Product> get products => _products;

  String? errorMessage;
  final DatabaseHelper _dbHelper;

  ProductViewModel({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<void> fetchProducts() async {
    try {
      _allProducts = await _dbHelper.fetchProducts();
      _products = List.from(_allProducts);
      notifyListeners();
    } catch (e) {
      errorMessage = 'Error fetching products: $e';
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await _dbHelper.insertProduct(product);
      _allProducts.add(product);
      _products.add(product);
    } catch (e) {
      errorMessage = 'Error adding product: $e';
      notifyListeners();
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _dbHelper.deleteProduct(id);
      _allProducts.removeWhere((product) => product.id == id);
      _products.removeWhere((product) => product.id == id);
      notifyListeners();
    } catch (e) {
      errorMessage = 'Error deleting product: $e';
      notifyListeners();
    }
  }

  Future<void> editProduct(Product updatedProduct) async {
    try {
      await _dbHelper.updateProduct(updatedProduct);
      int index =
          _allProducts.indexWhere((product) => product.id == updatedProduct.id);
      if (index != -1) {
        _allProducts[index] = updatedProduct;
      }
      int filteredIndex =
          _products.indexWhere((product) => product.id == updatedProduct.id);
      if (filteredIndex != -1) {
        _products[filteredIndex] = updatedProduct;
      }
      notifyListeners();
    } catch (e) {
      errorMessage = 'Error updating product: $e';
      notifyListeners();
    }
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      _products = List.from(_allProducts);
    } else {
      _products = _allProducts
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
