import UIKit

class TeamDetailViewController: UIViewController {

    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamIDLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var team: Team?
    var members: [TeamMember] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let team = team else { return }
        
        teamNameLabel.text = team.name
        teamIDLabel.text = String(team.id)
        members = team.members
        
        tableView.register(UINib(nibName: "TeamMemberTableViewCell", bundle: nil), forCellReuseIdentifier: "TeamMemberTableViewCell")
    }
}

extension TeamDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamMemberTableViewCell", for: indexPath) as! TeamMemberTableViewCell
        
        cell.setup(with: members[indexPath.row])

        return cell
    }
}
