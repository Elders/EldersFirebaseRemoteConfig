//
//  ApplicationUpdate.swift
//  Pruvit
//
//  Created by Milen Halachev on 12.03.21.
//

import Foundation

///A type that represents an application update.
public struct ApplicationUpdate: Codable {
    
    ///The version of the update.
    public var version: Version
    
    ///The URL at which the update can be downloaded.
    public var download: URL
    
    ///Returns whenever the update can be applied to the current app.
    ///
    ///This function compares whenever the application `CFBundleVersion` is less than the one in the receiver and returns `true`. Otherwise returns `false`.
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
    
    ///A type representing a version in the following format: `X.Y.Z.a`
    ///- X is the major number (required)
    ///- Y is the minor number (required)
    ///- Z is the patch number (required)
    ///- a is the build number (optional)
    public struct Version: RawRepresentable, Comparable, Codable {
        
        public let rawValue: String
        
        public let major: Int
        public let minor: Int
        public let patch: Int
        public let build: Int?
        
        ///Creates an instance of the receiver with a String rawValue.
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
