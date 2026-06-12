import 'package:flutter/material.dart';
import 'cart_screen.dart';
import '../widgets/product_components.dart';
import '../models/product_model.dart';

// ===========================================================================
// WIDGET PRINCIPAL: GERENCIADOR DE ABAS
// ===========================================================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
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
        selectedItemColor: const Color(0xFF00A86B),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label: 'Catálogo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Busca',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Carrinho',
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// CONTEÚDO DA TELA INICIAL
// ===========================================================================
class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Product> promos = mockProducts.where((p) => p.isPromo).toList();
    final List<Product> destaques = mockProducts.where((p) => !p.isPromo).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Cabeçalho ---
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
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

            // --- Seção de Promoções ---
            const SectionTitle(title: '🔥 Promoções Imperdíveis'),
            SizedBox(
              height: 310,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                scrollDirection: Axis.horizontal,
                itemCount: promos.length,
                itemBuilder: (context, index) => SizedBox(
                  width: 165,
                  child: ProductCard(product: promos[index]),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- Seção de Mais Vendidos ---
            const SectionTitle(title: '⭐ Mais Vendidos e Destaques'),
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

// ===========================================================================
// CATÁLOGO COM FILTROS POR CATEGORIA
// ===========================================================================
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late String _selectedCategory;
  late List<String> _categories;

  @override
  void initState() {
    super.initState();
    _categories = mockProducts
        .map((p) => p.category)
        .toSet()
        .toList()
        ..sort();
    _selectedCategory = _categories.first;
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = mockProducts
        .where((p) => p.category == _selectedCategory)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Produtos'),
        backgroundColor: const Color(0xFF00A86B),
        elevation: 0,
      ),
      body: Column(
        children: [
          // ✅ Abas de categorias
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedCategory = category);
                        }
                      },
                      backgroundColor: Colors.grey.shade100,
                      selectedColor: const Color(0xFF00A86B),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // ✅ Grid de produtos
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Text(
                      'Nenhum produto em "$_selectedCategory"',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return _CatalogProductCard(product: product);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ✅ Card de Produto para Catálogo
class _CatalogProductCard extends StatefulWidget {
  final Product product;

  const _CatalogProductCard({required this.product});

  @override
  State<_CatalogProductCard> createState() => _CatalogProductCardState();
}

class _CatalogProductCardState extends State<_CatalogProductCard> {
  late bool _isInCart;

  @override
  void initState() {
    super.initState();
    _isInCart = CartManager.instance.isInCart(widget.product);
    CartManager.instance.addListener(_updateStatus);
  }

  @override
  void dispose() {
    CartManager.instance.removeListener(_updateStatus);
    super.dispose();
  }

  void _updateStatus() {
    if (mounted) {
      setState(() => _isInCart = CartManager.instance.isInCart(widget.product));
    }
  }

  void _addToCart() {
    CartManager.instance.addProduct(widget.product);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} adicionado! ✓'),
        backgroundColor: const Color(0xFF00A86B),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Stack(
                children: [
                  Image.network(
                    widget.product.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.green.shade50,
                        child: Icon(
                          Icons.medical_services_outlined,
                          color: Colors.green.shade600,
                          size: 40,
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
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Informações
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'R\$ ${widget.product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00A86B),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton.icon(
                      onPressed: _isInCart ? null : _addToCart,
                      icon: Icon(
                        _isInCart ? Icons.check : Icons.add_shopping_cart,
                        size: 16,
                      ),
                      label: Text(
                        _isInCart ? 'Adicionado' : 'Adicionar',
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A86B),
                        disabledBackgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// TELA DE BUSCA
// ===========================================================================
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
// COMPONENTE: TÍTULO DE SEÇÃO
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
