//
//  ApplicationUpdate.swift
//  Pruvit
//
//  Created by Milen Halachev on 12.03.21.
//

import Foundation

public struct ApplicationUpdate: Codable {
    
    public var version: Version
    public var download: URL
    
    public var isApplicable: Bool {
        
        return Version.application.map { $0 < self.version } ?? false
    }
}

extension ApplicationUpdate: Identifiable {
    
    public var id: String {
        
        return self.version.rawValue
    }
}

extension ApplicationUpdate {
    
    public struct Version: RawRepresentable, Comparable, Codable {
        
        public let rawValue: String
        
        public let major: Int
        public let minor: Int
        public let patch: Int
        public let build: Int?
        
        public init?(rawValue: String) {
            
            let components = rawValue.split(separator: ".").compactMap({ Int($0) })
            guard components.count >= 3, components.count <= 4 else {
                
                return nil
            }
            
            self.rawValue = rawValue
            
            self.major = components[0]
            self.minor = components[1]
            self.patch = components[2]
            
            if components.count == 4 {
                
                self.build = components[3]
            }
            else {
                
                self.build = nil
            }
        }
        
        public static func < (lhs: Version, rhs: Version) -> Bool {
            
            return lhs.major < rhs.major
                || lhs.minor < rhs.minor
                || lhs.patch < rhs.patch
                || lhs.build ?? 0 < rhs.build ?? 0
        }
    }
}


extension ApplicationUpdate.Version {
    
    static var application: Self? {
        
        guard let rawValue = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            
            return nil
        }
        
        return Self(rawValue: rawValue)
    }
}
