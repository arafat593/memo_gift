import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/memo_gift_model.dart';
import '../utils/app_theme.dart';

class MemoCard extends StatelessWidget {
  final MemoGift gift;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const MemoCard({
    super.key,
    required this.gift,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the image source is a local file or a network URL
    final bool isLocalFile =
        gift.imageUrl.isNotEmpty && !gift.imageUrl.startsWith('http');

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 2, // Low elevation to reduce shadow cost
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias, // Optimized clipping
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: gift.imageUrl.isNotEmpty
                      ? (isLocalFile
                            ? Image.file(
                                File(gift.imageUrl),
                                fit: BoxFit.cover,
                                cacheWidth: 600, // Reduced cache width further
                                gaplessPlayback: true, // Prevent flickering
                              )
                            : Image.network(
                                gift.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildPlaceholder(),
                              ))
                      : _buildPlaceholder(),
                ),

                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '\$${gift.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                if (onDelete != null)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onDelete,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.delete_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gift.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('MMMM dd, yyyy').format(gift.createdAt),
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    gift.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppTheme.subTextColor.withOpacity(0.8),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.primaryColor.withOpacity(0.05),
          ],
        ),
      ),
      child: Icon(
        Icons.card_giftcard_rounded,
        size: 60,
        color: AppTheme.primaryColor.withOpacity(0.3),
      ),
    );
  }
}
