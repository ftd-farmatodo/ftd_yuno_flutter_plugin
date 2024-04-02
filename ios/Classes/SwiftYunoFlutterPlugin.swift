import Flutter
import UIKit
import YunoSDK

public class SwiftYunoFlutterPlugin: NSObject, FlutterPlugin {
    var flutterSDKProperty = "yuno_sdk"
    var rootViewController:UIViewController!
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "yuno", binaryMessenger: registrar.messenger())
        let instance = SwiftYunoFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init":
            if rootViewController == nil {
                rootViewController = UIApplication.shared.keyWindow?.rootViewController
            }
            let path = Bundle.main.path(forResource: "es", ofType: "lproj") ?? ""
            let bundle = Bundle(path: path)
            if let args = call.arguments as? Dictionary<String, Any>,
               let key = args["key"] as? String,
               let checkoutSession = args["checkoutSession"] as? String,
               let country = args["country"] as? String,
               let action = args["action"] as? String{
                let appearance = Yuno.Appearance(accentColor: .accentA,
                                    buttonBackgroundColor: UIColor(red: 0.29, green: 0.56, blue: 0.89, alpha: 1.00),
                                    buttonTitleColor: .white,
                                    buttonBorderColor: UIColor(red: 0.29, green: 0.56, blue: 0.89, alpha: 1.00),
                                    secondaryButtonBackgroundColor: .yellow,
                                    secondaryButtonTitleColor: .black,
                                    secondaryButtonBorderColor: .black,
                                    disableButtonBackgroundColor: (UIColor(red: 0.29, green: 0.56, blue: 0.89, alpha: 1.00).withAlphaComponent(0.7)),
                                    disableButtonTitleColor: .white)
                Yuno.initialize(apiKey: key,
                        config: YunoConfig(
                            cardFormType: CardFormType.oneStep,
                            appearance: appearance,
                            saveCardEnabled: false,
                            localizableBundle: bundle
                        ))
                UIView.animate(withDuration: 0.9, animations: {
                    let viewToPush = YunoViewController()
                    viewToPush.checkoutSession = checkoutSession
                    viewToPush.countryCode = country
                    viewToPush.action = action
                    viewToPush.result = result
                    UIApplication.shared.keyWindow?.rootViewController = nil
                    let navigationController = UINavigationController(rootViewController: (self.rootViewController)!)
                    UIApplication.shared.keyWindow?.makeKeyAndVisible()
                    UIApplication.shared.keyWindow?.rootViewController = navigationController
                    navigationController.isNavigationBarHidden = true
                    navigationController.pushViewController(viewToPush, animated: false)
                })
            }else{
                result("ERROR")
            }
        default:
            result("DEFAULT")
        }
    }
}

class YunoViewController: UIViewController {
    var checkoutSession = ""
    var countryCode = "CO"
    var language: String? = "es"
    var action = ""
    var ott = ""
    var result: FlutterResult? = nil
    private var close: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Yuno.startCheckout(with: self)
        if(action=="start"){
            let paymentSelected = PaymentMethodYuno(
                vaultedToken: nil, paymentMethodType: "CARD"
            )
            Yuno.startPaymentLite(paymentSelected: paymentSelected)
        }else{
            Yuno.continuePayment(showPaymentStatus: true)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        close = !close
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if self.close && self.ott == "" {
                self.closer()
            }
        }
    }
}

extension YunoViewController: YunoPaymentDelegate{
    func yunoCreatePayment(with token: String) {
        ott = token
        closer()
    }
    
    func yunoPaymentResult(_ result: YunoSDK.Yuno.Result) {
        closer()
    }
    private func closer() {
        result?(ott)
        _ = navigationController?.popToRootViewController(animated: false)
    }
}

class PaymentMethodYuno: PaymentMethodSelected {
    
    var vaultedToken: String?
    var paymentMethodType: String
    
    init(vaultedToken: String?, paymentMethodType: String) {
        self.vaultedToken = vaultedToken
        self.paymentMethodType = paymentMethodType
    }
}
extension UIColor {
    static var accentA: UIColor {
        #colorLiteral(red: 0, green: 0.4780646563, blue: 0.9985368848, alpha: 1)
    }
}
