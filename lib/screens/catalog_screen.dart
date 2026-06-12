import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../widgets/product_components.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  // Simulação do repositório de dados com os produtos corretos mapeados
  final List<Product> _catalogProducts = [
    Product(
      name: 'Paracetamol 500mg',
      brand: 'Medley',
      category: 'Medicamentos',
      symptom: 'Febre e Dor',
      price: 8.50,
      isPromo: true,
      imageUrl: 'https://via.placeholder.com/150?text=Paracetamol',
    ),
    Product(
      name: 'Vitamina C + Zinco 1g',
      brand: 'Redoxon',
      category: 'Vitaminas',
      symptom: 'Imunidade',
      price: 22.00,
      isPromo: true,
      imageUrl: 'https://via.placeholder.com/150?text=Vitamina+C',
    ),
    Product(
      name: 'Suplemento Ômega 3 1000mg',
      brand: 'Essential Nutrition',
      category: 'Vitaminas',
      symptom: 'Suplementação',
      price: 89.90,
      isPromo: true,
      imageUrl: 'https://via.placeholder.com/150?text=Suplemento+Ômega+3',
    ),
    Product(
      name: 'Sérum Facial Vitamina C',
      brand: 'La Roche-Posay',
      category: 'Beleza',
      symptom: 'Cuidados Diários',
      price: 149.90,
      isPromo: true,
      imageUrl: 'https://via.placeholder.com/150?text=Sérum+Facial+Vitamina+C',
    ),
    Product(
      name: 'Hidratante Corporal Intensivo',
      brand: 'CeraVe',
      category: 'Beleza',
      symptom: 'Pele Seca',
      price: 65.00,
      isPromo: true,
      imageUrl:
          'https://via.placeholder.com/150?text=Hidratante+Corporal+Intensivo',
    ),
    Product(
      name: 'Protetor Labial Hidratante',
      brand: 'Nivea',
      category: 'Beleza',
      symptom: 'Lábios Ressecados',
      price: 15.90,
      isPromo: true,
      imageUrl:
          'https://via.placeholder.com/150?text=Protetor+Labial+Hidratante',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Catálogo de Produtos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(
          0xFF00A86B,
        ), // Verde institucional Planck Pharma
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Banner discreto superior para credibilidade de mercado
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFFE6F7F0),
            child: Row(
              children: [
                Icon(
                  Icons.shield_rounded,
                  color: Colors.green.shade700,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Medicamentos e produtos com procedência garantida',
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Grid dinâmico que exibe os cards de produtos de forma responsiva
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: _catalogProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Exibe 2 itens por linha na grade
                crossAxisSpacing: 12, // Espaçamento horizontal entre cards
                mainAxisSpacing: 12, // Espaçamento vertical entre linhas
                childAspectRatio:
                    0.72, // Proporção ideal para o layout vertical do ProductCard
              ),
              itemBuilder: (context, index) {
                final product = _catalogProducts[index];

                // Reaproveitando o ProductCard que já possui o tratamento inteligente de imagens e clique de carrinho
                return ProductCard(product: product);
              },
            ),
          ),
        ],
      ),
    );
  }
}
