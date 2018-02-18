import UIKit

class TeamMemberTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
        selectionStyle = .none
    }
    
    func setup(with member: TeamMember) {
        nameLabel.text = member.name + " " + member.surname
        emailLabel.text = member.mail
    }
    
}
