import UIKit
import WebKit

class WebViewViewController: UIViewController {
    
    @IBOutlet private var webView: WKWebView!
    
    @IBOutlet var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
