//
// AddResourceMemberRequestBody.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct AddResourceMemberRequestBody: Codable {

    public var id: String
    public var name: String?

    public init(id: String, name: String? = nil) {
        self.id = id
        self.name = name
    }

}