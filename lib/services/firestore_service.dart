import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/memo_gift_model.dart';

class FirestoreService {
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  Stream<List<MemoGift>> getMemoGifts() {
    return _db
        .collection('memo_gifts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => MemoGift.fromFirestore(doc)).toList(),
        );
  }

  Future<void> addMemoGift(MemoGift memoGift) {
    return _db.collection('memo_gifts').add(memoGift.toFirestore());
  }

  Future<void> deleteMemoGift(String id) {
    return _db.collection('memo_gifts').doc(id).delete();
  }
}
