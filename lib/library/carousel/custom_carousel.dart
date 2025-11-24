import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

/// 轮播图项构建器类型定义
typedef CarouselItemBuilder = Widget Function(BuildContext context, int index);

/// 页面改变回调类型定义
typedef OnPageChanged =
    void Function(int index, CarouselPageChangedReason reason);

/// 指示器构建器类型定义
typedef IndicatorBuilder = Widget Function(int itemCount, int currentPage);

/// 指示器位置枚举
enum IndicatorPosition {
  /// 左侧对齐
  left,

  /// 居中对齐
  center,

  /// 右侧对齐
  right,
}

/// 自定义轮播图组件
///
/// 一个高度可配置的轮播图组件，支持自动播放、无限循环、自定义指示器等功能。
/// 指示器可以配置在图片上的左、中、右位置。
class CustomCarousel extends StatefulWidget {
  /// 轮播图项数量
  final int itemCount;

  /// 轮播图项构建器
  ///
  /// [context]: 构建上下文
  /// [index]: 当前项的索引
  final CarouselItemBuilder itemBuilder;

  /// 轮播图高度
  ///
  /// 如果为null，则使用[aspectRatio]计算高度
  final double? height;

  /// 轮播图宽高比
  ///
  /// 默认值为16/9，只有在[height]为null时生效
  final double aspectRatio;

  /// 是否自动播放
  ///
  /// 默认值为true
  final bool autoPlay;

  /// 自动播放间隔时间
  ///
  /// 默认值为3秒
  final Duration autoPlayInterval;

  /// 自动播放动画持续时间
  ///
  /// 默认值为800毫秒
  final Duration autoPlayAnimationDuration;

  /// 自动播放动画曲线
  ///
  /// 默认值为Curves.fastOutSlowIn
  final Curve autoPlayCurve;

  /// 视口分数，控制可见区域的大小
  ///
  /// 取值范围为0.0-1.0，默认值为1.0（全屏）
  final double viewportFraction;

  /// 是否放大居中页面
  ///
  /// 默认值为false
  final bool enlargeCenterPage;

  /// 滚动方向
  ///
  /// 默认值为Axis.horizontal（水平方向）
  final Axis scrollDirection;

  /// 触摸时是否暂停自动播放
  ///
  /// 默认值为true
  final bool pauseAutoPlayOnTouch;

  /// 页面改变回调函数
  ///
  /// [index]: 改变后的页面索引
  /// [reason]: 改变原因（手动、自动等）
  final OnPageChanged? onPageChanged;

  /// 初始页面索引
  ///
  /// 默认值为0（第一页）
  final int initialPage;

  /// 是否启用无限循环
  ///
  /// 默认值为true
  final bool enableInfiniteScroll;

  /// 是否反向滚动
  ///
  /// 默认值为false
  final bool reverse;

  /// 滚动物理效果
  ///
  /// 可自定义滚动行为，如禁止滚动等
  final ScrollPhysics? scrollPhysics;

  /// 是否显示指示器
  ///
  /// 默认值为true
  final bool showIndicator;

  /// 自定义指示器构建器
  ///
  /// 如果为null，则使用默认指示器样式
  final IndicatorBuilder? indicatorBuilder;

  /// 指示器位置
  ///
  /// 支持左、中、右三个位置，默认值为IndicatorPosition.center
  final IndicatorPosition indicatorPosition;

  /// 指示器边距
  ///
  /// 用于控制指示器距离容器边缘的距离，默认底部16像素
  final EdgeInsets indicatorMargin;

  /// 指示器颜色（当前页）
  ///
  /// 如果为null，则使用白色
  final Color? indicatorColor;

  /// 指示器背景颜色
  ///
  /// 如果为null，则使用半透明黑色
  final Color? indicatorBackgroundColor;

  /// 指示器尺寸
  ///
  /// 默认值为6.0
  final double indicatorSize;

