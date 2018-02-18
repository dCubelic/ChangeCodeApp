import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var members: [TeamMember] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        view.addGestureRecognizer(tapGesture)
        
        teamNameTextField.delegate = self
        passwordTextField.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UINib(nibName: "TeamMemberTableViewCell", bundle: nil), forCellReuseIdentifier: "TeamMemberTableViewCell")
    }
    
    @objc func tapAction() {
        view.endEditing(true)
    }
    
    @IBAction func addUserAction(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewUserViewController") as! NewUserViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
    
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        guard let teamName = teamNameTextField.text, let password = passwordTextField.text else { return }
        
        Client.shared?.register(teamName: teamName, password: password, members: members, completion: { (json, code, error) in
            if code == 200 {
//            if true {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInViewController")
                self.navigationController?.pushViewController(vc, animated: true)
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
    
}

extension RegisterViewController: NewUserViewControllerDelegate {
    func addedNewMember(member: TeamMember) {
        members.append(member)
        tableView.reloadData()
    }
}

extension RegisterViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamMemberTableViewCell", for: indexPath) as! TeamMemberTableViewCell
        
        cell.setup(with: members[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.members.remove(at: indexPath.row)
            completionHandler(true)
        }
        action.backgroundColor = UIColor(red: 99/255, green: 13/255, blue: 137/255, alpha: 1)
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        
        return configuration
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == teamNameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        
        return true
    }
}
