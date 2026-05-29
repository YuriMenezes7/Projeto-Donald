import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../widgets/product_components.dart';

// ==========================================
// CONTROLADOR CENTRAL DE ABAS
// ==========================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    const MainDashboard(),
    const CatalogScreen(),
    const SearchScreen(),
    const PrescriptionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF00A86B),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.category_outlined), activeIcon: Icon(Icons.category), label: 'Catálogo'),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined), activeIcon: Icon(Icons.search), label: 'Busca'),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), activeIcon: Icon(Icons.description), label: 'Receitas'),
        ],
      ),
    );
  }
}

// ==========================================
// ABA 1: MAIN DASHBOARD
// ==========================================
class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final promos = mockProducts.where((p) => p.isPromo).toList();
    final destaques = mockProducts.where((p) => !p.isPromo).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planck Pharma', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF00A86B),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF00A86B),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
              ),
              child: InkWell(
                onTap: () {}, 
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: CourtStyle.searchBox,
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 12),
                      Text('O que você está procurando hoje?', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ),
            ),
            const SectionTitle(title: '🔥 Promoções Imperdíveis'),
            SizedBox(
              height: 170,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                scrollDirection: Axis.horizontal,
                itemCount: promos.length,
                itemBuilder: (context, index) => ProductCard(product: promos[index]),
              ),
            ),
            const SectionTitle(title: '⭐ Mais Vendidos e Destaques'),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: destaques.length,
              itemBuilder: (context, index) => ProductRowTile(product: destaques[index]),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// ABA 2: CATALOG SCREEN
// ==========================================
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  final List<String> categories = const ['Medicamentos', 'Vitaminas', 'Higiene', 'Beleza', 'Cuidados Pessoais'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Catálogo de Produtos', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: TabBar(
            isScrollable: true,
            labelColor: const Color(0xFF00A86B),
            indicatorColor: const Color(0xFF00A86B),
            tabs: categories.map((cat) => Tab(text: cat)).toList(),
          ),
        ),
        body: TabBarView(
          children: categories.map((cat) {
            final filtered = mockProducts.where((p) => p.category == cat).toList();
            if (filtered.isEmpty) {
              return const Center(child: Text('Nenhum produto nesta categoria.'));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.8,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) => ProductCard(product: filtered[index]),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ==========================================
// ABA 3: SEARCH SCREEN
// ==========================================
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';
  String _selectedFilter = 'Todos';
  final List<String> _filters = ['Todos', 'Nome', 'Marca', 'Sintomas'];

  @override
  Widget build(BuildContext context) {
    final results = mockProducts.where((p) {
      final q = _query.toLowerCase();
      if (_selectedFilter == 'Nome') return p.name.toLowerCase().contains(q);
      if (_selectedFilter == 'Marca') return p.brand.toLowerCase().contains(q);
      if (_selectedFilter == 'Sintomas') return p.symptom.toLowerCase().contains(q);
      return p.name.toLowerCase().contains(q) || p.brand.toLowerCase().contains(q) || p.symptom.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Busca Avançada')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Digite para pesquisar...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _filters.map((f) => ChoiceChip(
                label: Text(f),
                selected: _selectedFilter == f,
                selectedColor: Colors.teal.shade100,
                onSelected: (val) { if(val) setState(() => _selectedFilter = f); },
              )).toList(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: results.isEmpty 
                ? const Center(child: Text('Nenhum produto encontrado.'))
                : ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) => ProductRowTile(product: results[index]),
                  ),
            )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// ABA 4: PRESCRIPTION SCREEN
// ==========================================
class PrescriptionScreen extends StatefulWidget {
  const PrescriptionScreen({super.key});

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  bool _isFileUploaded = false;
  bool _isUploading = false;

  void _simulateUpload() async {
    setState(() => _isUploading = true);
    await Future.delayed(const Duration(seconds: 2)); 
    setState(() {
      _isUploading = false;
      _isFileUploaded = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Receita enviada e validada com sucesso!'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Retenção de Receitas')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.receipt_long_rounded, size: 100, color: Colors.grey),
            const SizedBox(height: 24),
            const Text(
              'Medicamentos Controlados?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Para comprar antibióticos ou tarja preta, envie uma foto nítida da sua receita médica assinada.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 40),
            if (_isUploading)
              const Center(child: CircularProgressIndicator())
            else ...[
              ElevatedButton.icon(
                onPressed: _simulateUpload,
                icon: Icon(_isFileUploaded ? Icons.check : Icons.cloud_upload),
                label: Text(_isFileUploaded ? 'Alterar Receita Enviada' : 'Fazer Upload da Receita (PDF/IMG)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFileUploaded ? Colors.blue : const Color(0xFF00A86B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              if (_isFileUploaded) ...[
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.verified, color: Colors.green),
                    SizedBox(width: 8),
                    Text('receita_medica_validada.jpg', style: TextStyle(fontStyle: FontStyle.italic)),
                  ],
                )
              ]
            ],
          ],
        ),
      ),
    );
  }
}