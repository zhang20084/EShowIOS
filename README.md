# EShowIOS
EShowIOS 是EShow开源框架中的iOS框架

####下面介绍一下文件的大概目录先：
    .
    ├── EShowIOS
    │   ├── AppDelegate
    │   ├── Models：数据类
    │   ├── Views：视图类
    │   │   ├── CCell：所有的CollectionViewCell都在这里
    │   │   ├── Cell：所有的TableViewCell都在这里
    │   │   └── XXX：其它功能块所需要使用到的视图层单独建立
    │   ├── Controllers：控制器，对应app中的各个页面
    │   │   ├── Login：登录页面
    │   │   ├── RootControllers：登录后的根页面
    │   │   ├── PersonalInformation：设置信息页面
    │   │   └── XXX：其它页面
    │   ├── Images：app中用到的所有的图片都在这里
    │   ├── Resources：资源文件
    │   ├── Util：一些常用控件和Category、Manager之类
    │   │   ├── Common
    │   │   ├── Manager
    │   │   ├── OC_Category
    │   │   └── ObjcRuntime
    │   └── Vendor：用到的一些第三方类库，一般都有改动
    └── Pods：项目使用了[CocoaPods](http://code4app.com/article/cocoapods-install-usage)这个类库管理工具

####再说下项目的启动流程：
在AppDelegate的启动方法中，先设置了一下Appearance的样式，然后根据用户的登录状态选择是去加载登录页面LoginViewController，还是登录后的RootTabViewController页面。

####介绍一下项目中有哪些功能点
EShowIOS包含了大部分app都会使用到的一个信息表单功能(包含头像上传,信息修改),图片列表,文件下载,城市选择,音乐播放,地图,支付,分享,即时通讯,透传消息,扫一扫.

####介绍一下项目中使用到的一些sdk
在登陆时使用的是友盟的第三方登陆.地图集成了高德地图,在里面调用的是直接搜索周边信息的方法,同样也可以使用高德的web显示来实现功能的开发.支付集成了ping++.

####最后说下[CocoaPods](http://cocoapods.org/)里面用到的第三方类库
 - [SDWebImage](https://github.com/rs/SDWebImage)：图片加载
 - [TTTAttributedLabel](https://github.com/TTTAttributedLabel/TTTAttributedLabel)：富文本的label，可点击链接
 - [RegexKitLite](https://github.com/wezm/RegexKitLite)：正则表达式
 - [hpple](https://github.com/topfunky/hpple)：html解析
 - [MBProgressHUD](https://github.com/jdg/MBProgressHUD)：hud提示框
 - [ODRefreshControl](https://github.com/Sephiroth87/ODRefreshControl)：下拉刷新
 - [TPKeyboardAvoiding](https://github.com/michaeltyson/TPKeyboardAvoiding)：有文字输入时，能根据键盘是否弹出来调整自身显示内容的位置
 - [JDStatusBarNotification](https://github.com/jaydee3/JDStatusBarNotification)：状态栏提示框
 - [BlocksKit](https://github.com/zwaldowski/BlocksKit)：block工具包。将很多需要用delegate实现的方法整合成了block的形式
 - [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)：基于响应式编程思想的oc实践（是个好东西呢）
 
####License
EShowIOS is available under the MIT license. See the LICENSE file for more info.
