import 'package:flutter/material.dart';
import 'cart_screen.dart';
import '../widgets/product_components.dart';
import '../models/product_model.dart';

// ===========================================================================
// WIDGET PRINCIPAL: GERENCIADOR DE ABAS (BOTTOM NAVIGATION BAR)
// ===========================================================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

 // Alternativa 100% segura sem nenhum 'const' na lista:
  final List<Widget> _screens = [
    MainDashboard(), 
    CatalogScreen(),
    SearchScreen(),
    CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF00A86B), // Verde Planck Pharma
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined), activeIcon: Icon(Icons.grid_view), label: 'Catálogo'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Busca'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: 'Carrinho'),
        ],
      ),
    );
  }
}

// ===========================================================================
// CONTEÚDO DA TELA INICIAL (DASHBOARD)
// ===========================================================================
class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Separação automatizada dos produtos vindo do ProductModel
    final List<Product> promos = mockProducts.where((p) => p.isPromo).toList();
    final List<Product> destaques = mockProducts.where((p) => !p.isPromo).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Cabeçalho e Barra de Busca Estilizada ---
            Container(
              padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 24),
              decoration: const BoxDecoration(
                color: Color(0xFF00A86B),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Planck Pharma',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 12),
                          Text(
                            'O que você está procurando hoje?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // --- Seção de Promoções (Horizontal) ---
            SectionTitle(title: '🔥 Promoções Imperdíveis'), // 🛠️ RESOLVIDO: Sem const para evitar quebras
            SizedBox(
              height: 310, // 🌟 SEGURANÇA: Ampliado para 310 para acomodar perfeitamente os botões de carrinho
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                scrollDirection: Axis.horizontal,
                itemCount: promos.length,
                itemBuilder: (context, index) => SizedBox(
                  width: 165, // Define uma largura harmoniosa para os cards horizontais
                  child: ProductCard(product: promos[index]),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // --- Seção de Mais Vendidos (Vertical) ---
            SectionTitle(title: '⭐ Mais Vendidos e Destaques'),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: destaques.length,
              itemBuilder: (context, index) => ProductRowTile(product: destaques[index]),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo'),
        backgroundColor: const Color(0xFF00A86B),
      ),
      body: const Center(
        child: Text(
          'Tela de catálogo',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Busca'),
        backgroundColor: const Color(0xFF00A86B),
      ),
      body: const Center(
        child: Text(
          'Tela de busca',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// ===========================================================================
// COMPONENTE AUXILIAR: TÍTULO DE SEÇÃO
// ===========================================================================
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}