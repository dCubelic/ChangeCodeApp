
import Foundation
import UIKit

let SharedDateFormatter = ISO8601DateFormatter()

public class Client {
    
    
    public static var defaultEnvironment = Environment.production
    
    public static var shared: Client? = Client()
    private let session: URLSession
    private var headers: [String: String] = [:]
    
    public enum Environment: String {
        case production = "http://52.233.158.172/change/api"
    }
    
    private enum HTTPMethod: String {
        case delete = "DELETE"
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }
    
    struct Constants {
        static let register = "/hr/account/register"
        static let login = "/hr/account/login"
        static let getInfo = "/hr/team/details"
    }
    
    public let environment: Environment
    
    init(_ environment: Environment = Client.defaultEnvironment) {
        self.environment = environment
        
        session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    deinit {
        session.invalidateAndCancel()
    }
    
    private func load(path: String, method: HTTPMethod = .get, query: [String: Any]? = nil, body: Any? = nil, completion: @escaping (Any?, Int, Error?) -> Void) {
        
        loadData(path: path, method: method, query: query, body: body) { (data, code, error) in
            let code = code
            
            var json: Any? = nil
            
            if let data = data {
                json = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments])
            }
            
            completion(json, code, error)
        }
    }
    
    private func loadData(path: String, method: HTTPMethod = .get, query: [String: Any]? = nil, body: Any? = nil, completion: @escaping (Data?, Int, Error?) -> Void) {
        var components = URLComponents(string: environment.rawValue)
        components?.path.append(path)
        components?.queryItems = query?.map({ URLQueryItem(name: $0.key, value: "\($0.value)") })
        
        guard let url = components?.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        headers.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        request.addValue("", forHTTPHeaderField: "X-Authorization")
        
        let task = session.dataTask(with: request) { data, response, error in
            var jsonBody: NSString = ""
            var jsonResponse: NSString = ""
            if let body = body, let json = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted), let string = String(data: json, encoding: .utf8) {
                jsonBody = string as NSString
            }
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []), let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted), let string = String(data: jsonData, encoding: .utf8) {
                jsonResponse = string as NSString
            }
            print("----------\nRequest:\n\(method.rawValue) \(url)\n\(jsonBody)\n----------\nResponse:\n\((response as? HTTPURLResponse)?.statusCode ?? 0)\n\(jsonResponse)\n----------\n")
            
            DispatchQueue.main.async {
                completion(data, (response as? HTTPURLResponse)?.statusCode ?? 0, error)
            }
        }
        task.resume()
    }
    
    // MARK: API Calls
    public func register(teamName: String, password: String, members: [TeamMember], completion: @escaping (Any?, Int, Error?) -> Void) {
        
        var membersJSON: [[String: Any]] = []

        for member in members {
            membersJSON.append([
                "name": member.name,
                "surname": member.surname,
                "mail": member.mail
                ])
        }
        
        let body: [String: Any] = [
            "Teamname": teamName,
            "Password": password,
            "Members": membersJSON
        ]
        
        load(path: Constants.register, method: .post, body: body) { (json, code, error) in
            completion(json, code, error)
        }
    }

    public func login(teamName: String, password: String, completion: @escaping (Any?, Int, Error?) -> Void) {
        let body: [String: Any] = [
            "Teamname": teamName,
            "Password": password
        ]
        
        load(path: Constants.login, method: .post, body: body) { (json, code, error) in
            completion(json, code, error)
        }
    }
    
    public func getInfo(teamId: Int, completion: @escaping (Any?, Int, Error?) -> Void) {
        load(path: Constants.getInfo, method: .get, query: ["id": teamId], body: nil) { (json, code, error) in
            completion(json, code, error)
        }
    }
}
