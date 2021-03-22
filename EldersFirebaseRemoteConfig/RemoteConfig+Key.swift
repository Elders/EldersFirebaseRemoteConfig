//
//  RemoteConfig+Key.swift
//  Pruvit
//
//  Created by Milen Halachev on 12.03.21.
//

import Foundation
import FirebaseRemoteConfig

extension RemoteConfig {

    ///A config key
    public struct Key: RawRepresentable, Hashable {

        public var rawValue: String
        
        public init(rawValue: String) {
            
            self.rawValue = rawValue
        }
    }

    ///Gets a config value for a given key.
    ///- parameter key: The config key for which to get the value.
    public func configValue(for key: Key) -> RemoteConfigValue {

        return self.configValue(forKey: key.rawValue)
    }

    ///Sets config defaults for parameter keys and values in the default namespace config.
    ///- parameter defaults: A dictionary containing mapping of default values for keys.
    public func setDefaults(_ defaults: [Key: NSObject]?) {

        self.setDefaults(defaults?.map())
    }
}

extension RemoteConfig.Key: ExpressibleByStringLiteral {

    ///Creates an isntance of the recevied with a String literal
    public init(stringLiteral value: StringLiteralType) {
        
        self.init(rawValue: value)
    }
}

extension Dictionary where Key == RemoteConfig.Key, Value == NSObject {
    
    func map() -> [String: NSObject] {
    
        return self.reduce(into: [:], { $0[$1.key.rawValue] = $1.value })
    }
}

extension Dictionary where Key == String, Value == NSObject {
    
    func map() -> [RemoteConfig.Key: NSObject] {
    
        return self.reduce(into: [:], { $0[.init(rawValue: $1.key)] = $1.value })
    }
}
