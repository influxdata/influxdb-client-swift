//
// Script.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct Script: Codable {

    public var id: String?
    public var name: String
    public var description: String?
    public var orgID: String
    /** script to be executed */
    public var script: String
    public var language: ScriptLanguage?
    /** invocation endpoint address */
    public var url: String?
    public var createdAt: Date?
    public var updatedAt: Date?

    public init(id: String? = nil, name: String, description: String? = nil, orgID: String, script: String, language: ScriptLanguage? = nil, url: String? = nil, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.orgID = orgID
        self.script = script
        self.language = language
        self.url = url
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

}