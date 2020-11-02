//
// Bucket.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation


public struct Bucket: Codable {

    public enum ModelType: String, Codable, CaseIterable {
        case user = "user"
        case system = "system"
    }
    public var links: BucketLinks?
    public var id: String?
    public var type: ModelType? = .user
    public var name: String
    public var description: String?
    public var orgID: String?
    public var rp: String?
    public var createdAt: Date?
    public var updatedAt: Date?
    /** Rules to expire or retain data.  No rules means data never expires. */
    public var retentionRules: [RetentionRule]
    public var labels: [Label]?

    public init(links: BucketLinks? = nil, id: String? = nil, type: ModelType? = nil, name: String, description: String? = nil, orgID: String? = nil, rp: String? = nil, createdAt: Date? = nil, updatedAt: Date? = nil, retentionRules: [RetentionRule], labels: [Label]? = nil) {
        self.links = links
        self.id = id
        self.type = type
        self.name = name
        self.description = description
        self.orgID = orgID
        self.rp = rp
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.retentionRules = retentionRules
        self.labels = labels
    }

}
