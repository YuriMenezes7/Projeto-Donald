import 'package:flutter/material.dart';
import '../models/product_model.dart';

/// Título padronizado para as seções do Dashboard inicial.
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 28, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20, 
          fontWeight: FontWeight.w700, 
          color: Colors.black87,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}

/// Card de Produto Premium para a seção de Promoções Imperdíveis.
/// Redesenhado com dimensões maiores, imagens reais e tratamento anti-overflow.
class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({required this.product, super.key});


// Mapeamento expandido com links de alta resolução que passam credibilidade farmacêutica e estética
  String _getProductImageUrl(String productName) {
    final name = productName.toLowerCase();
    
    if (name.contains('paracetamol') || name.contains('ibuprofeno') || name.contains('fexofenadina')) {
      return 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400&auto=format&fit=crop&q=80'; // Medicamentos em caixas limpas
    } else if (name.contains('vitamina') || name.contains('ômega')) {
      return 'https://images.unsplash.com/photo-1616679911721-efe6eec18fcd?w=400&auto=format&fit=crop&q=80'; // Suplementos premium e bem-estar
    } else if (name.contains('sérum') || name.contains('sabonete líquido')) {
      return 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400&auto=format&fit=crop&q=80'; // Dermocosméticos de laboratório
    } else if (name.contains('protetor solar') || name.contains('hidratante corporal')) {
      return 'https://images.unsplash.com/photo-1608248597481-496100c80836?w=400&auto=format&fit=crop&q=80'; // Cuidados com a pele e proteção
    } else if (name.contains('shampoo') || name.contains('dental') || name.contains('labial')) {
      return 'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=400&auto=format&fit=crop&q=80'; // Higiene e cuidados diários corporais
    }
    
    return 'https://images.unsplash.com/photo-1584017911766-d451b3d0e843?w=400&auto=format&fit=crop&q=80'; // Imagem padrão de farmácia/clínica
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170, // Largura ampliada para melhor leitura e visualização da imagem
      margin: const EdgeInsets.only(right: 16),
      decoration: CourtStyle.cardDecoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container da Imagem com proporção fixa e elegante
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Image.network(
                    _getProductImageUrl(product.name),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  // Badge discreto de "Oferta" se for promocional
                  if (product.isPromo)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.shade600,
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
            ),
            // Bloco de Informações com padding protetor
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.brand.toUpperCase(),
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87, height: 1.2),
                        ),
                      ],
                    ),
                    // Preço destacado em azul e-commerce
                    Text(
                      'R\$ ${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF0073E6), 
                        fontWeight: FontWeight.w800, 
                        fontSize: 15,
                      ),
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

/// Tile horizontal estruturado para a listagem vertical de destaques.
class ProductRowTile extends StatelessWidget {
  final Product product;
  const ProductRowTile({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.medication_rounded, color: Color(0xFF00A86B)),
        ),
        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
        subtitle: Text('${product.brand} • Trata: ${product.symptom}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        trailing: Text(
          'R\$ ${product.price.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF0073E6), fontSize: 15),
        ),
      ),
    );
  }
}

/// Estilos e Decorações Centrais do App
class CourtStyle {
  static BoxDecoration searchBox = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
  );

  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.grey.shade200),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12, 
        blurRadius: 6, 
        offset: Offset(0, 3),
      )
    ],
  );
}