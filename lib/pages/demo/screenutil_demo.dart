import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenutilDemo extends StatelessWidget {
  const ScreenutilDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // 设计稿尺寸 (单位: dp)
      designSize: const Size(375, 812),
      // iPhone 13 尺寸
      // 是否根据宽度/高度中的最小值适配文字
      minTextAdapt: true,
      // 分屏模式适配
      splitScreenMode: true,

      // 构建器
      builder: (context, child) {
        // return MaterialApp(
        //   title: '屏幕适配示例',
        //   theme: ThemeData(primarySwatch: Colors.blue),
        //   home: child,
        // );
        return Container(child: child);
      },
      child: const ScreenutilPage(),
    );
  }
}

class ScreenutilPage extends StatelessWidget {
  const ScreenutilPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 正确的初始化方式 - 只需要在需要获取屏幕信息时调用
    final screenUtil = ScreenUtil();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '屏幕适配示例',
          style: TextStyle(
            fontSize: 18.sp, // 使用 .sp 适配字体大小
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w), // 使用 .w 适配宽度方向的padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 尺寸适配示例
            _buildSizeAdaptationExample(),

            SizedBox(height: 20.h), // 使用 .h 适配高度
            // 2. 间距适配示例
            _buildSpacingAdaptationExample(),

            SizedBox(height: 20.h),

            // 3. 字体适配示例
            _buildTextAdaptationExample(),

            SizedBox(height: 20.h),

            // 4. 圆角边框适配示例
            _buildBorderAdaptationExample(),

            SizedBox(height: 20.h),

            // 5. 响应式布局示例
            _buildResponsiveLayoutExample(screenUtil),
          ],
        ),
      ),
    );
  }

  // 尺寸适配示例组件
  Widget _buildSizeAdaptationExample() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1. 尺寸适配',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Container(
              width: 100.w,
              // 设计稿中 100dp 的宽度
              height: 60.h,
              // 设计稿中 60dp 的高度
              color: Colors.blue,
              alignment: Alignment.center,
              child: Text(
                '100×60',
                style: TextStyle(fontSize: 12.sp, color: Colors.white),
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              width: 150.w,
              // 设计稿中 150dp 的宽度
              height: 80.h,
              // 设计稿中 80dp 的高度
              color: Colors.green,
              alignment: Alignment.center,
              child: Text(
                '150×80',
                style: TextStyle(fontSize: 12.sp, color: Colors.white),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Text(
          '使用说明:',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
        Text(
          '.w - 基于宽度的尺寸适配',
          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
        ),
        Text(
          '.h - 基于高度的尺寸适配',
          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
        ),
      ],
    );
  }

  // 间距适配示例组件
  Widget _buildSpacingAdaptationExample() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '2. 间距适配',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w, // 水平方向 20dp
            vertical: 15.h, // 垂直方向 15dp
          ),
          decoration: BoxDecoration(
            color: Colors.orange[100],
            border: Border.all(color: Colors.orange),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSpacingBox(Colors.red),
                  _buildSpacingBox(Colors.green),
                  _buildSpacingBox(Colors.blue),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSpacingBox(Colors.purple),
                  _buildSpacingBox(Colors.amber),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpacingBox(Color color) {
    return Container(width: 50.w, height: 50.h, color: color);
  }

  // 字体适配示例组件
  Widget _buildTextAdaptationExample() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '3. 字体大小适配',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.all(16.r), // 使用 .r 同时适配宽高方向
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            children: [
              Text(
                '超大标题 - 24.sp',
                style: TextStyle(
                  fontSize: 24.sp, // 设计稿中 24dp 的字体
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                '普通正文 - 16.sp',
                style: TextStyle(
                  fontSize: 16.sp, // 设计稿中 16dp 的字体
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                '小号说明 - 12.sp',
                style: TextStyle(
                  fontSize: 12.sp, // 设计稿中 12dp 的字体
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                '字体也会根据屏幕尺寸自动缩放',
                style: TextStyle(
                  fontSize: 14.sp, // 使用 .sp 自动适配
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          '使用说明:',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
        Text(
          '.sp - 字体大小适配，会根据屏幕尺寸和系统字体设置缩放',
          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
        ),
      ],
    );
  }

  // 圆角边框适配示例
  Widget _buildBorderAdaptationExample() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '4. 圆角边框适配',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(8.r), // 8dp 圆角
                border: Border.all(
                  color: Colors.purple,
                  width: 2.w, // 边框宽度适配
                ),
              ),
              child: Icon(
                Icons.star,
                size: 24.r, // 图标大小适配
                color: Colors.purple,
              ),
            ),
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.teal[100],
                borderRadius: BorderRadius.circular(20.r), // 20dp 圆角
                border: Border.all(
                  color: Colors.teal,
                  width: 1.w, // 边框宽度适配
                ),
              ),
              child: Icon(Icons.favorite, size: 24.r, color: Colors.teal),
            ),
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.pink[100],
                borderRadius: BorderRadius.circular(40.r), // 40dp 圆角（圆形）
                border: Border.all(
                  color: Colors.pink,
                  width: 3.w, // 边框宽度适配
                ),
              ),
              child: Icon(Icons.thumb_up, size: 24.r, color: Colors.pink),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Text(
          '使用说明:',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
        Text(
          '.r - 圆角、边框等同时需要宽高适配的场景',
          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
        ),
      ],
    );
  }

  // 响应式布局示例
  Widget _buildResponsiveLayoutExample(ScreenUtil screenUtil) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '5. 响应式布局',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),

        // 屏幕尺寸信息展示
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '屏幕信息:',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8.h),
              Text('屏幕宽度: ${screenUtil.screenWidth}px'),
              Text('屏幕高度: ${screenUtil.screenHeight}px'),
              Text('像素密度: ${screenUtil.pixelRatio}'),
              Text('宽度比例: ${screenUtil.scaleWidth}'),
              Text('高度比例: ${screenUtil.scaleHeight}'),
              Text('状态栏高度: ${screenUtil.statusBarHeight}px'),
              Text('底部安全区域: ${screenUtil.bottomBarHeight}px'),
            ],
          ),
        ),

        SizedBox(height: 15.h),

        // 响应式网格布局
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
          childAspectRatio: 1.5,
          // 宽高比
          children: List.generate(4, (index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.primaries[index % Colors.primaries.length],
                borderRadius: BorderRadius.circular(12.r),
              ),
              alignment: Alignment.center,
              child: Text(
                '项目 ${index + 1}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
        ),

        SizedBox(height: 15.h),
        Text('注意事项'),
        ImportantNotes(),
      ],
    );
  }
}

