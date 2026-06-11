class Product {
  final String name;      
  final String category;  // Alinhado perfeitamente com as Abas do seu Catálogo
  final String brand;     
  final String symptom;   
  final double price;     
  final bool isPromo;     

  Product({
    required this.name,
    required this.category,
    required this.brand,
    required this.symptom,
    required this.price,
    this.isPromo = false,
  });
}

final List<Product> mockProducts = [
  // ==================== ABA: MEDICAMENTOS ====================
  Product(name: 'Paracetamol 500mg', category: 'Medicamentos', brand: 'Medley', symptom: 'Dor e Febre', price: 8.50, isPromo: true),
  Product(name: 'Ibuprofeno 600mg', category: 'Medicamentos', brand: 'Neo Química', symptom: 'Inflamação e Dor', price: 12.90),
  Product(name: 'Cloridrato de Fexofenadina 120mg', category: 'Medicamentos', brand: 'Allegra', symptom: 'Alergias e Rinite', price: 43.20),
  Product(name: 'Dipirona Monoidratada 500mg', category: 'Medicamentos', brand: 'EMS', symptom: 'Analgesia e Febre', price: 6.20),
  Product(name: 'Colírio Hidratante Ocular 15ml', category: 'Medicamentos', brand: 'Steril', symptom: 'Olhos Secos', price: 29.90),
  Product(name: 'Losartana Potássica 50mg', category: 'Medicamentos', brand: 'Eurofarma', symptom: 'Hipertensão', price: 14.50),

  // ==================== ABA: VITAMINAS ====================
  Product(name: 'Vitamina C + Zinco 1g', category: 'Vitaminas', brand: 'Redoxon', symptom: 'Imunidade', price: 22.00, isPromo: true),
  Product(name: 'Suplemento Ômega 3 1000mg', category: 'Vitaminas', brand: 'Essential Nutrition', symptom: 'Saúde Cardiovascular', price: 89.90, isPromo: true),
  Product(name: 'Complexo Vitamínico B max', category: 'Vitaminas', brand: 'Lavitan', symptom: 'Energia Física', price: 24.90),
  Product(name: 'Vitamina D3 2000UI', category: 'Vitaminas', brand: 'Addera D3', symptom: 'Saúde Óssea', price: 45.00),
  Product(name: 'Colágeno Hidrolisado Pó', category: 'Vitaminas', brand: 'Sanavita', symptom: 'Firmeza da Pele', price: 78.90),

  // ==================== ABA: HIGIENE ====================
  Product(name: 'Shampoo Anticaspa Clínico', category: 'Higiene', brand: 'Head & Shoulders', symptom: 'Couro Cabeludo', price: 34.90),
  Product(name: 'Creme Dental Clareador Advanced', category: 'Higiene', brand: 'Colgate Luminous', symptom: 'Proteção Bocal', price: 18.50),
  Product(name: 'Desodorante Clinical Masculino', category: 'Higiene', brand: 'Rexona', symptom: 'Antitranspirante', price: 24.90),
  Product(name: 'Enxaguante Bucal Hortelã 500ml', category: 'Higiene', brand: 'Listerine', symptom: 'Higiene Oral', price: 27.80),
  Product(name: 'Sabonete Líquido Bebê Glicerina', category: 'Higiene', brand: 'Granado', symptom: 'Banho Infantil', price: 21.50),

  // ==================== ABA: BELEZA ====================
  Product(name: 'Sérum Facial Vitamina C', category: 'Beleza', brand: 'La Roche-Posay', symptom: 'Antioxidante', price: 149.90, isPromo: true),
  Product(name: 'Hidratante Corporal Intensivo', category: 'Beleza', brand: 'Cerave', symptom: 'Pele Seca', price: 65.00, isPromo: true),
  Product(name: 'Protetor Solar FPS 60', category: 'Beleza', brand: 'Vichy', symptom: 'Proteção Solar', price: 79.90),
  Product(name: 'Protetor Labial Hidratante', category: 'Beleza', brand: 'Nivea', symptom: 'Lábios Ressecados', price: 15.90, isPromo: true),
  Product(name: 'Água Micelar Purificante 200ml', category: 'Beleza', brand: 'L\'Oréal Paris', symptom: 'Limpeza Facial', price: 32.90),
];