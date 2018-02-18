import Foundation

public class TeamMember {
    var name: String
    var surname: String
    var mail: String
    
    init(name: String, surname: String, mail: String) {
        self.name = name
        self.surname = surname
        self.mail = mail
    }
    
    init(json: [String: Any?]) {
        self.name = json["Name"] as! String
        self.surname = json["Surname"] as! String
        self.mail = json["Mail"] as! String
    }
}
