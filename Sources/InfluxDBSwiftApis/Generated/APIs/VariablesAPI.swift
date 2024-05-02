//
// VariablesAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
import InfluxDBSwift

extension InfluxDB2API {


public struct VariablesAPI: Sendable {
    private let influxDB2API: InfluxDB2API

    public init(influxDB2API: InfluxDB2API) {
        self.influxDB2API = influxDB2API
    }

    /**
     Delete a variable
     
     - parameter variableID: (path) The variable ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func deleteVariablesID(variableID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: Void?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        deleteVariablesIDWithRequestBuilder(variableID: variableID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    #if swift(>=5.5)
    /**
     Delete a variable
     
     - parameter variableID: (path) The variable ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func deleteVariablesID(variableID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil) async throws -> Void? {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void?, Error>) -> Void in
            deleteVariablesIDWithRequestBuilder(variableID: variableID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
                switch result {
                case .success:
                    continuation.resume(returning: ())
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    #endif

    /**
     Delete a variable
     - DELETE /variables/{variableID}
     - parameter variableID: (path) The variable ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<Void> 
     */
    internal func deleteVariablesIDWithRequestBuilder(variableID: String, zapTraceSpan: String? = nil) -> RequestBuilder<Void> {
        var path = "/variables/{variableID}"
        let variableIDPreEscape = "\(APIHelper.mapValueToPathItem(variableID))"
        let variableIDPostEscape = variableIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{variableID}", with: variableIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void> = influxDB2API.requestBuilderFactory.getRequestNonDecodableBuilder(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     Delete a label from a variable
     
     - parameter variableID: (path) The variable ID. 
     - parameter labelID: (path) The label ID to delete. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func deleteVariablesIDLabelsID(variableID: String, labelID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: Void?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        deleteVariablesIDLabelsIDWithRequestBuilder(variableID: variableID, labelID: labelID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    #if swift(>=5.5)
    /**
     Delete a label from a variable
     
     - parameter variableID: (path) The variable ID. 
     - parameter labelID: (path) The label ID to delete. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func deleteVariablesIDLabelsID(variableID: String, labelID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil) async throws -> Void? {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void?, Error>) -> Void in
            deleteVariablesIDLabelsIDWithRequestBuilder(variableID: variableID, labelID: labelID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
                switch result {
                case .success:
                    continuation.resume(returning: ())
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    #endif

    /**
     Delete a label from a variable
     - DELETE /variables/{variableID}/labels/{labelID}
     - parameter variableID: (path) The variable ID. 
     - parameter labelID: (path) The label ID to delete. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<Void> 
     */
    internal func deleteVariablesIDLabelsIDWithRequestBuilder(variableID: String, labelID: String, zapTraceSpan: String? = nil) -> RequestBuilder<Void> {
        var path = "/variables/{variableID}/labels/{labelID}"
        let variableIDPreEscape = "\(APIHelper.mapValueToPathItem(variableID))"
        let variableIDPostEscape = variableIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{variableID}", with: variableIDPostEscape, options: .literal, range: nil)
        let labelIDPreEscape = "\(APIHelper.mapValueToPathItem(labelID))"
        let labelIDPostEscape = labelIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{labelID}", with: labelIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void> = influxDB2API.requestBuilderFactory.getRequestNonDecodableBuilder(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     List all variables
     
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter org: (query) The name of the organization. (optional)
     - parameter orgID: (query) The organization ID. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func getVariables(zapTraceSpan: String? = nil, org: String? = nil, orgID: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: Variables?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        getVariablesWithRequestBuilder(zapTraceSpan: zapTraceSpan, org: org, orgID: orgID).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    #if swift(>=5.5)
    /**
     List all variables
     
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter org: (query) The name of the organization. (optional)
     - parameter orgID: (query) The organization ID. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getVariables(zapTraceSpan: String? = nil, org: String? = nil, orgID: String? = nil, apiResponseQueue: DispatchQueue? = nil) async throws -> Variables? {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Variables?, Error>) -> Void in
            getVariablesWithRequestBuilder(zapTraceSpan: zapTraceSpan, org: org, orgID: orgID).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
                switch result {
                case let .success(response):
                    continuation.resume(returning: response.body)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    #endif

    /**
     List all variables
     - GET /variables
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter org: (query) The name of the organization. (optional)
     - parameter orgID: (query) The organization ID. (optional)
     - returns: RequestBuilder<Variables> 
     */
    internal func getVariablesWithRequestBuilder(zapTraceSpan: String? = nil, org: String? = nil, orgID: String? = nil) -> RequestBuilder<Variables> {
        let path = "/variables"
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "org": org?.encodeToJSON(), 
            "orgID": orgID?.encodeToJSON()
        ])
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Variables> = influxDB2API.requestBuilderFactory.getRequestDecodableBuilder(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     Retrieve a variable
     
     - parameter variableID: (path) The variable ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func getVariablesID(variableID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: Variable?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        getVariablesIDWithRequestBuilder(variableID: variableID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    #if swift(>=5.5)
    /**
     Retrieve a variable
     
     - parameter variableID: (path) The variable ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getVariablesID(variableID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil) async throws -> Variable? {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Variable?, Error>) -> Void in
            getVariablesIDWithRequestBuilder(variableID: variableID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
                switch result {
                case let .success(response):
                    continuation.resume(returning: response.body)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    #endif

    /**
     Retrieve a variable
     - GET /variables/{variableID}
     - parameter variableID: (path) The variable ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<Variable> 
     */
    internal func getVariablesIDWithRequestBuilder(variableID: String, zapTraceSpan: String? = nil) -> RequestBuilder<Variable> {
        var path = "/variables/{variableID}"
        let variableIDPreEscape = "\(APIHelper.mapValueToPathItem(variableID))"
        let variableIDPostEscape = variableIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{variableID}", with: variableIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Variable> = influxDB2API.requestBuilderFactory.getRequestDecodableBuilder(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     List all labels for a variable
     
     - parameter variableID: (path) The variable ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func getVariablesIDLabels(variableID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: LabelsResponse?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        getVariablesIDLabelsWithRequestBuilder(variableID: variableID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    #if swift(>=5.5)
    /**
     List all labels for a variable
     
     - parameter variableID: (path) The variable ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getVariablesIDLabels(variableID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil) async throws -> LabelsResponse? {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<LabelsResponse?, Error>) -> Void in
            getVariablesIDLabelsWithRequestBuilder(variableID: variableID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
                switch result {
                case let .success(response):
                    continuation.resume(returning: response.body)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    #endif

    /**
     List all labels for a variable
     - GET /variables/{variableID}/labels
     - parameter variableID: (path) The variable ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<LabelsResponse> 
     */
    internal func getVariablesIDLabelsWithRequestBuilder(variableID: String, zapTraceSpan: String? = nil) -> RequestBuilder<LabelsResponse> {
        var path = "/variables/{variableID}/labels"
        let variableIDPreEscape = "\(APIHelper.mapValueToPathItem(variableID))"
        let variableIDPostEscape = variableIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{variableID}", with: variableIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<LabelsResponse> = influxDB2API.requestBuilderFactory.getRequestDecodableBuilder(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     Update a variable
     
     - parameter variableID: (path) The variable ID. 
     - parameter variable: (body) Variable update to apply 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func patchVariablesID(variableID: String, variable: Variable, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: Variable?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        patchVariablesIDWithRequestBuilder(variableID: variableID, variable: variable, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    #if swift(>=5.5)
    /**
     Update a variable
     
     - parameter variableID: (path) The variable ID. 
     - parameter variable: (body) Variable update to apply 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func patchVariablesID(variableID: String, variable: Variable, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil) async throws -> Variable? {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Variable?, Error>) -> Void in
            patchVariablesIDWithRequestBuilder(variableID: variableID, variable: variable, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
                switch result {
                case let .success(response):
                    continuation.resume(returning: response.body)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    #endif

    /**
     Update a variable
     - PATCH /variables/{variableID}
     - parameter variableID: (path) The variable ID. 
     - parameter variable: (body) Variable update to apply 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<Variable> 
     */
    internal func patchVariablesIDWithRequestBuilder(variableID: String, variable: Variable, zapTraceSpan: String? = nil) -> RequestBuilder<Variable> {
        var path = "/variables/{variableID}"
        let variableIDPreEscape = "\(APIHelper.mapValueToPathItem(variableID))"
        let variableIDPostEscape = variableIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{variableID}", with: variableIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: variable)

        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Variable> = influxDB2API.requestBuilderFactory.getRequestDecodableBuilder(method: "PATCH", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     Create a variable
     
     - parameter variable: (body) Variable to create 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func postVariables(variable: Variable, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: Variable?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        postVariablesWithRequestBuilder(variable: variable, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    #if swift(>=5.5)
    /**
     Create a variable
     
     - parameter variable: (body) Variable to create 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func postVariables(variable: Variable, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil) async throws -> Variable? {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Variable?, Error>) -> Void in
            postVariablesWithRequestBuilder(variable: variable, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
                switch result {
                case let .success(response):
                    continuation.resume(returning: response.body)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    #endif

    /**
     Create a variable
     - POST /variables
     - parameter variable: (body) Variable to create 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<Variable> 
     */
    internal func postVariablesWithRequestBuilder(variable: Variable, zapTraceSpan: String? = nil) -> RequestBuilder<Variable> {
        let path = "/variables"
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: variable)

        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Variable> = influxDB2API.requestBuilderFactory.getRequestDecodableBuilder(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     Add a label to a variable
     
     - parameter variableID: (path) The variable ID. 
     - parameter labelMapping: (body) Label to add 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func postVariablesIDLabels(variableID: String, labelMapping: LabelMapping, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: LabelResponse?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        postVariablesIDLabelsWithRequestBuilder(variableID: variableID, labelMapping: labelMapping, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    #if swift(>=5.5)
    /**
     Add a label to a variable
     
     - parameter variableID: (path) The variable ID. 
     - parameter labelMapping: (body) Label to add 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func postVariablesIDLabels(variableID: String, labelMapping: LabelMapping, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil) async throws -> LabelResponse? {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<LabelResponse?, Error>) -> Void in
            postVariablesIDLabelsWithRequestBuilder(variableID: variableID, labelMapping: labelMapping, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
                switch result {
                case let .success(response):
                    continuation.resume(returning: response.body)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    #endif

    /**
     Add a label to a variable
     - POST /variables/{variableID}/labels
     - parameter variableID: (path) The variable ID. 
     - parameter labelMapping: (body) Label to add 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<LabelResponse> 
     */
    internal func postVariablesIDLabelsWithRequestBuilder(variableID: String, labelMapping: LabelMapping, zapTraceSpan: String? = nil) -> RequestBuilder<LabelResponse> {
        var path = "/variables/{variableID}/labels"
        let variableIDPreEscape = "\(APIHelper.mapValueToPathItem(variableID))"
        let variableIDPostEscape = variableIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{variableID}", with: variableIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: labelMapping)

        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<LabelResponse> = influxDB2API.requestBuilderFactory.getRequestDecodableBuilder(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     Replace a variable
     
     - parameter variableID: (path) The variable ID. 
     - parameter variable: (body) Variable to replace 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func putVariablesID(variableID: String, variable: Variable, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: Variable?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        putVariablesIDWithRequestBuilder(variableID: variableID, variable: variable, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    #if swift(>=5.5)
    /**
     Replace a variable
     
     - parameter variableID: (path) The variable ID. 
     - parameter variable: (body) Variable to replace 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func putVariablesID(variableID: String, variable: Variable, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil) async throws -> Variable? {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Variable?, Error>) -> Void in
            putVariablesIDWithRequestBuilder(variableID: variableID, variable: variable, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
                switch result {
                case let .success(response):
                    continuation.resume(returning: response.body)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    #endif

    /**
     Replace a variable
     - PUT /variables/{variableID}
     - parameter variableID: (path) The variable ID. 
     - parameter variable: (body) Variable to replace 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<Variable> 
     */
    internal func putVariablesIDWithRequestBuilder(variableID: String, variable: Variable, zapTraceSpan: String? = nil) -> RequestBuilder<Variable> {
        var path = "/variables/{variableID}"
        let variableIDPreEscape = "\(APIHelper.mapValueToPathItem(variableID))"
        let variableIDPostEscape = variableIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{variableID}", with: variableIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: variable)

        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Variable> = influxDB2API.requestBuilderFactory.getRequestDecodableBuilder(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

}
}
