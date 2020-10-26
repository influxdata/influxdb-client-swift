//
// LogEvent.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation


public struct LogEvent: Codable {

    /** Time event occurred, RFC3339Nano. */
    public var time: Date?
    /** A description of the event that occurred. */
    public var message: String?

    public init(time: Date? = nil, message: String? = nil) {
        self.time = time
        self.message = message
    }

}

