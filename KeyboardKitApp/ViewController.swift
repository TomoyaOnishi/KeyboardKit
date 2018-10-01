import UIKit
import KeyboardKit

class ViewController: UIViewController {
    
    @IBOutlet weak var orangeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layoutGuide = KeyboardLayoutGuide(defaultPosition: .safeAreaBottom(constant: 0))
        view.addLayoutGuide(layoutGuide)
        orangeView.topAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: 0).isActive = true
        orangeView.leadingAnchor.constraint(equalTo: keyboardLayoutGuide.leadingAnchor, constant: 0).isActive = true
        orangeView.trailingAnchor.constraint(equalTo: keyboardLayoutGuide.trailingAnchor, constant: 0).isActive = true
        orangeView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
    
    @IBAction func didTapHideButton(_ sender: UIButton) {
        view.endEditing(true)
    }
}

extension ViewController: KeyboardLayoutSupporting {}



