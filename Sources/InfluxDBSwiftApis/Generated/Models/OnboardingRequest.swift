//
// OnboardingRequest.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct OnboardingRequest: Codable {

    public var username: String
    public var password: String?
    public var org: String
    public var bucket: String
    public var retentionPeriodSeconds: Int64?
    /** Retention period *in nanoseconds* for the new bucket. This key&#39;s name has been misleading since OSS 2.0 GA, please transition to use &#x60;retentionPeriodSeconds&#x60;  */
    @available(*, deprecated, message: "This property is deprecated.")
    public var retentionPeriodHrs: Int?
    /** Authentication token to set on the initial user. If not specified, the server will generate a token.  */
    public var token: String?

    public init(username: String, password: String? = nil, org: String, bucket: String, retentionPeriodSeconds: Int64? = nil, retentionPeriodHrs: Int? = nil, token: String? = nil) {
        self.username = username
        self.password = password
        self.org = org
        self.bucket = bucket
        self.retentionPeriodSeconds = retentionPeriodSeconds
        self.retentionPeriodHrs = retentionPeriodHrs
        self.token = token
    }

}
