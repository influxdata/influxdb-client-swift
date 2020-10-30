//
// OrganizationsAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

extension InfluxDB2API {


public class OrganizationsAPI {
    private let influxDB2API: InfluxDB2API

    public init(influxDB2API: InfluxDB2API) {
        self.influxDB2API = influxDB2API
    }

    /**
     Delete an organization
     
     - parameter orgID: (path) The ID of the organization to delete. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func deleteOrgsID(orgID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        deleteOrgsIDWithRequestBuilder(orgID: orgID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Delete an organization
     - DELETE /orgs/{orgID}
     - parameter orgID: (path) The ID of the organization to delete. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<Void> 
     */
    internal func deleteOrgsIDWithRequestBuilder(orgID: String, zapTraceSpan: String? = nil) -> RequestBuilder<Void> {
        var path = "/orgs/{orgID}"
        let orgIDPreEscape = "\(APIHelper.mapValueToPathItem(orgID))"
        let orgIDPostEscape = orgIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{orgID}", with: orgIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = influxDB2API.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)
    }

    /**
     Remove a member from an organization
     
     - parameter userID: (path) The ID of the member to remove. 
     - parameter orgID: (path) The organization ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func deleteOrgsIDMembersID(userID: String, orgID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        deleteOrgsIDMembersIDWithRequestBuilder(userID: userID, orgID: orgID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Remove a member from an organization
     - DELETE /orgs/{orgID}/members/{userID}
     - parameter userID: (path) The ID of the member to remove. 
     - parameter orgID: (path) The organization ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<Void> 
     */
    internal func deleteOrgsIDMembersIDWithRequestBuilder(userID: String, orgID: String, zapTraceSpan: String? = nil) -> RequestBuilder<Void> {
        var path = "/orgs/{orgID}/members/{userID}"
        let userIDPreEscape = "\(APIHelper.mapValueToPathItem(userID))"
        let userIDPostEscape = userIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{userID}", with: userIDPostEscape, options: .literal, range: nil)
        let orgIDPreEscape = "\(APIHelper.mapValueToPathItem(orgID))"
        let orgIDPostEscape = orgIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{orgID}", with: orgIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = influxDB2API.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)
    }

    /**
     Remove an owner from an organization
     
     - parameter userID: (path) The ID of the owner to remove. 
     - parameter orgID: (path) The organization ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func deleteOrgsIDOwnersID(userID: String, orgID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        deleteOrgsIDOwnersIDWithRequestBuilder(userID: userID, orgID: orgID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Remove an owner from an organization
     - DELETE /orgs/{orgID}/owners/{userID}
     - parameter userID: (path) The ID of the owner to remove. 
     - parameter orgID: (path) The organization ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<Void> 
     */
    internal func deleteOrgsIDOwnersIDWithRequestBuilder(userID: String, orgID: String, zapTraceSpan: String? = nil) -> RequestBuilder<Void> {
        var path = "/orgs/{orgID}/owners/{userID}"
        let userIDPreEscape = "\(APIHelper.mapValueToPathItem(userID))"
        let userIDPostEscape = userIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{userID}", with: userIDPostEscape, options: .literal, range: nil)
        let orgIDPreEscape = "\(APIHelper.mapValueToPathItem(orgID))"
        let orgIDPostEscape = orgIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{orgID}", with: orgIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = influxDB2API.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)
    }

