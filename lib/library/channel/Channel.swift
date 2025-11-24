import Flutter

// iOS MethodChannel 封装
class IOSMethodChannel {
    private let channel: FlutterMethodChannel

    init(name: String, binaryMessenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: name, binaryMessenger: binaryMessenger)
    }

    func setMethodCallHandler(_ handler: @escaping (FlutterMethodCall, @escaping FlutterResult) -> Void) {
        channel.setMethodCallHandler(handler)
    }

    func invokeMethod<T>(_ method: String, arguments: Any? = nil, completion: ((T?) -> Void)? = nil) {
        channel.invokeMethod(method, arguments: arguments) { result in
            completion?(result as? T)
        }
    }
}

// iOS EventChannel 封装
class IOSEventChannel {
    private let channel: FlutterEventChannel

    init(name: String, binaryMessenger: FlutterBinaryMessenger) {
        channel = FlutterEventChannel(name: name, binaryMessenger: binaryMessenger)
    }

    func setStreamHandler(_ handler: FlutterStreamHandler) {
        channel.setStreamHandler(handler)
    }
}

// iOS 字符串消息通道
class IOSStringMessageChannel {
    private let channel: FlutterBasicMessageChannel

    init(name: String, binaryMessenger: FlutterBinaryMessenger) {
        channel = FlutterBasicMessageChannel(
            name: name,
            binaryMessenger: binaryMessenger,
            codec: FlutterStringCodec.sharedInstance()
        )
    }

    func setMessageHandler(_ handler: @escaping (String?, @escaping (String?) -> Void) -> Void) {
        channel.setMessageHandler { message, reply in
            handler(message as? String, { result in
                reply(result)
            })
        }
    }

    func send(_ message: String, completion: ((String?) -> Void)? = nil) {
        channel.send(message) { result in
            completion?(result as? String)
        }
    }
}

// iOS 动态消息通道
class IOSDynamicMessageChannel {
    private let channel: FlutterBasicMessageChannel

    init(name: String, binaryMessenger: FlutterBinaryMessenger) {
        channel = FlutterBasicMessageChannel(
            name: name,
            binaryMessenger: binaryMessenger,
            codec: FlutterStandardMessageCodec.sharedInstance()
        )
    }

    func setMessageHandler(_ handler: @escaping (Any?, @escaping (Any?) -> Void) -> Void) {
        channel.setMessageHandler(handler)
    }

    func send(_ message: Any, completion: ((Any?) -> Void)? = nil) {
        channel.send(message) { result in
            completion?(result)
        }
    }
}

/// iOS 使用示例
class AppDelegate: FlutterAppDelegate {
    private var channels: [String: Any] = [:]

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let controller = window?.rootViewController as! FlutterViewController
        setupChannels(binaryMessenger: controller.binaryMessenger)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func setupChannels(binaryMessenger: FlutterBinaryMessenger) {
        // MethodChannel
        let platformChannel = IOSMethodChannel(
            name: "com.example/platform",
            binaryMessenger: binaryMessenger
        )
        platformChannel.setMethodCallHandler { call, result in
            switch call.method {
            case "getPlatformVersion":
                result("iOS \(UIDevice.current.systemVersion)")
            case "getDeviceInfo":
                let info: [String: Any] = [
                    "model": UIDevice.current.model,
                    "system": UIDevice.current.systemVersion,
                    "name": UIDevice.current.name
                ]
                result(info)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        channels["platform"] = platformChannel

        // StringMessageChannel
        let stringChannel = IOSStringMessageChannel(
            name: "com.example/string",
            binaryMessenger: binaryMessenger
        )
        stringChannel.setMessageHandler { message, reply in
            let response = "iOS received string: \(message ?? "nil")"
            reply(response)
        }
        channels["string"] = stringChannel

        // DynamicMessageChannel
        let dynamicChannel = IOSDynamicMessageChannel(
            name: "com.example/dynamic",
            binaryMessenger: binaryMessenger
        )
        dynamicChannel.setMessageHandler { message, reply in
            let response = "iOS received: \(message ?? "nil")"
            reply(response)
        }
        channels["dynamic"] = dynamicChannel
    }
}