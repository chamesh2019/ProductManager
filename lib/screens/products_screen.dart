import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../models/campaign.dart';
import '../services/product_service.dart';
import '../services/user_service.dart';
import '../widgets/product_card.dart';
import '../main.dart';
import 'product_change_log_screen.dart';

class ProductsScreen extends StatefulWidget {
  final User user;
  final Campaign? campaign;

  const ProductsScreen({super.key, required this.user, this.campaign});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> _products = [];
  bool _isLoading = true;
  String _campaignName = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final List<Product> products;

      if (widget.campaign != null) {
        // Load products for the specific campaign
        products = await ProductService.getProductsByCampaign(
          widget.campaign!.id,
        );
      } else {
        // Load all products if no campaign is specified
        products = await ProductService.getAllProducts();
      }

      setState(() {
        _products = products;
        _campaignName =
            widget.campaign?.title ??
            (products.isNotEmpty ? 'All Products' : '');
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading products: $e')));
      }
    }
  }

  void _showProductUpdateDialog(Product product) {
    final TextEditingController controller = TextEditingController(
      text: product.currentSoldAmount.toString(),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Sales for ${product.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current sold: ${product.currentSoldAmount}'),
              Text('Target: ${product.targetAmount}'),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'New sold amount',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newAmount = int.tryParse(controller.text);
                if (newAmount != null && newAmount >= 0) {
                  Navigator.of(context).pop();
                  await _updateProductSales(product, newAmount);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid number'),
                    ),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateProductSales(Product product, int newSoldAmount) async {
    try {
      await ProductService.updateProductSales(
        product.id,
        newSoldAmount,
        widget.user,
      );

      // Update the local product list
      setState(() {
        final index = _products.indexWhere((p) => p.id == product.id);
        if (index != -1) {
          _products[index] = product.copyWith(currentSoldAmount: newSoldAmount);
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sales updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating sales: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${widget.user.fullName}',
              style: const TextStyle(fontSize: 16),
            ),
            if (_campaignName.isNotEmpty)
              Text(
                _campaignName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        toolbarHeight: widget.campaign != null ? 100 : 80,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'change_history') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProductChangeLogScreen(
                      user: widget.user,
                      campaignId: widget.campaign?.id,
                    ),
                  ),
                );
              } else if (value == 'logout') {
                await UserService.logout();
                if (mounted) {
                  // Navigate back to main app which will check registration status
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const AppHome()),
                    (route) => false,
                  );
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'change_history',
                child: Row(
                  children: [
                    Icon(Icons.history, size: 20),
                    SizedBox(width: 8),
                    Text('Change History'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: widget.campaign != null
            ? PreferredSize(
                preferredSize: const Size.fromHeight(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.campaign, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        widget.campaign!.description,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No products available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This campaign doesn\'t have any products yet',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadProducts,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ProductCard(
                      product: product,
                      onTap: () => _showProductUpdateDialog(product),
                    ),
                  );
                },
              ),
            ),
      primary: true,
    );
  }
}
