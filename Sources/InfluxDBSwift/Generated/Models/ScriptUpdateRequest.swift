//
// ScriptUpdateRequest.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct ScriptUpdateRequest: Codable {

    public var name: String?
    public var description: String?
    /** script is script to be executed */
    public var script: String?

    public init(name: String? = nil, description: String? = nil, script: String? = nil) {
        self.name = name
        self.description = description
        self.script = script
    }

}
