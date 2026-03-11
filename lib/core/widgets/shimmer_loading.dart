// Виджет загрузки с эффектом мерцания (shimmer)
// Показывается пока данные загружаются

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Виджет-заглушка с эффектом мерцания для состояния загрузки.
/// Создаёт скелетон контента, пока реальные данные не загружены.
class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    this.height = 60,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Фабричный метод для создания скелетона списка карточек
  static Widget listSkeleton({int itemCount = 6}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ShimmerLoading(height: 72),
        );
      },
    );
  }
}
