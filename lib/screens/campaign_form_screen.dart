import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/campaign.dart';
import '../services/campaign_service.dart';
import '../widgets/date_selector.dart';

class CampaignFormScreen extends StatefulWidget {
  final Campaign? campaign;
  final VoidCallback onSaved;

  const CampaignFormScreen({super.key, this.campaign, required this.onSaved});

  @override
  State<CampaignFormScreen> createState() => _CampaignFormScreenState();
}

class _CampaignFormScreenState extends State<CampaignFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();
  final _imageUrlController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isActive = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.campaign != null) {
      _populateForm(widget.campaign!);
    }
  }

  void _populateForm(Campaign campaign) {
    _titleController.text = campaign.title;
    _descriptionController.text = campaign.description;
    _budgetController.text = campaign.budget?.toString() ?? '';
    _imageUrlController.text = campaign.imageUrl ?? '';
    _startDate = campaign.startDate;
    _endDate = campaign.endDate;
    _isActive = campaign.isActive;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now().add(const Duration(days: 30))),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _saveCampaign() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start and end dates')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final campaign = Campaign(
      id: widget.campaign?.id ?? CampaignService.generateCampaignId(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      startDate: _startDate!,
      endDate: _endDate!,
      isActive: _isActive,
      pin: widget.campaign?.pin ?? CampaignService.generateCampaignPin(),
      budget: _budgetController.text.isEmpty
          ? null
          : double.tryParse(_budgetController.text),
      imageUrl: _imageUrlController.text.isEmpty
          ? null
          : _imageUrlController.text.trim(),
    );

    bool success;
    if (widget.campaign != null) {
      success = await CampaignService.updateCampaign(campaign);
    } else {
      success = await CampaignService.createCampaign(campaign);
    }

    setState(() => _isLoading = false);

    if (success) {
      widget.onSaved();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.campaign != null
                ? 'Campaign updated successfully'
                : 'Campaign created successfully',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.campaign != null
                ? 'Failed to update campaign'
                : 'Failed to create campaign',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.campaign != null ? 'Edit Campaign' : 'New Campaign'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveCampaign,
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Campaign Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a campaign title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // PIN Display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blue.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.pin_drop, color: Colors.blue.shade600),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Campaign PIN',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.campaign != null
                                ? widget.campaign!.pin
                                : 'Will be auto-generated on save',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'monospace',
                              color: widget.campaign != null
                                  ? Colors.black87
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.campaign != null)
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () async {
                          await Clipboard.setData(
                            ClipboardData(text: widget.campaign!.pin),
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('PIN copied to clipboard'),
                              ),
                            );
                          }
                        },
                        tooltip: 'Copy PIN',
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  DateSelector(
                    label: 'Start Date',
                    selectedDate: _startDate,
                    onTap: () => _selectDate(context, true),
                  ),
                  const SizedBox(width: 16),
                  DateSelector(
                    label: 'End Date',
                    selectedDate: _endDate,
                    onTap: () => _selectDate(context, false),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _budgetController,
                decoration: const InputDecoration(
                  labelText: 'Budget (optional)',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid budget amount';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Active Campaign'),
                subtitle: const Text('Toggle to activate/deactivate campaign'),
                value: _isActive,
                onChanged: (value) {
                  setState(() => _isActive = value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}