    /**
     List all organizations
     
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter offset: (query)  (optional)
     - parameter limit: (query)  (optional, default to 20)
     - parameter descending: (query)  (optional, default to false)
     - parameter org: (query) Filter organizations to a specific organization name. (optional)
     - parameter orgID: (query) Filter organizations to a specific organization ID. (optional)
     - parameter userID: (query) Filter organizations to a specific user ID. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func getOrgs(zapTraceSpan: String? = nil, offset: Int? = nil, limit: Int? = nil, descending: Bool? = nil, org: String? = nil, orgID: String? = nil, userID: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping ((_ data: Organizations?,_ error: Error?) -> Void)) {
        getOrgsWithRequestBuilder(zapTraceSpan: zapTraceSpan, offset: offset, limit: limit, descending: descending, org: org, orgID: orgID, userID: userID).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     List all organizations
     - GET /orgs
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter offset: (query)  (optional)
     - parameter limit: (query)  (optional, default to 20)
     - parameter descending: (query)  (optional, default to false)
     - parameter org: (query) Filter organizations to a specific organization name. (optional)
     - parameter orgID: (query) Filter organizations to a specific organization ID. (optional)
     - parameter userID: (query) Filter organizations to a specific user ID. (optional)
     - returns: RequestBuilder<Organizations> 
     */
    internal func getOrgsWithRequestBuilder(zapTraceSpan: String? = nil, offset: Int? = nil, limit: Int? = nil, descending: Bool? = nil, org: String? = nil, orgID: String? = nil, userID: String? = nil) -> RequestBuilder<Organizations> {
        let path = "/orgs"
        let URLString = influxDB2API.basePath + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "offset": offset?.encodeToJSON(), 
            "limit": limit?.encodeToJSON(), 
            "descending": descending?.encodeToJSON(), 
            "org": org?.encodeToJSON(), 
            "orgID": orgID?.encodeToJSON(), 
            "userID": userID?.encodeToJSON()
        ])
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Organizations>.Type = influxDB2API.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)
    }

    /**
     Retrieve an organization
     
     - parameter orgID: (path) The ID of the organization to get. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func getOrgsID(orgID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping ((_ data: Organization?,_ error: Error?) -> Void)) {
        getOrgsIDWithRequestBuilder(orgID: orgID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Retrieve an organization
     - GET /orgs/{orgID}
     - parameter orgID: (path) The ID of the organization to get. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<Organization> 
     */
    internal func getOrgsIDWithRequestBuilder(orgID: String, zapTraceSpan: String? = nil) -> RequestBuilder<Organization> {
        var path = "/orgs/{orgID}"
        let orgIDPreEscape = "\(APIHelper.mapValueToPathItem(orgID))"
        let orgIDPostEscape = orgIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{orgID}", with: orgIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Organization>.Type = influxDB2API.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)
    }

    /**
     List all members of an organization
     
     - parameter orgID: (path) The organization ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func getOrgsIDMembers(orgID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping ((_ data: ResourceMembers?,_ error: Error?) -> Void)) {
        getOrgsIDMembersWithRequestBuilder(orgID: orgID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     List all members of an organization
     - GET /orgs/{orgID}/members
     - parameter orgID: (path) The organization ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<ResourceMembers> 
     */
    internal func getOrgsIDMembersWithRequestBuilder(orgID: String, zapTraceSpan: String? = nil) -> RequestBuilder<ResourceMembers> {
        var path = "/orgs/{orgID}/members"
        let orgIDPreEscape = "\(APIHelper.mapValueToPathItem(orgID))"
        let orgIDPostEscape = orgIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{orgID}", with: orgIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<ResourceMembers>.Type = influxDB2API.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)
    }

    /**
     List all owners of an organization
     
     - parameter orgID: (path) The organization ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func getOrgsIDOwners(orgID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping ((_ data: ResourceOwners?,_ error: Error?) -> Void)) {
        getOrgsIDOwnersWithRequestBuilder(orgID: orgID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     List all owners of an organization
     - GET /orgs/{orgID}/owners
     - parameter orgID: (path) The organization ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<ResourceOwners> 
     */
    internal func getOrgsIDOwnersWithRequestBuilder(orgID: String, zapTraceSpan: String? = nil) -> RequestBuilder<ResourceOwners> {
        var path = "/orgs/{orgID}/owners"
        let orgIDPreEscape = "\(APIHelper.mapValueToPathItem(orgID))"
        let orgIDPostEscape = orgIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{orgID}", with: orgIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<ResourceOwners>.Type = influxDB2API.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)
    }

    /**
     List all secret keys for an organization
     
     - parameter orgID: (path) The organization ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func getOrgsIDSecrets(orgID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping ((_ data: SecretKeysResponse?,_ error: Error?) -> Void)) {
        getOrgsIDSecretsWithRequestBuilder(orgID: orgID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     List all secret keys for an organization
     - GET /orgs/{orgID}/secrets
     - parameter orgID: (path) The organization ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<SecretKeysResponse> 
     */
    internal func getOrgsIDSecretsWithRequestBuilder(orgID: String, zapTraceSpan: String? = nil) -> RequestBuilder<SecretKeysResponse> {
        var path = "/orgs/{orgID}/secrets"
        let orgIDPreEscape = "\(APIHelper.mapValueToPathItem(orgID))"
        let orgIDPostEscape = orgIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{orgID}", with: orgIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<SecretKeysResponse>.Type = influxDB2API.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)
    }

    /**
     Update an organization
     
     - parameter orgID: (path) The ID of the organization to get. 
     - parameter organization: (body) Organization update to apply 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func patchOrgsID(orgID: String, organization: Organization, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping ((_ data: Organization?,_ error: Error?) -> Void)) {
        patchOrgsIDWithRequestBuilder(orgID: orgID, organization: organization, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Update an organization
     - PATCH /orgs/{orgID}
     - parameter orgID: (path) The ID of the organization to get. 
     - parameter organization: (body) Organization update to apply 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<Organization> 
     */
    internal func patchOrgsIDWithRequestBuilder(orgID: String, organization: Organization, zapTraceSpan: String? = nil) -> RequestBuilder<Organization> {
        var path = "/orgs/{orgID}"
        let orgIDPreEscape = "\(APIHelper.mapValueToPathItem(orgID))"
        let orgIDPostEscape = orgIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{orgID}", with: orgIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: organization)

        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Organization>.Type = influxDB2API.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PATCH", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters, influxDB2API: influxDB2API)
    }

    /**
     Update secrets in an organization
     
     - parameter orgID: (path) The organization ID. 
     - parameter requestBody: (body) Secret key value pairs to update/add 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func patchOrgsIDSecrets(orgID: String, requestBody: [String:String], zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        patchOrgsIDSecretsWithRequestBuilder(orgID: orgID, requestBody: requestBody, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Update secrets in an organization
     - PATCH /orgs/{orgID}/secrets
     - parameter orgID: (path) The organization ID. 
     - parameter requestBody: (body) Secret key value pairs to update/add 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<Void> 
     */
    internal func patchOrgsIDSecretsWithRequestBuilder(orgID: String, requestBody: [String:String], zapTraceSpan: String? = nil) -> RequestBuilder<Void> {
        var path = "/orgs/{orgID}/secrets"
        let orgIDPreEscape = "\(APIHelper.mapValueToPathItem(orgID))"
        let orgIDPostEscape = orgIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{orgID}", with: orgIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: requestBody)

        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = influxDB2API.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "PATCH", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters, influxDB2API: influxDB2API)
    }

    /**
     Create an organization
     
     - parameter organization: (body) Organization to create 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func postOrgs(organization: Organization, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping ((_ data: Organization?,_ error: Error?) -> Void)) {
        postOrgsWithRequestBuilder(organization: organization, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Create an organization
     - POST /orgs
     - parameter organization: (body) Organization to create 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<Organization> 
     */
    internal func postOrgsWithRequestBuilder(organization: Organization, zapTraceSpan: String? = nil) -> RequestBuilder<Organization> {
        let path = "/orgs"
        let URLString = influxDB2API.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: organization)

        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Organization>.Type = influxDB2API.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters, influxDB2API: influxDB2API)
    }

    /**
     Add a member to an organization
     
     - parameter orgID: (path) The organization ID. 
     - parameter addResourceMemberRequestBody: (body) User to add as member 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func postOrgsIDMembers(orgID: String, addResourceMemberRequestBody: AddResourceMemberRequestBody, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping ((_ data: ResourceMember?,_ error: Error?) -> Void)) {
        postOrgsIDMembersWithRequestBuilder(orgID: orgID, addResourceMemberRequestBody: addResourceMemberRequestBody, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Add a member to an organization
     - POST /orgs/{orgID}/members
     - parameter orgID: (path) The organization ID. 
     - parameter addResourceMemberRequestBody: (body) User to add as member 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<ResourceMember> 
     */
    internal func postOrgsIDMembersWithRequestBuilder(orgID: String, addResourceMemberRequestBody: AddResourceMemberRequestBody, zapTraceSpan: String? = nil) -> RequestBuilder<ResourceMember> {
        var path = "/orgs/{orgID}/members"
        let orgIDPreEscape = "\(APIHelper.mapValueToPathItem(orgID))"
        let orgIDPostEscape = orgIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{orgID}", with: orgIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: addResourceMemberRequestBody)

        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<ResourceMember>.Type = influxDB2API.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters, influxDB2API: influxDB2API)
    }

    /**
     Add an owner to an organization
     
     - parameter orgID: (path) The organization ID. 
     - parameter addResourceMemberRequestBody: (body) User to add as owner 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func postOrgsIDOwners(orgID: String, addResourceMemberRequestBody: AddResourceMemberRequestBody, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping ((_ data: ResourceOwner?,_ error: Error?) -> Void)) {
        postOrgsIDOwnersWithRequestBuilder(orgID: orgID, addResourceMemberRequestBody: addResourceMemberRequestBody, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Add an owner to an organization
     - POST /orgs/{orgID}/owners
     - parameter orgID: (path) The organization ID. 
     - parameter addResourceMemberRequestBody: (body) User to add as owner 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<ResourceOwner> 
     */
    internal func postOrgsIDOwnersWithRequestBuilder(orgID: String, addResourceMemberRequestBody: AddResourceMemberRequestBody, zapTraceSpan: String? = nil) -> RequestBuilder<ResourceOwner> {
        var path = "/orgs/{orgID}/owners"
        let orgIDPreEscape = "\(APIHelper.mapValueToPathItem(orgID))"
        let orgIDPostEscape = orgIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{orgID}", with: orgIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: addResourceMemberRequestBody)

        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<ResourceOwner>.Type = influxDB2API.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters, influxDB2API: influxDB2API)
    }

    /**
     Delete secrets from an organization
     
     - parameter orgID: (path) The organization ID. 
     - parameter secretKeys: (body) Secret key to delete 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func postOrgsIDSecrets(orgID: String, secretKeys: SecretKeys, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        postOrgsIDSecretsWithRequestBuilder(orgID: orgID, secretKeys: secretKeys, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Delete secrets from an organization
     - POST /orgs/{orgID}/secrets/delete
     - parameter orgID: (path) The organization ID. 
     - parameter secretKeys: (body) Secret key to delete 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<Void> 
     */
    internal func postOrgsIDSecretsWithRequestBuilder(orgID: String, secretKeys: SecretKeys, zapTraceSpan: String? = nil) -> RequestBuilder<Void> {
        var path = "/orgs/{orgID}/secrets/delete"
        let orgIDPreEscape = "\(APIHelper.mapValueToPathItem(orgID))"
        let orgIDPostEscape = orgIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{orgID}", with: orgIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: secretKeys)

        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = influxDB2API.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters, influxDB2API: influxDB2API)
    }

}
}
