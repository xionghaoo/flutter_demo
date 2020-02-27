# flutter_demo
> flutter开发练习

## 基础功能
> 开发中经常会用到一些基础功能

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
- [x] 基本的原生调用(插件方式和非插件方式)
- [x] Android高德地图集成
- [ ] iOS高德地图集成
- [ ] app打包
- [ ] 图片选择上传
- [ ] BLoC集成(State管理框架)
- [ ] Scoped Model集成(State管理框架)
- [ ] 二维码扫描
- [ ] 屏幕适配
- [ ] ChangeNotifier

## Wallie(完整的app)

- [x] 登陆/退出
- [x] 首页tabs切换/下拉刷新
- [x] Bill页面(下拉刷新)
- [x] 集成Redux

## 动画效果示例

|  |  |
| --- | --- |
| <img src="https://github.com/xionghaoo/flutter_demo/blob/master/screens/tab%E5%88%87%E6%8D%A2%E5%8A%A8%E7%94%BB.gif" width="300"/> | <img src="https://github.com/xionghaoo/flutter_demo/blob/master/screens/%E5%A4%AA%E6%9E%81%E5%8A%A8%E7%94%BB.gif" width="300"/> |

## 高德地图
> Flutter提供原生View的渲染方式，可以像使用Flutter Widget一样使用Native View

Android显示效果

<img src="https://github.com/xionghaoo/flutter_demo/blob/master/screens/Android_amap.jpg" width="300"/>

## Flutter 1.12版本以前的插件升级（v1 -> v2）
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

## Json Serialize
> 官方文档：[JSON and serialization](https://flutter.dev/docs/development/data-and-backend/json)

Json序列化，代码手动生成命令
```
flutter pub run build_runner build
```
    