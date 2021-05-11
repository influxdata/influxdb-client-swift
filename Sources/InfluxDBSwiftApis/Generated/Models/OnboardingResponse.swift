//
// OnboardingResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct OnboardingResponse: Codable {

    public var user: UserResponse?
    public var org: Organization?
    public var bucket: Bucket?
    public var auth: Authorization?

    public init(user: UserResponse? = nil, org: Organization? = nil, bucket: Bucket? = nil, auth: Authorization? = nil) {
        self.user = user
        self.org = org
        self.bucket = bucket
        self.auth = auth
    }

}
