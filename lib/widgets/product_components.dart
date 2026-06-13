import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/cart_manager.dart';

// ===========================================================================
// CARD DE PRODUTO (LAYOUT EM GRADE)
// ===========================================================================
class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onAddedToCart;

  const ProductCard({
    required this.product,
    this.onAddedToCart,
    super.key,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool _isInCart;

  @override
  void initState() {
    super.initState();
    _isInCart = CartManager.instance.isInCart(widget.product);
    CartManager.instance.addListener(_updateCartStatus);
  }

  @override
  void dispose() {
    CartManager.instance.removeListener(_updateCartStatus);
    super.dispose();
  }

  void _updateCartStatus() {
    if (mounted) {
      setState(() {
        _isInCart = CartManager.instance.isInCart(widget.product);
      });
    }
  }

  void _addToCart() {
    // Add product to cart
    CartManager.instance.addProduct(widget.product);
    
    // Trigger optional callback
    widget.onAddedToCart?.call();

    // Show confirmation snackbar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} adicionado ao carrinho! ✓'),
        backgroundColor: const Color(0xFF00A86B),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      margin: const EdgeInsets.only(right: 12, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Imagem com badge de promoção ---
            Stack(
              children: [
                Image.network(
                  widget.product.imageUrl,
                  width: double.infinity,
                  height: 125,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 125,
                      width: double.infinity,
                      color: Colors.green.shade50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.medical_services_outlined,
                              color: Colors.green.shade600, size: 28),
                          const SizedBox(height: 4),
                          Text(
                            widget.product.category,
                            style: TextStyle(
                              color: Colors.green.shade800,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (widget.product.isPromo)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4D4D),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'OFERTA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // --- Informações do produto ---
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.brand.toUpperCase(),
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.product.name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    // --- Preço e botão de adicionar ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'R\$ ${widget.product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF007AFA),
                          ),
                        ),
                        Material(
                          color: _isInCart
                              ? const Color(0xFF00A86B)
                              : const Color(0xFFE6F7F0),
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: _isInCart ? null : _addToCart,
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Icon(
                                _isInCart
                                    ? Icons.check_circle
                                    : Icons.add_shopping_cart_rounded,
                                color: _isInCart
                                    ? Colors.white
                                    : const Color(0xFF00A86B),
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// CARD EM LINHA (LAYOUT HORIZONTAL PARA MAIS VENDIDOS)
// ===========================================================================
class ProductRowTile extends StatefulWidget {
  final Product product;
  final VoidCallback? onAddedToCart;

  const ProductRowTile({
    required this.product,
    this.onAddedToCart,
    super.key,
  });

  @override
  State<ProductRowTile> createState() => _ProductRowTileState();
}

class _ProductRowTileState extends State<ProductRowTile> {
  late bool _isInCart;

  @override
  void initState() {
    super.initState();
    _isInCart = CartManager.instance.isInCart(widget.product);
    CartManager.instance.addListener(_updateCartStatus);
  }

  @override
  void dispose() {
    CartManager.instance.removeListener(_updateCartStatus);
    super.dispose();
  }

  void _updateCartStatus() {
    if (mounted) {
      setState(() {
        _isInCart = CartManager.instance.isInCart(widget.product);
      });
    }
  }

  void _addToCart() {
    // Add product to cart
    CartManager.instance.addProduct(widget.product);
    
    // Trigger optional callback
    widget.onAddedToCart?.call();

    // Show confirmation snackbar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} adicionado ao carrinho! ✓'),
        backgroundColor: const Color(0xFF00A86B),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            widget.product.imageUrl,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.green.shade50,
                child: Icon(Icons.medical_services_outlined,
                    color: Colors.green.shade600),
              );
            },
          ),
        ),
        title: Text(
          widget.product.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${widget.product.brand} • ${widget.product.symptom}',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'R\$ ${widget.product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF007AFA),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                _isInCart ? Icons.check_circle : Icons.add_shopping_cart_rounded,
                color: const Color(0xFF00A86B),
                size: 20,
              ),
              onPressed: _isInCart ? null : _addToCart,
            ),
          ],
        ),
      ),
    );
  }
}
