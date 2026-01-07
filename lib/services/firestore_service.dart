import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/memo_gift_model.dart';

class FirestoreService {
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  Stream<List<MemoGift>> getMemoGifts(String userId) {
    if (userId.isEmpty) {
      return Stream.value([]);
    }
    return _db
        .collection('memo_gifts')
        .where('userId', isEqualTo: userId)
        .limit(50) // Limit to 50 items to prevent UI freeze
        .snapshots()
        .map((snapshot) {
          final gifts = snapshot.docs
              .map((doc) => MemoGift.fromFirestore(doc))
              .toList();
          // Sort locally to avoid Firestore index requirements
          gifts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return gifts;
        });
  }

  Future<void> addMemoGift(MemoGift memoGift) {
    return _db.collection('memo_gifts').add(memoGift.toFirestore());
  }

  Future<void> deleteMemoGift(String id) {
    return _db.collection('memo_gifts').doc(id).delete();
  }
}
