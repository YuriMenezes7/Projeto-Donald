import 'package:flutter/material.dart';
import 'product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartManager extends ChangeNotifier {
  // ✅ Padrão Singleton para acessar o mesmo carrinho em todo o app
  static final CartManager instance = CartManager._internal();
  CartManager._internal();

  // ✅ Usando Map com ID do produto para lookup O(1) em vez de O(n)
  final Map<String, CartItem> _items = {};
  
  List<CartItem> get items => _items.values.toList();

  // ✅ Otimizado: calcula total apenas quando chamado
  double get totalAmount {
    return _items.values.fold(
      0.0,
      (total, item) => total + (item.product.price * item.quantity),
    );
  }

  /// ✅ Adiciona produto ou incrementa quantidade se já existe
  /// Performance: O(1) em vez de O(n)
  void addProduct(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  /// ✅ Diminui quantidade ou remove do carrinho
  /// Performance: O(1) em vez de O(n)
  void decreaseQuantity(Product product) {
    if (!_items.containsKey(product.id)) return;

    final item = _items[product.id]!;
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(product.id);
    }
    notifyListeners();
  }

  /// ✅ Remove produto do carrinho
  /// Performance: O(1) em vez de O(n)
  void removeProduct(Product product) {
    _items.remove(product.id);
    notifyListeners();
  }

  /// ✅ Limpa o carrinho completamente
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  /// ✅ Retorna a quantidade de um produto específico no carrinho
  int getQuantity(Product product) {
    return _items[product.id]?.quantity ?? 0;
  }

  /// ✅ Verifica se o produto está no carrinho
  bool isInCart(Product product) {
    return _items.containsKey(product.id);
  }
}
