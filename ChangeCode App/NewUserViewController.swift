import UIKit

protocol NewUserViewControllerDelegate: class {
    func addedNewMember(member: TeamMember)
}

class NewUserViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    
    weak var delegate: NewUserViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name",
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.6)])
        surnameTextField.attributedPlaceholder = NSAttributedString(string: "Surname",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.6)])
        mailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.6)])
        
        nameTextField.delegate = self
        surnameTextField.delegate = self
        mailTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapAction() {
        view.endEditing(true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func okAction(_ sender: Any) {
        guard let name = nameTextField.text, let surname = surnameTextField.text, let mail = mailTextField.text else { return }
        
        delegate?.addedNewMember(member: TeamMember(name: name, surname: surname, mail: mail))
        
        dismiss(animated: true, completion: nil)
    }
}

extension NewUserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            surnameTextField.becomeFirstResponder()
        } else if textField == surnameTextField {
            mailTextField.becomeFirstResponder()
        } else if textField == mailTextField {
            mailTextField.resignFirstResponder()
        }
        
        return true
    }
}
