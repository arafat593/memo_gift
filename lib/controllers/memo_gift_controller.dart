import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/memo_gift_model.dart';
import '../services/firestore_service.dart';

class MemoGiftController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  var memoGifts = <MemoGift>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initMemoStream();

    // ডাটা ক্যাচ করার পর লোডিং ফলস করা হচ্ছে
    ever(memoGifts, (_) => isLoading.value = false);

    // ৩ সেকেন্ড পর যদি ডাটা না আসে তবে লোডিং বন্ধ করা হচ্ছে (Safety)
    Future.delayed(const Duration(seconds: 3), () {
      if (isLoading.value) isLoading.value = false;
    });
  }

  void _initMemoStream() {
    try {
      memoGifts.bindStream(
        _firestoreService.getMemoGifts().handleError((error) {
          debugPrint('Firestore Stream Error: $error');
          isLoading.value = false;
          if (error.toString().contains('permission-denied')) {
            Get.snackbar(
              'Access Denied',
              'Please check your Firestore Security Rules.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
          }
        }),
      );
    } catch (e) {
      debugPrint('Error binding Firestore stream: $e');
      isLoading.value = false;
    }
  }

  Future<void> addMemoGift(MemoGift gift) async {
    try {
      await _firestoreService.addMemoGift(gift);
      // Success handling will be done in the calling screen
    } catch (e) {
      // Rethrow the error so the calling screen can handle it
      rethrow;
    }
  }

  Future<void> deleteMemoGift(String id) async {
    try {
      await _firestoreService.deleteMemoGift(id);
      Get.snackbar(
        'Deleted',
        'Memory removed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent.withOpacity(0.1),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
