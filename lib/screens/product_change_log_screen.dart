import 'package:flutter/material.dart';
import '../models/product_change_log.dart';
import '../models/user.dart';
import '../services/product_change_log_service.dart';

class ProductChangeLogScreen extends StatefulWidget {
  final User user;
  final String? productId;
  final String? campaignId;

  const ProductChangeLogScreen({
    super.key,
    required this.user,
    this.productId,
    this.campaignId,
  });

  @override
  State<ProductChangeLogScreen> createState() => _ProductChangeLogScreenState();
}

class _ProductChangeLogScreenState extends State<ProductChangeLogScreen> {
  List<ProductChangeLog> _changeLogs = [];
  bool _isLoading = true;
  String _title = 'Change History';

  @override
  void initState() {
    super.initState();
    _loadChangeLogs();
  }

  Future<void> _loadChangeLogs() async {
    try {
      List<ProductChangeLog> logs;

      if (widget.productId != null) {
        logs = await ProductChangeLogService.getChangeLogsByProduct(
          widget.productId!,
        );
        _title = 'Product Change History';
      } else if (widget.campaignId != null) {
        logs = await ProductChangeLogService.getChangeLogsByCampaign(
          widget.campaignId!,
        );
        _title = 'Campaign Change History';
      } else {
        logs = await ProductChangeLogService.getAllChangeLogs(limit: 100);
        _title = 'All Changes History';
      }

      setState(() {
        _changeLogs = logs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading change history: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _loadChangeLogs();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _changeLogs.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No change history',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'No product changes have been recorded yet',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadChangeLogs,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _changeLogs.length,
                itemBuilder: (context, index) {
                  final log = _changeLogs[index];
                  return _buildChangeLogCard(log);
                },
              ),
            ),
    );
  }

  Widget _buildChangeLogCard(ProductChangeLog log) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: _getChangeTypeColor(log.changeType),
                  child: Icon(
                    _getChangeTypeIcon(log.changeType),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log.productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'by ${log.userName}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatDateTime(log.timestamp),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getChangeTypeDisplayName(log.changeType),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    log.getChangeDescription(),
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (log.notes != null && log.notes!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.note, size: 16, color: Colors.blue[600]),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              log.notes!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[700],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getChangeTypeColor(String changeType) {
    switch (changeType) {
      case 'sales_update':
        return Colors.green;
      case 'create':
        return Colors.blue;
      case 'update':
        return Colors.orange;
      case 'delete':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getChangeTypeIcon(String changeType) {
    switch (changeType) {
      case 'sales_update':
        return Icons.trending_up;
      case 'create':
        return Icons.add;
      case 'update':
        return Icons.edit;
      case 'delete':
        return Icons.delete;
      default:
        return Icons.change_history;
    }
  }

  String _getChangeTypeDisplayName(String changeType) {
    switch (changeType) {
      case 'sales_update':
        return 'Sales Updated';
      case 'create':
        return 'Product Created';
      case 'update':
        return 'Product Updated';
      case 'delete':
        return 'Product Deleted';
      default:
        return 'Change';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
