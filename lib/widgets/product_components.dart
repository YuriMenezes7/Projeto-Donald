import 'package:flutter/material.dart';
import '../models/product_model.dart';

// ===========================================================================
// CARD DE PRODUTO (LAYOUT HORIZONTAL / EM GRADE)
// ===========================================================================
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({required this.product, super.key});

  // Mapeamento mestre e exclusivo de imagens em alta definição por palavra-chave
  // Mapeamento mestre e exclusivo de imagens em alta definição por palavra-chave
  String _getProductImageUrl(String productName) {
    final name = productName.toLowerCase().trim();
    
    if (name.contains('paracetamol')) {
      return 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=500&auto=format&fit=crop&q=80';
    } 
    if (name.contains('vitamina c') || name.contains('redoxon') || name.contains('zinco')) {
      return 'https://images.unsplash.com/photo-1611926653458-09294b3142bf?w=500&auto=format&fit=crop&q=80';
    } 
    if (name.contains('ômega') || name.contains('omega') || name.contains('suplemento')) {
      return 'https://images.unsplash.com/photo-1545214919-04d306029a5a?w=500&auto=format&fit=crop&q=80';
    } 
    if (name.contains('sérum') || name.contains('serum') || name.contains('facial')) {
      // 🌟 Imagem oficial do Sérum Vitamina C Sweet Skin - Dailus adicionada!
      return 'https://www.dailus.com.br/products/serum-vitamina-c-sweet-skin?srsltid=AfmBOopH8vSsGszDhhWcUUHXWUvhJaB3nMaw5jPqHcA_F8iGTw-jkpEI';
    } 
    if (name.contains('hidratante corporal') || name.contains('cerave') || name.contains('intensivo')) {
      return 'https://images.unsplash.com/photo-1556229174-5e42a09e45af?w=500&auto=format&fit=crop&q=80';
    } 
    if (name.contains('protetor labial') || name.contains('nivea') || name.contains('labial')) {
      return 'https://images.unsplash.com/photo-1608248597481-496100c80836?w=500&auto=format&fit=crop&q=80';
    }
    if (name.contains('protetor solar')) {
      return 'https://images.unsplash.com/photo-1526947425960-945c6e72858f?w=500&auto=format&fit=crop&q=80';
    }
    if (name.contains('ibuprofeno')) {
      return 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=500&auto=format&fit=crop&q=80';
    }
    if (name.contains('shampoo') || name.contains('anticaspa')) {
      return 'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=500&auto=format&fit=crop&q=80';
    }
    if (name.contains('fexofenadina') || name.contains('cloridrato')) {
      return 'https://images.unsplash.com/photo-1607613009820-a29f7bb81c04?w=500&auto=format&fit=crop&q=80';
    }
    
    return 'https://images.unsplash.com/photo-1584017911766-d451b3d0e843?w=500&auto=format&fit=crop&q=80';
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
            // --- Bloco da Imagem Dinâmica e Otimizada ---
            Stack(
              children: [
                Image.network(
                  _getProductImageUrl(product.name),
                  width: double.infinity,
                  height: 125, // Proporção idêntica e fixa para todos os cards
                  fit: BoxFit.cover, // Garante o preenchimento simétrico perfeito
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 125,
                      width: double.infinity,
                      color: Colors.green.shade50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.medical_services_outlined, color: Colors.green.shade600, size: 28),
                          const SizedBox(height: 4),
                          Text(
                            product.category,
                            style: TextStyle(color: Colors.green.shade800, fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (product.isPromo)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4D4D),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'OFERTA',
                        style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                    ),
                  ),
              ],
            ),
            
            // --- Informações de Texto do Card ---
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
                          product.brand.toUpperCase(),
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          product.name,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87, height: 1.2),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'R\$ ${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF007AFA)),
                        ),
                        Material(
                          color: const Color(0xFFE6F7F0),
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.add_shopping_cart_rounded, color: Color(0xFF00A86B), size: 18),
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
// CARD EM LINHA (LAYOUT VERTICAL DOS MAIS VENDIDOS)
// ===========================================================================
class ProductRowTile extends StatelessWidget {
  final Product product;

  const ProductRowTile({required this.product, super.key});

  String _getRowProductImageUrl(String productName) {
    final name = productName.toLowerCase().trim();
    if (name.contains('ibuprofeno')) {
      return 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=500&auto=format&fit=crop&q=80';
    }
    if (name.contains('fexofenadina')) {
      return 'https://images.unsplash.com/photo-1607613009820-a29f7bb81c04?w=500&auto=format&fit=crop&q=80';
    }
    if (name.contains('protetor solar')) {
      return 'https://images.unsplash.com/photo-1526947425960-945c6e72858f?w=500&auto=format&fit=crop&q=80';
    }
    if (name.contains('shampoo')) {
      return 'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=500&auto=format&fit=crop&q=80';
    }
    return 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=500&auto=format&fit=crop&q=80';
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
            _getRowProductImageUrl(product.name),
            width: 48,
            height: 48,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${product.brand} • ${product.symptom}',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'R\$ ${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF007AFA)),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add_shopping_cart_rounded, color: Color(0xFF00A86B), size: 20),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}