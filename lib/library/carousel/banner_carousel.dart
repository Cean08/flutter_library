import 'package:flutter/material.dart';
import 'custom_carousel.dart';

/// Banner项数据模型
class BannerItem {
  /// Banner图片URL
  final String imageUrl;

  /// Banner标题
  final String? title;

  /// Banner副标题
  final String? subtitle;

  /// Banner点击回调
  final VoidCallback? onTap;

  const BannerItem({
    required this.imageUrl,
    this.title,
    this.subtitle,
    this.onTap,
  });
}

/// Banner轮播组件
///
/// 支持显示文字叠加的Banner轮播图，适用于促销活动等场景。
class BannerCarousel extends StatelessWidget {
  /// Banner数据列表
  final List<BannerItem> banners;

  /// 轮播图高度
  final double height;

  /// 是否显示文字叠加
  ///
  /// 默认值为false
  final bool showTextOverlay;

  /// 指示器位置
  ///
  /// 默认值为IndicatorPosition.center
  final IndicatorPosition indicatorPosition;

  /// 文字颜色
  ///
  /// 默认值为白色
  final Color textColor;

  const BannerCarousel({
    super.key,
    required this.banners,
    this.height = 160,
    this.showTextOverlay = false,
    this.indicatorPosition = IndicatorPosition.center,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCarousel(
      itemCount: banners.length,
      height: height,
      autoPlay: true,
      showIndicator: true,
      indicatorPosition: indicatorPosition,
      indicatorBackgroundColor: Colors.transparent,
      itemBuilder: (context, index) {
        final banner = banners[index];
        return GestureDetector(
          onTap: banner.onTap,
          child: Stack(
            children: [
              // Banner图片
              _buildBannerImage(banner),

              // 文字叠加（可选）
              if (showTextOverlay &&
                  (banner.title != null || banner.subtitle != null))
                _buildTextOverlay(banner),
            ],
          ),
        );
      },
    );
  }

  /// 构建Banner图片
  Widget _buildBannerImage(BannerItem banner) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.network(
          banner.imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }

  /// 构建文字叠加层
  Widget _buildTextOverlay(BannerItem banner) {
    return Positioned(
      bottom: 40, // 在指示器上方
      left: 16,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (banner.title != null)
            Text(
              banner.title!,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 4.0, color: Colors.black54)],
              ),
            ),
          if (banner.subtitle != null)
            Text(
              banner.subtitle!,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                shadows: [Shadow(blurRadius: 4.0, color: Colors.black54)],
              ),
            ),
        ],
      ),
    );
  }
}
