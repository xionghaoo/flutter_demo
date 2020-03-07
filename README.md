# flutter_demo
> flutter开发练习

## Flutter层功能
> flutter层的功能，一些基础的widget、Animation、state manage

[官方Cookbook](https://flutter.dev/docs/cookbook)

- [x] 搜索框
- [x] 网络请求(异步加载和json序列化)
- [x] 底部tabs切换
- [x] 顶部tabs切换
- [x] 下拉刷新
- [x] PageView(滑动切换页面)
- [x] Redux集成
- [x] Sqlite(本地数据库)
- [x] SharedPreferences(键值对本地存储)
- [x] 动画
- [x] 表单
- [x] 相机
- [ ] app打包
- [ ] 图片选择上传
- [ ] BLoC集成(State管理框架)
- [ ] Scoped Model集成(State管理框架)
- [ ] 屏幕适配
- [ ] ChangeNotifier

### 自定义Widget
- [x] 级联选择器(地址选择)

## Native Plugin
> Flutter提供了丰富的插件接口，flutter层可以很好的和native层进行交互

- [x] MethodChannel方式调用原生
- [x] 简单视图类型插件，文本视图使用原生控件(TextView/UILabel)显示
- [x] Android高德地图集成
- [ ] iOS高德地图集成
- [ ] 二维码扫描

## Wallie app

- [x] 登陆页面
- [x] 首页tabs切换
- [x] Bill页面(下拉刷新)
- [x] 集成Redux

## 效果示例

| 名称 | 显示效果 | 名称 | 显示效果 |
| --- | --- | --- | --- |
| 水滴Tab切换 | <img src="https://github.com/xionghaoo/flutter_demo/blob/master/screens/tab%E5%88%87%E6%8D%A2%E5%8A%A8%E7%94%BB.gif" width="300"/> |  太极动画 | <img src="https://github.com/xionghaoo/flutter_demo/blob/master/screens/%E5%A4%AA%E6%9E%81%E5%8A%A8%E7%94%BB.gif" width="300"/> |
| Android高德地图 | <img src="https://github.com/xionghaoo/flutter_demo/blob/master/screens/Android_amap.jpg" width="300"/> | 地址选择器 | <img src="https://github.com/xionghaoo/flutter_demo/blob/master/screens/address_selector.gif" width="300"/> |

## 参考资料

### 原生插件部分
> 官方的插件项目[flutter plugins](https://github.com/flutter/plugins)

[Writing custom platform-specific code](https://flutter.dev/docs/development/platform-integration/platform-channels)

[在Flutter中嵌入Native组件的正确姿势是...](https://juejin.im/post/5bed04d96fb9a049a42e9c40)

[Flutter PlatformView: How to create Widgets from Native Views](https://medium.com/flutter-community/flutter-platformview-how-to-create-flutter-widgets-from-native-views-366e378115b6)

[How to use Native UIs in Flutter with Swift & Platform View](https://medium.com/@phoomparin/how-to-use-native-uis-in-flutter-with-swift-platform-view-8b4dc7f833d8)

## 其他
### Flutter 1.12版本以前的插件升级（v1 -> v2）
> Flutter的插件注册现在分为v1版本和v2版本

官方文档

[Supporting the new Android plugins APIs](https://flutter.dev/docs/development/packages-and-plugins/plugin-api-migration)

[Upgrading pre 1.12 Android projects](https://github.com/flutter/flutter/wiki/Upgrading-pre-1.12-Android-projects)

需要注意的是：
+ 使用新版的io.flutter.embedding.android.FlutterActivity以后，会发现插件不能用PluginRegistry方式注册，可以借助ShimPluginRegistry来注册老版本的插件，新版本的插件直接用flutterEngine.plugins.add()方法添加就行了。不需要使用自动生成的GeneratedPluginRegistrant类
+ MethodChannel在io.flutter.app.FlutterActivity(v1版本)中使用的是flutterView，在io.flutter.embedding.android.FlutterActivity(v2版本)中可以用flutterEngine.dartExecutor替代

```kotlin
override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    // v2 version plugin register
    flutterEngine.plugins.add(CameraPlugin())
    ...
    
    // v1 version plugin register
    val registry = ShimPluginRegistry(flutterEngine)
    FluttertoastPlugin.registerWith(registry.registrarFor("io.github.ponnamkarthik.toast.fluttertoast.FluttertoastPlugin"))
    ...
    
    MethodChannel(flutterEngine.dartExecutor, CHANNEL).setMethodCallHandler { ... }
}
```

### Json Serialize
> 官方文档：[JSON and serialization](https://flutter.dev/docs/development/data-and-backend/json)

Json序列化，代码手动生成命令
```
flutter pub run build_runner build
```
    