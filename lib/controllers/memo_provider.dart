import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/memo_gift_model.dart';
import '../services/firestore_service.dart';

class MemoProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<MemoGift> _memoGifts = [];
  bool _isLoading = true;

  List<MemoGift> get memoGifts => _memoGifts;
  bool get isLoading => _isLoading;

  // Constructor no longer initializes stream immediately
  MemoProvider();

  StreamSubscription<List<MemoGift>>? _memoSubscription;
  String? _currentUserId;

  @override
  void dispose() {
    _memoSubscription?.cancel();
    super.dispose();
  }

  void updateUser(String? userId) {
    if (_currentUserId == userId) return;

    _currentUserId = userId;
    _initMemoStream(userId);
  }

  void _initMemoStream(String? userId) {
    _memoSubscription?.cancel();

    // If no user is logged in, clear data
    if (userId == null || userId.isEmpty) {
      _memoGifts = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    _memoSubscription = _firestoreService
        .getMemoGifts(userId)
        .listen(
          (gifts) {
            if (listEquals(_memoGifts, gifts)) {
              return;
            }

            _memoGifts = gifts;
            _isLoading = false;
            notifyListeners();
          },
          onError: (error) {
            debugPrint('Firestore Stream Error: $error');
            _isLoading = false;
            notifyListeners();
          },
        );
    // Fallback timeout
    Future.delayed(const Duration(seconds: 5), () {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    });
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

  Future<void> deleteMemoGift(String id, BuildContext context) async {
    try {
      await _firestoreService.deleteMemoGift(id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Memory removed successfully'),
            backgroundColor: Colors.orangeAccent,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
      }
    }
  }
}
