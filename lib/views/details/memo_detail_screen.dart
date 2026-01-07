import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/memo_gift_model.dart';
import '../../utils/app_theme.dart';

class MemoDetailScreen extends StatelessWidget {
  final MemoGift memoGift;

  const MemoDetailScreen({super.key, required this.memoGift});

  @override
  Widget build(BuildContext context) {
    // Check if image is a local file or network URL
    final bool isLocalFile =
        memoGift.imageUrl.isNotEmpty && !memoGift.imageUrl.startsWith('http');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: memoGift.imageUrl.isNotEmpty
                  ? (isLocalFile
                        ? Image.file(
                            File(memoGift.imageUrl),
                            fit: BoxFit.cover,
                            cacheWidth: 1200,
                          )
                        : Image.network(
                            memoGift.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                  ),
                                ),
                          ))
                  : Container(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      child: const Icon(
                        Icons.card_giftcard,
                        size: 100,
                        color: AppTheme.primaryColor,
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          memoGift.title,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textColor,
                              ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '\$${memoGift.price}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('MMMM dd, yyyy').format(memoGift.createdAt),
                        style: TextStyle(
                          color: AppTheme.subTextColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 48),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    memoGift.description,
                    style: TextStyle(
                      color: AppTheme.textColor.withOpacity(0.8),
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
