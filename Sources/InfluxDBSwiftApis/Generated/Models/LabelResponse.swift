//
// LabelResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation


public struct LabelResponse: Codable {

    public var label: Label?
    public var links: Links?

    public init(label: Label? = nil, links: Links? = nil) {
        self.label = label
        self.links = links
    }

}

