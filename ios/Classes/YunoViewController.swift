import UIKit
import YunoSDK

class YunoViewController: UIViewController {

    var checkoutSession: String = ""
    var countryCode: String = "CO"
    var language: String? = "es"
    var action: String = ""
    var ott: String = ""
    var result: FlutterResult? = nil
    private var close: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        startSDK()
    }

    private func startSDK() {
        Yuno.startCheckout(with: self)
        if action == YunoMethodAction.start.rawValue {
            let paymentSelected = PaymentMethodYuno(
                vaultedToken: nil, paymentMethodType: "CARD"
            )
            Yuno.startPaymentLite(paymentSelected: paymentSelected)
        } else {
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

extension YunoViewController: YunoPaymentDelegate {
    func yunoCreatePayment(with token: String) {
        ott = token
        closer()
    }
    
    func yunoPaymentResult(_ result: Yuno.Result) {
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
