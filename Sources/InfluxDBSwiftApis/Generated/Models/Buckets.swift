//
// Buckets.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation


public struct Buckets: Codable {

    public var links: Links?
    public var buckets: [Bucket]?

    public init(links: Links? = nil, buckets: [Bucket]? = nil) {
        self.links = links
        self.buckets = buckets
    }

}
