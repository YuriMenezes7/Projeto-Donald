import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/cart_manager.dart';
import '../widgets/product_components.dart';

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
    // Extract unique categories from mock products and sort
    _categories = mockProducts
        .map((p) => p.category)
        .toSet()
        .toList()
        ..sort();
    _selectedCategory = _categories.isNotEmpty ? _categories.first : '';
  }

  @override
  Widget build(BuildContext context) {
    // Filter products by selected category
    final filteredProducts = mockProducts
        .where((p) => p.category == _selectedCategory)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Catálogo de Produtos',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF00A86B),
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Banner de credibilidade
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFFE6F7F0),
            child: Row(
              children: [
                Icon(Icons.shield_rounded, color: Colors.green.shade700, size: 16),
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

          // Abas de categorias
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

          // Grid de produtos
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Text(
                      'Nenhum produto em "$_selectedCategory"',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(14),
                    itemCount: filteredProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(product: product);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
