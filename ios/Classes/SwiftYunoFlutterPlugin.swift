import Flutter
import YunoSDK

 public enum YunoMethodAction: String {
    case ´init´ = "init"
    case start = "start"
    case continuePayment = "continuePayment"
}

public class SwiftYunoFlutterPlugin: NSObject, FlutterPlugin {

    var flutterSDKProperty = "yuno_sdk"
    var rootViewController: UIViewController!
    let path = Bundle.main.path(forResource: "es", ofType: "lproj") ?? ""

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "yuno", binaryMessenger: registrar.messenger())
        let instance = SwiftYunoFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case YunoMethodAction.´init´.rawValue:

            if rootViewController == nil {
                rootViewController = UIApplication.shared.windows.first?.rootViewController
            }

            let bundle = Bundle(path: path)
            if let args = call.arguments as? Dictionary<String, Any>,
               let key = args["key"] as? String,
               let checkoutSession = args["checkoutSession"] as? String,
               let country = args["country"] as? String,
               let action = args["action"] as? String {

                Yuno.initialize(apiKey: key,
                    config: YunoConfig(
                        cardFormType: CardFormType.oneStep,
                        appearance: getApparenceUI(),
                        saveCardEnabled: false,
                        localizableBundle: bundle
                    )
                )

                let viewToPush = YunoViewController()
                viewToPush.checkoutSession = checkoutSession
                viewToPush.countryCode = country
                viewToPush.action = action
                viewToPush.result = result
                UIApplication.shared.windows.first?.rootViewController = nil

                UIView.animate(withDuration: 0.9, animations: {
                    let navigationController = UINavigationController(rootViewController: (self.rootViewController))
                    UIApplication.shared.windows.first?.rootViewController = navigationController
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                    navigationController.isNavigationBarHidden = true
                    navigationController.pushViewController(viewToPush, animated: true)
                })
            } else {
                result("ERROR")
            }
        default:
            result("DEFAULT")
        }
    }

    // MARK: - Private Methods
    private func getApparenceUI() -> Yuno.Appearance {
        return Yuno.Appearance(
            accentColor: .accentA,
            buttonBackgroundColor: UIColor(red: 0.29, green: 0.56, blue: 0.89, alpha: 1.00),
            buttonTitleColor: .white,
            buttonBorderColor: UIColor(red: 0.29, green: 0.56, blue: 0.89, alpha: 1.00),
            secondaryButtonBackgroundColor: .yellow,
            secondaryButtonTitleColor: .black,
            secondaryButtonBorderColor: .black,
            disableButtonBackgroundColor: (UIColor(red: 0.29, green: 0.56, blue: 0.89, alpha: 1.00).withAlphaComponent(0.7)),
            disableButtonTitleColor: .white
        )
    }
}
