#!/usr/bin/swift

import Foundation

extension String: Error {}

try! execute()
func execute() throws {
    
    guard CommandLine.arguments.count == 2 else {
        
        let scriptName = URL(string: CommandLine.arguments[0])!.lastPathComponent
        print("Usage: \(scriptName) <service_account_key_json_file>")
        return
    }
    
    //parse the service account json
    let serviceAccountFile = URL(fileURLWithPath: CommandLine.arguments[1])
    let serviceAccountData = try Data(contentsOf: serviceAccountFile)
    let serviceAccount = try JSONDecoder().decode(ServiceAccount.self, from: serviceAccountData)
    print(serviceAccount.token_uri)
}

struct ServiceAccount: Codable {
    
    var token_uri: String
}

