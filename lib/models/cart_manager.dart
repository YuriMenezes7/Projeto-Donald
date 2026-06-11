// NOVO ARQUIVO: lib/models/cart_manager.dart
import 'package:flutter/material.dart';
import 'product_model.dart'; // Garanta que aponta para o seu arquivo de modelo de produto

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartManager extends ChangeNotifier {
  // Padrão Singleton para acessar o mesmo carrinho em todo o app
  static final CartManager instance = CartManager._internal();
  CartManager._internal();

  final List<CartItem> _items = [];
  List<CartItem> get items => _items;

  double get totalAmount {
    return _items.fold(0.0, (total, item) => total + (item.product.price * item.quantity));
  }

  void addProduct(Product product) {
    for (var item in _items) {
      if (item.product.name == product.name) {
        item.quantity++;
        notifyListeners();
        return;
      }
    }
    _items.add(CartItem(product: product));
    notifyListeners();
  }

  void decreaseQuantity(Product product) {
    for (var item in _items) {
      if (item.product.name == product.name) {
        if (item.quantity > 1) {
          item.quantity--;
        } else {
          _items.remove(item);
        }
        break;
      }
    }
    notifyListeners();
  }

  void removeProduct(Product product) {
    _items.removeWhere((item) => item.product.name == product.name);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}