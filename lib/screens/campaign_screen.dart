import 'package:flutter/material.dart';
import '../models/campaign.dart';
import '../models/user.dart';
import '../services/campaign_service.dart';
import '../services/user_service.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/campaign_list.dart';
import '../widgets/user_list_widget.dart';
import '../widgets/delete_confirmation_dialog.dart';
import 'campaign_form_screen.dart';
import 'campaign_products_screen.dart';
import 'product_change_log_screen.dart';

class CampaignScreen extends StatefulWidget {
  const CampaignScreen({super.key});

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen>
    with SingleTickerProviderStateMixin {
  List<Campaign> _campaigns = [];
  List<User> _users = [];
  bool _isLoadingCampaigns = true;
  bool _isLoadingUsers = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild to update floating action button
    });
    _loadCampaigns();
    _loadUsers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCampaigns() async {
    setState(() => _isLoadingCampaigns = true);
    final campaigns = await CampaignService.getAllCampaigns();
    setState(() {
      _campaigns = campaigns;
      _isLoadingCampaigns = false;
    });
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoadingUsers = true);
    final users = await UserService.getAllUsers();
    setState(() {
      _users = users;
      _isLoadingUsers = false;
    });
  }

  Future<void> _deleteCampaign(String id) async {
    final success = await CampaignService.deleteCampaign(id);
    if (success) {
      _loadCampaigns();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Campaign deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete campaign')),
      );
    }
  }

  void _editCampaign(Campaign campaign) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CampaignFormScreen(campaign: campaign, onSaved: _loadCampaigns),
      ),
    );
  }

  void _showDeleteConfirmation(Campaign campaign) {
    DeleteConfirmationDialog.show(
      context,
      campaign,
      () => _deleteCampaign(campaign.id),
    );
  }

  void _viewCampaignProducts(Campaign campaign) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CampaignProductsScreen(campaign: campaign),
      ),
    );
  }

  void _viewCampaignChangeLogs(Campaign campaign) {
    // We need a user for the ProductChangeLogScreen, but in admin panel we might not have one
    // Let's create a dummy admin user for this purpose or modify the screen to handle null user
    final adminUser = User(id: 'admin', fullName: 'Admin User');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProductChangeLogScreen(user: adminUser, campaignId: campaign.id),
      ),
    );
  }

  void _createNewCampaign() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CampaignFormScreen(onSaved: _loadCampaigns),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.campaign), text: 'Campaigns'),
            Tab(icon: Icon(Icons.people), text: 'Users'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Campaigns Tab
          _isLoadingCampaigns
              ? const Center(child: CircularProgressIndicator())
              : _campaigns.isEmpty
              ? const EmptyStateWidget()
              : CampaignList(
                  campaigns: _campaigns,
                  onEdit: _editCampaign,
                  onDelete: _showDeleteConfirmation,
                  onTap: _viewCampaignProducts,
                  onViewChangeLogs: _viewCampaignChangeLogs,
                  onRefresh: _loadCampaigns,
                ),
          // Users Tab
          _isLoadingUsers
              ? const Center(child: CircularProgressIndicator())
              : UserListWidget(users: _users, onRefresh: _loadUsers),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: _createNewCampaign,
              backgroundColor: Colors.blue.shade600,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
