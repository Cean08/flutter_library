import 'package:flutter/material.dart';
import './custom_carousel.dart';
import './image_carousel.dart';
import './banner_carousel.dart';

/// 轮播图使用示例页面
class CarouselExample extends StatelessWidget {
  /// 示例图片URL列表
  final List<String> imageUrls = [
    'https://picsum.photos/400/200?random=1',
    'https://picsum.photos/400/200?random=2',
    'https://picsum.photos/400/200?random=3',
  ];

  CarouselExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('轮播图示例 - 指示器在图片上')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. 指示器在底部中央
            ImageCarousel(
              imageUrls: imageUrls,
              height: 200,
              indicatorPosition: IndicatorPosition.center,
            ),

            // 2. 指示器在底部左侧
            ImageCarousel(
              imageUrls: imageUrls,
              height: 200,
              indicatorPosition: IndicatorPosition.left,
              indicatorMargin: const EdgeInsets.only(bottom: 16, left: 16),
            ),

            // 3. 指示器在底部右侧，自定义了颜色和背景',
            ImageCarousel(
              imageUrls: imageUrls,
              height: 200,
              indicatorPosition: IndicatorPosition.right,
              indicatorMargin: const EdgeInsets.only(bottom: 16, right: 16),
              indicatorColor: Colors.amber,
              indicatorBackgroundColor: Colors.transparent,
            ),

            // 4. Banner轮播带文字叠加, Banner轮播图，支持标题和副标题叠加显示,
            BannerCarousel(
              banners: [
                BannerItem(
                  imageUrl: imageUrls[0],
                  title: '促销活动标题1',
                  subtitle: '限时优惠，立即购买',
                  onTap: () => print('点击Banner1'),
                ),
                BannerItem(
                  imageUrl: imageUrls[1],
                  title: '促销活动标题2',
                  subtitle: '新品上市，抢先体验',
                ),
              ],
              height: 180,
              showTextOverlay: true,
              indicatorPosition: IndicatorPosition.right,
            ),

            // 5. 完全自定义的轮播, 使用CustomCarousel直接构建，完全控制每个轮播项
            CustomCarousel(
              itemCount: 4,
              height: 150,
              viewportFraction: 0.9,
              enlargeCenterPage: true,
              indicatorPosition: IndicatorPosition.left,
              indicatorMargin: const EdgeInsets.only(bottom: 10, left: 10),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: [
                      Colors.red,
                      Colors.green,
                      Colors.blue,
                      Colors.orange,
                    ][index],
                  ),
                  child: Center(
                    child: Text(
                      '自定义项目 ${index + 1}',
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                );
              },
              onPageChanged: (index, reason) {
                print('切换到第 $index 页, 原因: $reason');
              },
            ),
          ],
        ),
      ),
    );
  }
}
