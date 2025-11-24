import 'package:flutter/material.dart';
import 'custom_carousel.dart';

/// 图片轮播组件
///
/// 专门用于显示网络图片的轮播图组件，内置图片加载状态和错误处理。
class ImageCarousel extends StatelessWidget {
  /// 图片URL列表
  final List<String> imageUrls;

  /// 轮播图高度
  final double? height;

  /// 图片圆角半径
  ///
  /// 默认值为8.0
  final double borderRadius;

  /// 图片填充模式
  ///
  /// 默认值为BoxFit.cover
  final BoxFit fit;

  /// 是否显示指示器
  ///
  /// 默认值为true
  final bool showIndicator;

  /// 是否自动播放
  ///
  /// 默认值为true
  final bool autoPlay;

  /// 图片点击回调
  ///
  /// [index]: 被点击的图片索引
  final Function(int)? onImageTap;

  /// 图片加载占位符
  ///
  /// 如果为null，则使用默认加载指示器
  final Widget? placeholder;

  /// 图片加载错误占位符
  ///
  /// 如果为null，则使用默认错误图标
  final Widget? errorWidget;

  /// 视口分数
  ///
  /// 默认值为1.0
  final double viewportFraction;

  /// 是否放大居中页面
  ///
  /// 默认值为false
  final bool enlargeCenterPage;

  /// 指示器位置
  ///
  /// 默认值为IndicatorPosition.center
  final IndicatorPosition indicatorPosition;

  /// 指示器边距
  ///
  /// 默认底部16像素
  final EdgeInsets indicatorMargin;

  /// 指示器颜色
  final Color? indicatorColor;

  /// 指示器背景颜色
  final Color? indicatorBackgroundColor;

  const ImageCarousel({
    super.key,
    required this.imageUrls,
    this.height = 200,
    this.borderRadius = 8.0,
    this.fit = BoxFit.cover,
    this.showIndicator = true,
    this.autoPlay = true,
    this.onImageTap,
    this.placeholder,
    this.errorWidget,
    this.viewportFraction = 1.0,
    this.enlargeCenterPage = false,
    this.indicatorPosition = IndicatorPosition.center,
    this.indicatorMargin = const EdgeInsets.only(bottom: 16),
    this.indicatorColor,
    this.indicatorBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCarousel(
      itemCount: imageUrls.length,
      height: height,
      autoPlay: autoPlay,
      viewportFraction: viewportFraction,
      enlargeCenterPage: enlargeCenterPage,
      showIndicator: showIndicator,
      indicatorPosition: indicatorPosition,
      indicatorMargin: indicatorMargin,
      indicatorColor: indicatorColor,
      indicatorBackgroundColor: indicatorBackgroundColor,
      itemBuilder: (context, index) {
        return _buildImageItem(context, index);
      },
    );
  }

  /// 构建单个图片项
  Widget _buildImageItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => onImageTap?.call(index),
      child: Container(
        margin: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.network(
            imageUrls[index],
            fit: fit,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return placeholder ?? _buildPlaceholder();
            },
            errorBuilder: (context, error, stackTrace) {
              return errorWidget ?? _buildErrorWidget();
            },
          ),
        ),
      ),
    );
  }

  /// 构建加载占位符
  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  /// 构建错误占位符
  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.error_outline, color: Colors.grey),
    );
  }
}
