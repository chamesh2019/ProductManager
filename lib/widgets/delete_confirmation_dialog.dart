import 'package:flutter/material.dart';
import '../models/campaign.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Campaign campaign;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    required this.campaign,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Campaign'),
      content: Text('Are you sure you want to delete "${campaign.title}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  static void show(
    BuildContext context,
    Campaign campaign,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) =>
          DeleteConfirmationDialog(campaign: campaign, onConfirm: onConfirm),
    );
  }
}
