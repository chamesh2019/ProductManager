import 'package:flutter/material.dart';
import '../models/campaign.dart';
import '../widgets/campaign_card.dart';

class CampaignList extends StatelessWidget {
  final List<Campaign> campaigns;
  final Function(Campaign) onEdit;
  final Function(Campaign) onDelete;
  final Function(Campaign) onTap;
  final Function(Campaign)? onViewChangeLogs;
  final VoidCallback onRefresh;

  const CampaignList({
    super.key,
    required this.campaigns,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
    this.onViewChangeLogs,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: campaigns.length,
        itemBuilder: (context, index) {
          final campaign = campaigns[index];
          return CampaignCard(
            campaign: campaign,
            onEdit: () => onEdit(campaign),
            onDelete: () => onDelete(campaign),
            onTap: () => onTap(campaign),
            onViewChangeLogs: onViewChangeLogs != null
                ? () => onViewChangeLogs!(campaign)
                : null,
          );
        },
      ),
    );
  }
}
