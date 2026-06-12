class Product {
  final String id;
  final String name;
  final String category;
  final String brand;
  final String symptom;
  final double price;
  final bool isPromo;
  final String imageUrl; // ✅ Campo de imagem centralizad

  Product({
    String? id,
    required this.name,
    required this.category,
    required this.brand,
    required this.symptom,
    required this.price,
    required this.imageUrl, // ✅ Agora obrigatório e editável
    this.isPromo = false,
  }) : id = id ?? '${name.replaceAll(' ', '_')}_${category.replaceAll(' ', '_')}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

final List<Product> mockProducts = [
  // ==================== MEDICAMENTOS ====================
  Product(
    name: 'Paracetamol 500mg',
    category: 'Medicamentos',
    brand: 'Medley',
    symptom: 'Dor e Febre',
    price: 8.50,
    imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=500&auto=format&fit=crop&q=80',
    isPromo: true,
  ),
  Product(
    name: 'Ibuprofeno 600mg',
    category: 'Medicamentos',
    brand: 'Neo Química',
    symptom: 'Inflamação e Dor',
    price: 12.90,
    imageUrl: 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=500&auto=format&fit=crop&q=80',
  ),
  Product(
    name: 'Cloridrato de Fexofenadina 120mg',
    category: 'Medicamentos',
    brand: 'Allegra',
    symptom: 'Alergias e Rinite',
    price: 43.20,
    imageUrl: 'https://images.unsplash.com/photo-1607613009820-a29f7bb81c04?w=500&auto=format&fit=crop&q=80',
  ),
  Product(
    name: 'Dipirona Monoidratada 500mg',
    category: 'Medicamentos',
    brand: 'EMS',
    symptom: 'Analgesia e Febre',
    price: 6.20,
    imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=500&auto=format&fit=crop&q=80',
  ),
  Product(
    name: 'Colírio Hidratante Ocular 15ml',
    category: 'Medicamentos',
    brand: 'Steril',
    symptom: 'Olhos Secos',
    price: 29.90,
    imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=500&auto=format&fit=crop&q=80',
  ),
  Product(
    name: 'Losartana Potássica 50mg',
    category: 'Medicamentos',
    brand: 'Eurofarma',
    symptom: 'Hipertensão',
    price: 14.50,
    imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=500&auto=format&fit=crop&q=80',
  ),

  // ==================== VITAMINAS ====================
  Product(
    name: 'Vitamina C + Zinco 1g',
    category: 'Vitaminas',
    brand: 'Redoxon',
    symptom: 'Imunidade',
    price: 22.00,
    imageUrl: 'https://www.vhita.com.br/cdn/shop/files/vitamina_c_vitamina_c_vhita_1_still_1x_ab10ca45-d01a-4431-ab5f-e68755af6659.webp?v=1733786542',
    isPromo: true,
  ),
  Product(
    name: 'Suplemento Ômega 3 1000mg',
    category: 'Vitaminas',
    brand: 'Essential Nutrition',
    symptom: 'Saúde Cardiovascular',
    price: 89.90,
    imageUrl: 'https://images.unsplash.com/photo-1545214919-04d306029a5a?w=500&auto=format&fit=crop&q=80',
    isPromo: true,
  ),
  Product(
    name: 'Complexo Vitamínico B max',
    category: 'Vitaminas',
    brand: 'Lavitan',
    symptom: 'Energia Física',
    price: 24.90,
    imageUrl: 'https://images.unsplash.com/photo-1545214919-04d306029a5a?w=500&auto=format&fit=crop&q=80',
  ),
  Product(
    name: 'Vitamina D3 2000UI',
    category: 'Vitaminas',
    brand: 'Addera D3',
    symptom: 'Saúde Óssea',
    price: 45.00,
    imageUrl: 'https://images.unsplash.com/photo-1545214919-04d306029a5a?w=500&auto=format&fit=crop&q=80',
  ),
  Product(
    name: 'Colágeno Hidrolisado Pó',
    category: 'Vitaminas',
    brand: 'Sanavita',
    symptom: 'Firmeza da Pele',
    price: 78.90,
    imageUrl: 'https://images.unsplash.com/photo-1545214919-04d306029a5a?w=500&auto=format&fit=crop&q=80',
  ),

  // ==================== HIGIENE ====================
  Product(
    name: 'Shampoo Anticaspa Clínico',
    category: 'Higiene',
    brand: 'Head & Shoulders',
    symptom: 'Couro Cabeludo',
    price: 34.90,
    imageUrl: 'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=500&auto=format&fit=crop&q=80',
  ),
  Product(
    name: 'Creme Dental Clareador Advanced',
    category: 'Higiene',
    brand: 'Colgate Luminous',
    symptom: 'Proteção Bocal',
    price: 18.50,
    imageUrl: 'https://images.unsplash.com/photo-1587854692152-cbe660dbde0e?w=500&auto=format&fit=crop&q=80',
  ),
  Product(
    name: 'Desodorante Clinical Masculino',
    category: 'Higiene',
    brand: 'Rexona',
    symptom: 'Antitranspirante',
    price: 24.90,
    imageUrl: 'https://images.unsplash.com/photo-1556583348-2c1dadc5b6f0?w=500&auto=format&fit=crop&q=80',
  ),
  Product(
    name: 'Enxaguante Bucal Hortelã 500ml',
    category: 'Higiene',
    brand: 'Listerine',
    symptom: 'Higiene Oral',
    price: 27.80,
    imageUrl: 'https://images.unsplash.com/photo-1587854692152-cbe660dbde0e?w=500&auto=format&fit=crop&q=80',
  ),
  Product(
    name: 'Sabonete Líquido Bebê Glicerina',
    category: 'Higiene',
    brand: 'Granado',
    symptom: 'Banho Infantil',
    price: 21.50,
    imageUrl: 'https://images.unsplash.com/photo-1557621552-17105176677c?w=500&auto=format&fit=crop&q=80',
  ),

  // ==================== BELEZA ====================
  Product(
    name: 'Sérum Facial Vitamina C',
    category: 'Beleza',
    brand: 'La Roche-Posay',
    symptom: 'Antioxidante',
    price: 149.90,
    imageUrl: 'https://hidrabene.com.br/products/serum-facial-hidratante-multivitaminico?srsltid=AfmBOopC6a5EqlHhO1-4O2kD094qTpv1FQbiSkX0q2D6AfB2zeMY5rCk',
    isPromo: true,
  ),
  Product(
    name: 'Hidratante Corporal Intensivo',
    category: 'Beleza',
    brand: 'Cerave',
    symptom: 'Pele Seca',
    price: 65.00,
    imageUrl: 'https://hidratei.com.br/cdn/shop/files/locao-hidratante-corporal-400ml-para-presentear-hidratei-925404.png?v=1774459474&width=1080',
    isPromo: true,
  ),
  Product(
    name: 'Protetor Solar FPS 60',
    category: 'Beleza',
    brand: 'Vichy',
    symptom: 'Proteção Solar',
    price: 79.90,
    imageUrl: 'https://images.unsplash.com/photo-1526947425960-945c6e72858f?w=500&auto=format&fit=crop&q=80',
  ),
  Product(
    name: 'Protetor Labial Hidratante',
    category: 'Beleza',
    brand: 'Nivea',
    symptom: 'Lábios Ressecados',
    price: 15.90,
    imageUrl: 'https://images.unsplash.com/photo-1608248597481-496100c80836?w=500&auto=format&fit=crop&q=80',
    isPromo: true,
  ),
  Product(
    name: 'Água Micelar Purificante 200ml',
    category: 'Beleza',
    brand: 'L\'Oréal Paris',
    symptom: 'Limpeza Facial',
    price: 32.90,
    imageUrl: 'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=500&auto=format&fit=crop&q=80',
  ),
];
