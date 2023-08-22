import UIKit
import FirebaseAuth
import TransitionButton

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    private var gradientLayer: CAGradientLayer?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAppearance()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    func setUpAppearance() {
        
        let userImageView = UIImageView(image: UIImage(named: "username"))
        userImageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24) // Adjust size as needed
        userImageView.contentMode = .scaleAspectFit
        
        let lockImageView = UIImageView(image: UIImage(named: "lock"))
        lockImageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24) // Adjust size as needed
        lockImageView.contentMode = .scaleAspectFit
        
        emailTextField.leftView = userImageView
        emailTextField.leftViewMode = .always
        
        passwordTextField.leftView = lockImageView
        passwordTextField.leftViewMode = .always
        
        usernameLabel.text = "Username"
        usernameLabel.font =  UIFont(name: "Poppins-Bold", size: 14)
        
        passwordLabel.text = "Password"
        passwordLabel.font = UIFont(name: "Poppins-Bold", size: 14)
        
        emailTextField.tintColor = UIColor.lightGray
        emailTextField.font = UIFont(name: "Poppins-Medium", size: 14)
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.contentVerticalAlignment = .bottom
        emailTextField.returnKeyType = .next
        emailTextField.enablesReturnKeyAutomatically = true
        
        passwordTextField.tintColor = UIColor.lightGray
        passwordTextField.font = UIFont(name: "Poppins-Medium", size: 14)
        passwordTextField.keyboardType = .emailAddress
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
        passwordTextField.contentVerticalAlignment = .bottom
        passwordTextField.returnKeyType = .next
        passwordTextField.enablesReturnKeyAutomatically = true
        
        errorLabel.numberOfLines = 0
        errorLabel.textColor = UIColor.red
        errorLabel.font = UIFont(name: "Poppins-Regular", size: 12)
        
        loginButton.defaultButtonStyle(title: "Login")
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailTextField.textAlignment = .left
            emailTextField.attributedPlaceholder = nil
        } else if textField == passwordTextField {
            passwordTextField.textAlignment = .left
            passwordTextField.attributedPlaceholder = nil
        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        //Create cleaned versions of the data
        let formattedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let formattedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        logUserIn(withEmail: formattedEmail, password: formattedPassword)
    }
    
    func validateFields() -> String? {
        // Check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "auth_fields_error".localized
        }
        // Validate Fields
        if let errorMessage = Utilities.validateFields(email: emailTextField.text, password: passwordTextField.text, authFlag: "Login") {
            return errorMessage
        }
        return nil
    }
    
    func logUserIn(withEmail email: String, password: String) {
        // Validate the fields
        let error = validateFields()
        
        if let error = error {
            // There's something wrong with the fields, show error message
            Utilities.showError(message: error, label: errorLabel)
        } else {
            // Log in the user
            Auth.auth().signIn(withEmail: email, password: password) { [self] (result, error) in
                // Check for errors
                if let error = error {
                    // There was an error creating the user
                    Utilities.showError(message: "Error signing in user: \(error.localizedDescription)", label: errorLabel)
                } else {
                    // Transition to the home screen with a slide animation
                    errorLabel.isHidden = true
                        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                            guard let windowScene = sceneDelegate.window?.windowScene else { return }
                            let transition = CATransition()
                            transition.duration = 0.5
                            transition.type = CATransitionType.push
                            transition.subtype = CATransitionSubtype.fromRight
                            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                            windowScene.windows.first?.layer.add(transition, forKey: kCATransition)
                            sceneDelegate.showHomeScreen()
                        }
                    
                }
            }
        }
    }
    
}
