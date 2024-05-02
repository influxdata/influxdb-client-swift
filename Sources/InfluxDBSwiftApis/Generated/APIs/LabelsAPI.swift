//
// LabelsAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
import InfluxDBSwift

extension InfluxDB2API {


public struct LabelsAPI: Sendable {
    private let influxDB2API: InfluxDB2API

    public init(influxDB2API: InfluxDB2API) {
        self.influxDB2API = influxDB2API
    }

    /**
     Delete a label
     
     - parameter labelID: (path) The ID of the label to delete. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func deleteLabelsID(labelID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: Void?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        deleteLabelsIDWithRequestBuilder(labelID: labelID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
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
     Delete a label
     
     - parameter labelID: (path) The ID of the label to delete. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func deleteLabelsID(labelID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil) async throws -> Void? {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void?, Error>) -> Void in
            deleteLabelsIDWithRequestBuilder(labelID: labelID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
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
     Delete a label
     - DELETE /labels/{labelID}
     - parameter labelID: (path) The ID of the label to delete. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<Void> 
     */
    internal func deleteLabelsIDWithRequestBuilder(labelID: String, zapTraceSpan: String? = nil) -> RequestBuilder<Void> {
        var path = "/labels/{labelID}"
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
     List all labels
     
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter orgID: (query) The organization ID. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func getLabels(zapTraceSpan: String? = nil, orgID: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: LabelsResponse?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        getLabelsWithRequestBuilder(zapTraceSpan: zapTraceSpan, orgID: orgID).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
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
     List all labels
     
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter orgID: (query) The organization ID. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getLabels(zapTraceSpan: String? = nil, orgID: String? = nil, apiResponseQueue: DispatchQueue? = nil) async throws -> LabelsResponse? {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<LabelsResponse?, Error>) -> Void in
            getLabelsWithRequestBuilder(zapTraceSpan: zapTraceSpan, orgID: orgID).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
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
     List all labels
     - GET /labels
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter orgID: (query) The organization ID. (optional)
     - returns: RequestBuilder<LabelsResponse> 
     */
    internal func getLabelsWithRequestBuilder(zapTraceSpan: String? = nil, orgID: String? = nil) -> RequestBuilder<LabelsResponse> {
        let path = "/labels"
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "orgID": orgID?.encodeToJSON()
        ])
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<LabelsResponse> = influxDB2API.requestBuilderFactory.getRequestDecodableBuilder(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     Retrieve a label
     
     - parameter labelID: (path) The ID of the label to update. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func getLabelsID(labelID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: LabelResponse?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        getLabelsIDWithRequestBuilder(labelID: labelID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
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
     Retrieve a label
     
     - parameter labelID: (path) The ID of the label to update. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getLabelsID(labelID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil) async throws -> LabelResponse? {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<LabelResponse?, Error>) -> Void in
            getLabelsIDWithRequestBuilder(labelID: labelID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
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
     Retrieve a label
     - GET /labels/{labelID}
     - parameter labelID: (path) The ID of the label to update. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<LabelResponse> 
     */
    internal func getLabelsIDWithRequestBuilder(labelID: String, zapTraceSpan: String? = nil) -> RequestBuilder<LabelResponse> {
        var path = "/labels/{labelID}"
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

        let requestBuilder: RequestBuilder<LabelResponse> = influxDB2API.requestBuilderFactory.getRequestDecodableBuilder(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     Update a label
     
     - parameter labelID: (path) The ID of the label to update. 
     - parameter labelUpdate: (body) Label update 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func patchLabelsID(labelID: String, labelUpdate: LabelUpdate, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: LabelResponse?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        patchLabelsIDWithRequestBuilder(labelID: labelID, labelUpdate: labelUpdate, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
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
     Update a label
     
     - parameter labelID: (path) The ID of the label to update. 
     - parameter labelUpdate: (body) Label update 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func patchLabelsID(labelID: String, labelUpdate: LabelUpdate, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil) async throws -> LabelResponse? {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<LabelResponse?, Error>) -> Void in
            patchLabelsIDWithRequestBuilder(labelID: labelID, labelUpdate: labelUpdate, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
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
     Update a label
     - PATCH /labels/{labelID}
     - parameter labelID: (path) The ID of the label to update. 
     - parameter labelUpdate: (body) Label update 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<LabelResponse> 
     */
    internal func patchLabelsIDWithRequestBuilder(labelID: String, labelUpdate: LabelUpdate, zapTraceSpan: String? = nil) -> RequestBuilder<LabelResponse> {
        var path = "/labels/{labelID}"
        let labelIDPreEscape = "\(APIHelper.mapValueToPathItem(labelID))"
        let labelIDPostEscape = labelIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{labelID}", with: labelIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: labelUpdate)

        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<LabelResponse> = influxDB2API.requestBuilderFactory.getRequestDecodableBuilder(method: "PATCH", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     Create a label
     
     - parameter labelCreateRequest: (body) Label to create 
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func postLabels(labelCreateRequest: LabelCreateRequest, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: LabelResponse?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        postLabelsWithRequestBuilder(labelCreateRequest: labelCreateRequest).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
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
     Create a label
     
     - parameter labelCreateRequest: (body) Label to create 
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func postLabels(labelCreateRequest: LabelCreateRequest, apiResponseQueue: DispatchQueue? = nil) async throws -> LabelResponse? {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<LabelResponse?, Error>) -> Void in
            postLabelsWithRequestBuilder(labelCreateRequest: labelCreateRequest).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
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
     Create a label
     - POST /labels
     - parameter labelCreateRequest: (body) Label to create 
     - returns: RequestBuilder<LabelResponse> 
     */
    internal func postLabelsWithRequestBuilder(labelCreateRequest: LabelCreateRequest) -> RequestBuilder<LabelResponse> {
        let path = "/labels"
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: labelCreateRequest)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<LabelResponse> = influxDB2API.requestBuilderFactory.getRequestDecodableBuilder(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: [:], influxDB2API: influxDB2API)

        return requestBuilder
    }

}
}