  /// 指示器尺寸（当前页）
  ///
  /// 默认值为8.0
  final double indicatorActiveSize;

  const CustomCarousel({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.height,
    this.aspectRatio = 16 / 9,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
    this.autoPlayCurve = Curves.fastOutSlowIn,
    this.viewportFraction = 1.0,
    this.enlargeCenterPage = false,
    this.scrollDirection = Axis.horizontal,
    this.pauseAutoPlayOnTouch = true,
    this.onPageChanged,
    this.initialPage = 0,
    this.enableInfiniteScroll = true,
    this.reverse = false,
    this.scrollPhysics,
    this.showIndicator = true,
    this.indicatorBuilder,
    this.indicatorPosition = IndicatorPosition.center,
    this.indicatorMargin = const EdgeInsets.only(bottom: 16),
    this.indicatorColor,
    this.indicatorBackgroundColor,
    this.indicatorSize = 6.0,
    this.indicatorActiveSize = 8.0,
  });

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // 轮播图主体
        CarouselSlider(
          items: _buildItems(),
          options: CarouselOptions(
            height: widget.height,
            aspectRatio: widget.aspectRatio,
            viewportFraction: widget.viewportFraction,
            initialPage: widget.initialPage,
            enableInfiniteScroll: widget.enableInfiniteScroll,
            reverse: widget.reverse,
            autoPlay: widget.autoPlay,
            autoPlayInterval: widget.autoPlayInterval,
            autoPlayAnimationDuration: widget.autoPlayAnimationDuration,
            autoPlayCurve: widget.autoPlayCurve,
            enlargeCenterPage: widget.enlargeCenterPage,
            scrollDirection: widget.scrollDirection,
            scrollPhysics: widget.scrollPhysics,
            pauseAutoPlayOnTouch: widget.pauseAutoPlayOnTouch,
            onPageChanged: (index, reason) {
              setState(() {
                _currentPage = index;
              });
              widget.onPageChanged?.call(index, reason);
            },
          ),
        ),

        // 指示器
        if (widget.itemCount > 1 && widget.showIndicator) _buildIndicator(),
      ],
    );
  }

  List<Widget> _buildItems() {
    return List.generate(widget.itemCount, (index) {
      return widget.itemBuilder(context, index);
    });
  }

  Widget _buildIndicator() {
    // 如果提供了自定义指示器，使用自定义的
    if (widget.indicatorBuilder != null) {
      return _buildPositionedIndicator(
        widget.indicatorBuilder!(widget.itemCount, _currentPage),
      );
    }

    return _buildPositionedIndicator(_buildDefaultIndicator());
  }

  Widget _buildPositionedIndicator(Widget indicator) {
    // 指示器背景容器
    final container = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: widget.indicatorBackgroundColor ?? Colors.black54,
        borderRadius: BorderRadius.circular(20),
      ),
      child: indicator,
    );

    // 根据位置返回不同的对齐方式
    switch (widget.indicatorPosition) {
      case IndicatorPosition.left:
        return Positioned(
          left: widget.indicatorMargin.left,
          bottom: widget.indicatorMargin.bottom,
          child: container,
        );
      case IndicatorPosition.right:
        return Positioned(
          right: widget.indicatorMargin.right,
          bottom: widget.indicatorMargin.bottom,
          child: container,
        );
      case IndicatorPosition.center:
        return Positioned(
          left: 0,
          right: 0,
          bottom: widget.indicatorMargin.bottom,
          child: Center(child: container),
        );
    }
  }

  Widget _buildDefaultIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.itemCount, (index) {
        final isActive = _currentPage == index;
        return Container(
          width: isActive ? widget.indicatorActiveSize : widget.indicatorSize,
          height: isActive ? widget.indicatorActiveSize : widget.indicatorSize,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? (widget.indicatorColor ?? Colors.white)
                : Colors.grey[400],
          ),
        );
      }),
    );
  }
}
