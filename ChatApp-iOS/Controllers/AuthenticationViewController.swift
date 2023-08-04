import UIKit
import FirebaseAuth
class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAppearance()
        
    }
    
    func setUpAppearance() {
        loginButton.defaultButtonStyle(title: "Login")
        signUpButton.defaultButtonStyle(title: "Sign Up")
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
    }
    
}

