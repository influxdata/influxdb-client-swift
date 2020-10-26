//
// RunLog.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation


public struct RunLog: Codable {

    public var runID: String?
    public var time: String?
    public var message: String?

    public init(runID: String? = nil, time: String? = nil, message: String? = nil) {
        self.runID = runID
        self.time = time
        self.message = message
    }

}

