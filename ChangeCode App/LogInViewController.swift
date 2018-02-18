import UIKit

class LogInViewController: UIViewController {
    
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamNameTextField.delegate = self
        passwordTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapAction() {
        view.endEditing(true)
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    @IBAction func loginAction(_ sender: Any) {
        guard let teamName = teamNameTextField.text, let password = passwordTextField.text else { return }
        Client.shared?.login(teamName: teamName, password: password, completion: { (json, code, error) in
            if code == 200 {
                if let json = json as? [String: Any?] {
                    if let results = json["Result"] as? String {
                        let dict = self.convertToDictionary(text: results)!
                        if let id = dict["TeamId"] as? Int {
                            self.getTeamInfo(id: id)
                        }
                    }
                }
            } else {
                if let json = json as? [String: Any?], let errors = json["Errors"] as? [String] {
                    var message = ""
                    for error in errors {
                        message.append(contentsOf: error + "\n")
                    }
                    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
    private func getTeamInfo(id: Int) {
        Client.shared?.getInfo(teamId: id, completion: { (json, code, error) in
            if let json = json as? [String: Any?] {
                if let results = json["Result"] as? String {
                    let teamDict = self.convertToDictionary(text: results)!
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeamDetailViewController") as! TeamDetailViewController
                    vc.team = Team(json: teamDict)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        })
    }
}

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == teamNameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        
        return true
    }
}
