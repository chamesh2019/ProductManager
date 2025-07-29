import 'package:flutter/material.dart';
import '../models/campaign.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
// import '../widgets/delete_confirmation_dialog.dart';
import 'product_form_screen.dart';
import 'product_change_log_screen.dart';

class CampaignProductsScreen extends StatefulWidget {
  final Campaign campaign;

  const CampaignProductsScreen({super.key, required this.campaign});

  @override
  State<CampaignProductsScreen> createState() => _CampaignProductsScreenState();
}

class _CampaignProductsScreenState extends State<CampaignProductsScreen> {
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final products = await ProductService.getProductsByCampaign(
      widget.campaign.id,
    );
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  Future<void> _deleteProduct(String id) async {
    final success = await ProductService.deleteProduct(id);
    if (success) {
      _loadProducts();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to delete product')));
    }
  }

  void _editProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(
          campaign: widget.campaign,
          product: product,
          onSaved: _loadProducts,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProduct(product.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _createNewProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(
          campaign: widget.campaign,
          onSaved: _loadProducts,
        ),
      ),
    );
  }

  void _viewChangeLogs() {
    // Create a dummy admin user for viewing change logs
    final adminUser = User(id: 'admin', fullName: 'Admin User');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductChangeLogScreen(
          user: adminUser,
          campaignId: widget.campaign.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Products'),
            Text(
              widget.campaign.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _viewChangeLogs,
            tooltip: 'View Change Logs',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No products found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first product',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadProducts,
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return ProductCard(
                    product: product,
                    onEdit: () => _editProduct(product),
                    onDelete: () => _showDeleteConfirmation(product),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewProduct,
        backgroundColor: Colors.blue.shade600,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
