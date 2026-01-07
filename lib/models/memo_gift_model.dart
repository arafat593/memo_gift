import 'package:cloud_firestore/cloud_firestore.dart';

class MemoGift {
  final String id;
  final String userId; // Added userId
  final String title;
  final String description;
  final String imageUrl;
  final DateTime createdAt;
  final double price;

  MemoGift({
    required this.id,
    required this.userId,
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
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      price: (data['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt':
          FieldValue.serverTimestamp(), // Use server timestamp for consistency
      'price': price,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MemoGift &&
        other.id == id &&
        other.userId == userId &&
        other.title == title &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        other.price == price &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      title,
      description,
      imageUrl,
      price,
      createdAt,
    );
  }
}
