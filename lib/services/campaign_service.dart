import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import '../models/campaign.dart';
import 'product_service.dart';
import 'firebase_service.dart';

class CampaignService {
  static Future<List<Campaign>> getAllCampaigns() async {
    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      final snapshot = await FirebaseService.campaignsCollection.get();
      return snapshot.docs
          .map((doc) => Campaign.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting campaigns: $e');
      throw Exception('Failed to load campaigns from Firebase: $e');
    }
  }

  static Future<List<Campaign>> getCampainbyPin(String pin) async {
    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      final snapshot = await FirebaseService.campaignsCollection
          .where('pin', isEqualTo: pin)
          .get();
      return snapshot.docs
          .map((doc) => Campaign.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting campaigns by pin: $e');
      throw Exception('Failed to load campaigns by pin from Firebase: $e');
    }
  }

  static Future<Campaign?> getCampaignById(String id) async {
    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      final doc = await FirebaseService.campaignsCollection.doc(id).get();
      if (doc.exists) {
        return Campaign.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting campaign by id: $e');
      throw Exception('Failed to load campaign from Firebase: $e');
    }
  }

  static Future<bool> createCampaign(Campaign campaign) async {
    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      final doc = await FirebaseService.campaignsCollection
          .doc(campaign.id)
          .get();
      if (doc.exists) {
        return false; // Campaign already exists
      }

      final campaignData = campaign.toJson();
      campaignData['createdAt'] = FieldValue.serverTimestamp();
      campaignData['updatedAt'] = FieldValue.serverTimestamp();

      await FirebaseService.campaignsCollection
          .doc(campaign.id)
          .set(campaignData);

      return true;
    } catch (e) {
      print('Error creating campaign: $e');
      throw Exception('Failed to create campaign in Firebase: $e');
    }
  }

  static Future<bool> updateCampaign(Campaign updatedCampaign) async {
    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      final campaignData = updatedCampaign.toJson();
      campaignData['updatedAt'] = FieldValue.serverTimestamp();

      await FirebaseService.campaignsCollection
          .doc(updatedCampaign.id)
          .update(campaignData);

      return true;
    } catch (e) {
      print('Error updating campaign: $e');
      throw Exception('Failed to update campaign in Firebase: $e');
    }
  }

  static Future<bool> deleteCampaign(String id) async {
    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      // First delete all products associated with this campaign
      await ProductService.deleteProductsByCampaign(id);

      // Delete from Firebase
      await FirebaseService.campaignsCollection.doc(id).delete();

      return true;
    } catch (e) {
      print('Error deleting campaign: $e');
      throw Exception('Failed to delete campaign from Firebase: $e');
    }
  }

  static String generateCampaignId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  static String generateCampaignPin() {
    final random = Random();
    final pin = (100000 + random.nextInt(900000)).toString();
    return pin;
  }
}
