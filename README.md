# EShowIOS
EShowIOS 是EShow开源框架中的iOS框架

####下面介绍一下文件的大概目录先：
    .
    ├── Coding_iOS
    │   ├── Models：数据类
    │   ├── Views：视图类
    │   │   ├── CCell：所有的CollectionViewCell都在这里
    │   │   ├── Cell：所有的TableViewCell都在这里
    │   │   └── XXX：ListView（项目、动态、任务、讨论、文档、代码）和InputView（用于聊天和评论的输入框）
    │   ├── Controllers：控制器，对应app中的各个页面
    │   │   ├── Login：登录页面
    │   │   ├── RootControllers：登录后的根页面
    │   │   ├── MeSetting：设置信息页面
    │   │   └── XXX：其它页面
    │   ├── Images：app中用到的所有的图片都在这里
    │   ├── Resources：资源文件
    │   ├── Util：一些常用控件和Category、Manager之类
    │   │   ├── Common
    │   │   ├── Manager
    │   │   ├── OC_Category
    │   │   └── ObjcRuntime
    │   └── Vendor：用到的一些第三方类库，一般都有改动
    │       ├── AFNetworking
    │       ├── AGEmojiKeyboard
    │       ├── ASProgressPopUpView
    │       ├── ActionSheetPicker
    │       ├── FontAwesome+iOS
    │       ├── MJPhotoBrowser
    │       ├── MLEmojiLabel
    │       ├── NSDate+Helper
    │       ├── NSStringEmojize
    │       ├── PPiAwesomeButton
    │       ├── QBImagePickerController
    │       ├── RDVTabBarController
    │       ├── SMPageControl
    │       ├── SVPullToRefresh
    │       ├── SWTableViewCell
    │       ├── UMENG
    │       ├── UMessage_Sdk_1.1.0
    │       ├── XGPush
    │       ├── XTSegmentControl
    │       └── iCarousel
    └── Pods：项目使用了[CocoaPods](http://code4app.com/article/cocoapods-install-usage)这个类库管理工具
