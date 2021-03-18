#!/usr/bin/swift

import Foundation

extension String: Error {}

try! execute()
func execute() throws {
    
    guard CommandLine.arguments.count == 5 else {
        
        let scriptName = URL(string: CommandLine.arguments[0])!.lastPathComponent
        print("Usage: \(scriptName) <version> <download_url> <ios|android> <service_account_key_json_file>")
        return
    }
    
    let scriptDir = URL(string: CommandLine.arguments[0])!.deletingLastPathComponent()
    let version = CommandLine.arguments[1]
    let download_url = CommandLine.arguments[2]
    let platform = CommandLine.arguments[3]
    let serviceAccountJSONFile = CommandLine.arguments[4]
    
    print("version: \(version)")
    print("download_url: \(download_url)")
    print("platform: \(version)")
    
    guard ["ios", "android"].contains(platform) else {
        
        print("Unsupported platform: \(platform)")
        return
    }
    
    let projectID = shell(launchPath: scriptDir.appendingPathComponent("get_service_account_project_id.swift").path, arguments: [serviceAccountJSONFile])
    print("project_id: \(projectID)")
    
    let scope = "https://www.googleapis.com/auth/firebase.remoteconfig https://www.googleapis.com/auth/cloud-platform"
    let jws = shell(launchPath: scriptDir.appendingPathComponent("generate_service_account_jws.swift").path, arguments: [serviceAccountJSONFile, scope])
    let tokenURL = URL(string: shell(launchPath: scriptDir.appendingPathComponent("get_service_account_token_url.swift").path, arguments: [serviceAccountJSONFile]))!
    let accessToken = try getAccessToken(jws: jws, url: tokenURL)
    
    var (remoteConfig, etag) = try getRemoteConfig(accessToken: accessToken, projectID: projectID)
    try updateRemoteConfig(&remoteConfig, with: ApplicationUpdate(version: version, download: download_url), platform: platform)
    try overrideRemoteConfig(accessToken: accessToken, projectID: projectID, remoteConfig: remoteConfig, etag: etag)
    
    print("Remote config successfully updated.")
}

func getAccessToken(jws: String, url: URL) throws -> String {
    
    var request = URLRequest(url: url)
    request.httpBody = try JSONEncoder().encode(AccessTokenRequest(assertion: jws))
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let (data, _, error) = perform(request)
    
    if let error = error {
        
        throw error
    }
    
    if data == nil {
        
        throw "Get Access Token: Response data is nil"
    }
    
    let result = try JSONDecoder().decode(AccessTokenResponse.self, from: data!).access_token
    return result
}

func getRemoteConfig(accessToken: String, projectID: String) throws -> (remoteConfig: [String: Any], etag: String?) {
    
    let url = URL(string: "https://firebaseremoteconfig.googleapis.com/v1/projects/\(projectID)/remoteConfig")!
    let request = URLRequest(url: url).signed(with: accessToken)
    let (data, response, error) = perform(request)
    let etag = (response as? HTTPURLResponse)?.allHeaderFields["Etag"] as? String
    
    if let error = error {
        
        throw error
    }
    
    if data == nil {
        
        throw "Get Remote Config: Response data is nil"
    }
    
    guard let remoteConfig = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] else {
        
        throw "Get Remote Config: Invalid result"
    }
    
    return (remoteConfig, etag)
}

func updateRemoteConfig(_ remoteConfig: inout [String: Any], with update: ApplicationUpdate, platform: String) throws {
    
    let key = platform + "_recommended_update"
    guard var parameters = remoteConfig["parameters"] as? [String: Any] else {
        
        throw "Update remote config: Unable to get remote config parameters"
    }
    
    let updateData = try JSONEncoder().encode(update)
    guard let updateString = String(data: updateData, encoding: .utf8) else {
        
        throw "Update remote config: Unable to create update data"
    }
    
    parameters[key] = ["defaultValue": ["value": updateString]]
    remoteConfig["parameters"] = parameters
}

func overrideRemoteConfig(accessToken: String, projectID: String, remoteConfig: [String: Any], etag: String?) throws {
    
    let json = try JSONSerialization.data(withJSONObject: remoteConfig, options: [.prettyPrinted])
    let url = URL(string: "https://firebaseremoteconfig.googleapis.com/v1/projects/\(projectID)/remoteConfig")!
    var request = URLRequest(url: url).signed(with: accessToken)
    request.httpMethod = "PUT"
    request.httpBody = json
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue(etag ?? "*", forHTTPHeaderField: "If-Match")
    let (_, _, error) = perform(request)
    
    if let error = error {
        
        throw error
    }
}

struct AccessTokenRequest: Codable {
    
    var grant_type: String = "urn:ietf:params:oauth:grant-type:jwt-bearer"
    var assertion: String
}

struct AccessTokenResponse: Codable {
    
    var access_token: String
}

struct ApplicationUpdate: Codable {
    
    var version: String
    var download: String
}

func shell(launchPath: String, arguments: [String]) -> String {

    let process = Process()
    process.launchPath = launchPath
    process.arguments = arguments

    let pipe = Pipe()
    process.standardOutput = pipe
    process.launch()

    let output_from_command = String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: String.Encoding.utf8)!

    // remove the trailing new-line char
    if output_from_command.count > 0 {
        let lastIndex = output_from_command.index(before: output_from_command.endIndex)
        return String(output_from_command[output_from_command.startIndex ..< lastIndex])
    }
    return output_from_command
}

func perform(_ request: URLRequest) -> (Data?, URLResponse?, Error?) {
    
    let semaphore = DispatchSemaphore(value: 0)
    var result: (Data?, URLResponse?, Error?)! = nil
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        
        result = (data, response, error)
        semaphore.signal()
    }
    .resume()
    
    semaphore.wait()
    return result
}

extension URLRequest {
    
    func signed(with token: String) -> URLRequest {
        
        var request = self
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
