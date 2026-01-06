import 'package:cloud_firestore/cloud_firestore.dart';

class MemoGift {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime createdAt;
  final double price;

  MemoGift({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.price,
  });

  factory MemoGift.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return MemoGift(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      price: (data['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt':
          FieldValue.serverTimestamp(), // Use server timestamp for consistency
      'price': price,
    };
  }
}
