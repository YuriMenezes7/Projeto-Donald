
/// Modelo estrutural para representação de produtos farmacêuticos e de cuidados pessoais.
class Product {
  final String name;      // Nome comercial ou princípio ativo
  final String category;  // Categoria de controle/venda do produto
  final String brand;     // Laboratório ou marca fabricante
  final String symptom;   // Sintoma ou indicação terapêutica primária
  final double price;     // Preço final de venda
  final bool isPromo;     // Flag indicativo se o produto está em oferta

  Product({
    required this.name,
    required this.category,
    required this.brand,
    required this.symptom,
    required this.price,
    this.isPromo = false,
  });
}

/// Base de dados fictícia local expandida e sem repetições.
final List<Product> mockProducts = [
  // --- PROMOÇÕES IMPERDÍVEIS (isPromo: true) ---
  Product(name: 'Paracetamol 500mg', category: 'Medicamentos', brand: 'Medley', symptom: 'Dor e Febre', price: 8.50, isPromo: true),
  Product(name: 'Vitamina C + Zinco 1g', category: 'Vitaminas', brand: 'Redoxon', symptom: 'Imunidade', price: 22.00, isPromo: true),
  Product(name: 'Hidratante Corporal Intensivo', category: 'Cuidados Pessoais', brand: 'Cerave', symptom: 'Pele Seca', price: 65.00, isPromo: true),
  Product(name: 'Sérum Facial Vitamina C', category: 'Beleza', brand: 'La Roche-Posay', symptom: 'Antioxidante', price: 149.90, isPromo: true),
  Product(name: 'Suplemento Ômega 3 1000mg', category: 'Vitaminas', brand: 'Essential Nutrition', symptom: 'Saúde Cardiovascular', price: 89.90, isPromo: true),
  Product(name: 'Protetor Labial Hidratante', category: 'Cuidados Pessoais', brand: 'Nivea', symptom: 'Lábios Ressecados', price: 15.90, isPromo: true),

  // --- MAIS VENDIDOS E DESTAQUES (isPromo: false) ---
  Product(name: 'Ibuprofeno 600mg', category: 'Medicamentos', brand: 'Neo Química', symptom: 'Inflamação e Dor', price: 12.90),
  Product(name: 'Protetor Solar FPS 60 Antioleosidade', category: 'Beleza', brand: 'Vichy', symptom: 'Proteção Solar', price: 79.90),
  Product(name: 'Shampoo Anticaspa Clínico', category: 'Higiene', brand: 'Head & Shoulders', symptom: 'Couro Cabeludo', price: 34.90),
  Product(name: 'Cloridrato de Fexofenadina 120mg', category: 'Medicamentos', brand: 'Allegra', symptom: 'Alergias e Rinite', price: 43.20),
  Product(name: 'Sabonete Líquido Facial Light', category: 'Beleza', brand: 'Bioderma', symptom: 'Limpeza de Pele', price: 54.00),
  Product(name: 'Creme Dental Clareador Advanced', category: 'Higiene', brand: 'Colgate Luminous', symptom: 'Proteção Bocal', price: 18.50),
];