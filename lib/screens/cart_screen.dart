import 'package:flutter/material.dart';
import '../models/cart_manager.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    CartManager.instance.addListener(_updateCartView);
  }

  @override
  void dispose() {
    CartManager.instance.removeListener(_updateCartView);
    super.dispose();
  }

  void _updateCartView() {
    if (mounted) setState(() {});
  }

  void _showConfirmRemoval(int index) {
    final item = CartManager.instance.items[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover do carrinho?'),
        content: Text('Deseja remover ${item.product.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              CartManager.instance.removeProduct(item.product);
              Navigator.pop(context);
            },
            child:
                const Text('Remover', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartManager.instance;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        title: const Text('Meu Carrinho',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF00A86B),
        elevation: 0,
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text('Seu carrinho está vazio!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      )),
                  const SizedBox(height: 8),
                  const Text('Explore o catálogo e adicione ótimos produtos.',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.medication,
                                    color: Color(0xFF00A86B)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(item.product.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 4),
                                    Text(
                                      'R\$ ${item.product.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Color(0xFF0073E6),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  // ✅ Botão diminuir
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () =>
                                        cart.decreaseQuantity(item.product),
                                  ),
                                  Text('${item.quantity}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  // ✅ Botão aumentar
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      color: Color(0xFF00A86B),
                                    ),
                                    onPressed: () =>
                                        cart.addProduct(item.product),
                                  ),
                                  // ✅ Botão remover
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        _showConfirmRemoval(index),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // ✅ Footer com resumo e botão de checkout
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      // ✅ Total de itens
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Quantidade de itens:',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              )),
                          Text(
                            '${cart.items.fold(0, (sum, item) => sum + item.quantity)} un.',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // ✅ Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(
                            'R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF00A86B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // ✅ Botão de finalizar compra
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00A86B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: cart.items.isEmpty
                              ? null
                              : () {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                      'Pedido finalizado com sucesso! 🎉',
                                    ),
                                    backgroundColor: Color(0xFF00A86B),
                                  ));
                                  cart.clearCart();
                                },
                          child: const Text(
                            'Finalizar Compra',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