///ScreenUtil 正确使用方法
// 在任意地方使用 ScreenUtil 的方法
class UtilsExample {
  void demonstrateScreenUtilMethods(BuildContext context) {
    // 获取 ScreenUtil 实例
    final screenUtil = ScreenUtil();

    // 尺寸适配方法
    double width = 100.w; // 宽度适配: 设计稿 100dp → 实际宽度
    double height = 50.h; // 高度适配: 设计稿 50dp → 实际高度
    double radius = 8.r; // 圆角适配: 设计稿 8dp → 实际圆角
    double fontSize = 16.sp; // 字体适配: 设计稿 16dp → 实际字体大小

    // 获取屏幕信息
    double screenWidth = screenUtil.screenWidth; // 屏幕宽度
    double screenHeight = screenUtil.screenHeight; // 屏幕高度
    double pixelRatio = screenUtil.pixelRatio as double; // 设备像素比
    double scaleWidth = screenUtil.scaleWidth; // 宽度缩放比例
    double scaleHeight = screenUtil.scaleHeight; // 高度缩放比例

    // 安全区域
    double statusBarHeight = screenUtil.statusBarHeight; // 状态栏高度
    double bottomBarHeight = screenUtil.bottomBarHeight; // 底部安全区域高度

    // 尺寸转换方法 (可选，直接使用扩展更简洁)
    double actualWidth = screenUtil.setWidth(100); // 同 100.w
    double actualHeight = screenUtil.setHeight(50); // 同 50.h
    double actualSp = screenUtil.setSp(16); // 同 16.sp
    double radius2 = screenUtil.radius(8); // 同 8.r
  }
}

class ImportantNotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '使用 ScreenUtil 的注意事项:',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          _buildNoteItem('1. 设计稿尺寸单位是 dp，不是 px'),
          _buildNoteItem('2. .w 基于宽度适配，.h 基于高度适配'),
          _buildNoteItem('3. .sp 用于字体大小适配（会自动考虑系统字体大小）'),
          _buildNoteItem('4. .r 用于圆角、边框等同时需要宽高适配的场景'),
          _buildNoteItem('5. 确保在 MaterialApp 外层包裹 ScreenUtilInit'),
          _buildNoteItem('6. 不需要手动调用 ScreenUtil.init()'),
          _buildNoteItem('7. 在 StatelessWidget 中直接使用 .w .h .sp .r 扩展'),
          _buildNoteItem('8. 在需要屏幕信息时，使用 ScreenUtil() 实例'),
          _buildNoteItem('9. ssp 已废弃，统一使用 sp 进行字体适配'),
        ],
      ),
    );
  }

  Widget _buildNoteItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 8.r),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }
}
