# flutter_library

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



# Flutter 安装

1⃣️ 安装 Android Studio

1. 访问 Android Studio 官网，下载 macOS 版本，解压 .dmg 文件，将图标拖拽到 Applications 文件夹

2. 首次运行时选择 "Standard" 安装类型，确保勾选：
    * ✅ Android SDK
    * ✅ Android SDK Platform-Tools
    * ✅ Android Emulator

3. 打开Android Studio，setting->plugins，安装插件 Flutter、Dart，Flutter Snippets

2⃣️ 安装 Flutter SDK

1. 下载 SDK

	```
	cd ~/development 
	//若无此目录，先执行 mkdir ~/development
   git clone https://github.com/flutter/flutter.git -b stable
	```

2. 配置环境变量
	
	```
	//编辑 .zshrc（Catalina 及以上系统） 
	nano ~/.zshrc
      //添加以下内容
   	export PATH="$PATH:$HOME/development/flutter/bin"
	```
	 
   * 配置国内镜像源（关键步骤）
   
   	```
   #添加以下内容（任选一组镜像源）

   //清华大学镜像源
   export PUB_HOSTED_URL=https://mirrors.tuna.tsinghua.edu.cn/dart-pub
	export FLUTTER_STORAGE_BASE_URL=https://mirrors.tuna.tsinghua.edu.cn/flutter

   //上海交大镜像源（备选）
   # export PUB_HOSTED_URL=https://dart-pub.mirrors.sjtug.sjtu.edu.cn
   # export FLUTTER_STORAGE_BASE_URL=https://mirrors.sjtug.sjtu.edu.cn

   //保存后生效
   source ~/.zshrc
	```
	
3. 检查版本会自动安装dart
   * flutter --version

4. 预下载依赖
   * flutter precache

5. 运行环境检查
   * flutter doctor

6. 常见命令
   * 清除项目并安装
   
   ```
   flutter clean
   rm -rf pubspec.lock
   flutter pub upgrade --major-versions  /  flutter pub get
   flutter run   /   flutter run -d <ios_device_id>
   ```
   * 清除ios
   
   ```
   cd ios
   pod deintegrate
   rm -rf Pods Podfile.lock
   pod install --repo-update
   cd ..
   flutter run -d ios
   ```
   * 清除android

   ```
   cd android
   ./gradlew clean
   cd ..
   flutter run -d android
   ```
   * 构建调试包
    
   ```
   flutter build ios --debug --no-codesign
   ```
   * 构建发布
   
   ```
   flutter build apk --release
   flutter build ios --release
   flutter build ipa
   ```

### flutter 插件

 * Flutter Snippets - 提供大量常用 Flutter 代码片段
 * Flutter Enhancement Suite - 增强 Flutter 开发体验
 * Flutter Intl - 国际化（i18n）的插件
 * FlutterJsonBeanFactory