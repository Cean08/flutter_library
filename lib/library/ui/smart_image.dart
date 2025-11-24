import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:typed_data';
import 'dart:io';

/// 统一的图片加载组件
class SmartImage extends StatelessWidget {
  final String? path;
  final Uint8List? memoryBytes;

  // 图片通用属性
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final BlendMode? colorBlendMode;
  final Alignment alignment;
  final ImageRepeat repeat;
  final bool matchTextDirection;
  final FilterQuality filterQuality;
  final bool gaplessPlayback;

  // 网络图片特有属性
  final Widget? placeholder;
  final Widget? errorWidget;
  final Duration? fadeInDuration;
  final Duration? fadeOutDuration;
  final Curve? fadeInCurve;
  final Curve? fadeOutCurve;
  final bool useOldImageOnUrlChange;
  final Map<String, String>? httpHeaders;

  const SmartImage._({
    Key? key,
    this.path,
    this.memoryBytes,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.colorBlendMode,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.filterQuality = FilterQuality.low,
    this.gaplessPlayback = false,
    this.placeholder,
    this.errorWidget,
    this.fadeInDuration,
    this.fadeOutDuration,
    this.fadeInCurve,
    this.fadeOutCurve,
    this.useOldImageOnUrlChange = false,
    this.httpHeaders,
  }) : super(key: key);

  /// 智能图片加载 - 根据路径自动判断类型
  factory SmartImage({
    Key? key,
    required String path,
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
    BlendMode? colorBlendMode,
    Alignment alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    bool matchTextDirection = false,
    FilterQuality filterQuality = FilterQuality.low,
    bool gaplessPlayback = false,
    Widget? placeholder,
    Widget? errorWidget,
    Duration? fadeInDuration,
    Duration? fadeOutDuration,
    Curve? fadeInCurve,
    Curve? fadeOutCurve,
    bool useOldImageOnUrlChange = false,
    Map<String, String>? httpHeaders,
  }) {
    return SmartImage._(
      key: key,
      path: path,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      alignment: alignment,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      filterQuality: filterQuality,
      gaplessPlayback: gaplessPlayback,
      placeholder: placeholder,
      errorWidget: errorWidget,
      fadeInDuration: fadeInDuration,
      fadeOutDuration: fadeOutDuration,
      fadeInCurve: fadeInCurve,
      fadeOutCurve: fadeOutCurve,
      useOldImageOnUrlChange: useOldImageOnUrlChange,
      httpHeaders: httpHeaders,
    );
  }

  /// 加载内存图片
  factory SmartImage.memory({
    Key? key,
    required Uint8List bytes,
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
    BlendMode? colorBlendMode,
    Alignment alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    bool matchTextDirection = false,
    FilterQuality filterQuality = FilterQuality.low,
    bool gaplessPlayback = false,
  }) {
    return SmartImage._(
      key: key,
      memoryBytes: bytes,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      alignment: alignment,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      filterQuality: filterQuality,
      gaplessPlayback: gaplessPlayback,
    );
  }

  /// 判断图片类型
  ImageType get _imageType {
    if (memoryBytes != null) return ImageType.memory;
    if (path == null) return ImageType.asset; // 默认类型

    final uri = Uri.tryParse(path!);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return ImageType.network;
    }

    if (path!.startsWith('assets/')) {
      return ImageType.asset;
    }

    // 检查是否为文件路径
    if (path!.contains('/') || path!.contains('\\')) {
      return ImageType.file;
    }

    // 默认为资源图片
    return ImageType.asset;
  }

  @override
  Widget build(BuildContext context) {
    switch (_imageType) {
      case ImageType.asset:
        return _buildAssetImage();
      case ImageType.network:
        return _buildNetworkImage();
      case ImageType.file:
        return _buildFileImage();
      case ImageType.memory:
        return _buildMemoryImage();
    }
  }

  /// 构建资源图片
  Widget _buildAssetImage() {
    return Image.asset(
      path!,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      alignment: alignment,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      filterQuality: filterQuality,
      gaplessPlayback: gaplessPlayback,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ??
            Icon(Icons.error, color: Colors.grey, size: _getErrorIconSize());
      },
    );
  }

  /// 构建网络图片（使用cached_network_image）
  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      imageUrl: path!,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      alignment: alignment,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      filterQuality: filterQuality,
      placeholder: placeholder != null
          ? (context, url) => placeholder!
          : (context, url) => _defaultPlaceholder(),
      errorWidget: errorWidget != null
          ? (context, url, error) => errorWidget!
          : (context, url, error) => _defaultErrorWidget(),
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 300),
      fadeOutDuration: fadeOutDuration ?? const Duration(milliseconds: 300),
      fadeInCurve: fadeInCurve ?? Curves.easeIn,
      fadeOutCurve: fadeOutCurve ?? Curves.easeOut,
      httpHeaders: httpHeaders,
    );
  }

  /// 构建文件图片
  Widget _buildFileImage() {
    return Image.file(
      File(path!),
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      alignment: alignment,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      filterQuality: filterQuality,
      gaplessPlayback: gaplessPlayback,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ??
            Icon(Icons.error, color: Colors.grey, size: _getErrorIconSize());
      },
    );
  }

  /// 构建内存图片
  Widget _buildMemoryImage() {
    return Image.memory(
      memoryBytes!,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      alignment: alignment,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      filterQuality: filterQuality,
      gaplessPlayback: gaplessPlayback,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ??
            Icon(Icons.error, color: Colors.grey, size: _getErrorIconSize());
      },
    );
  }

  /// 默认占位符
  Widget _defaultPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: SizedBox(
          width: _getLoadingIndicatorSize(),
          height: _getLoadingIndicatorSize(),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
          ),
        ),
      ),
    );
  }

  /// 默认错误组件
  Widget _defaultErrorWidget() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.error_outline,
          color: Colors.grey[400],
          size: _getErrorIconSize(),
        ),
      ),
    );
  }

  /// 根据图片尺寸获取加载指示器大小
  double _getLoadingIndicatorSize() {
    final size = width ?? height ?? 60;
    return size * 0.3;
  }

  /// 根据图片尺寸获取错误图标大小
  double _getErrorIconSize() {
    final size = width ?? height ?? 60;
    return size * 0.4;
  }
}

/// 图片类型枚举
enum ImageType {
  asset,      // 本地资源
  network,    // 网络图片
  file,       // 本地文件
  memory,     // 内存图片
}

/// 便捷扩展方法
extension SmartImageExtension on String {
  /// 将字符串转换为智能图片
  Widget toImage({
    Key? key,
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
    BlendMode? colorBlendMode,
    Alignment alignment = Alignment.center,
    Widget? placeholder,
    Widget? errorWidget,
    Curve? fadeInCurve, // 添加 Curve 参数
    Curve? fadeOutCurve, // 添加 Curve 参数
  }) {
    return SmartImage(
      path: this,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      alignment: alignment,
      placeholder: placeholder,
      errorWidget: errorWidget,
      fadeInCurve: fadeInCurve,
      fadeOutCurve: fadeOutCurve,
    );
  }
}