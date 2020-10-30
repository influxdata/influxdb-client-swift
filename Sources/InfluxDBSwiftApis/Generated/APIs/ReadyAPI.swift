//
// ReadyAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

extension InfluxDB2API {


public class ReadyAPI {
    private let influxDB2API: InfluxDB2API

    public init(influxDB2API: InfluxDB2API) {
        self.influxDB2API = influxDB2API
    }

    /**
     Get the readiness of an instance at startup
     
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func getReady(zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping ((_ data: Ready?,_ error: Error?) -> Void)) {
        getReadyWithRequestBuilder(zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Get the readiness of an instance at startup
     - GET /ready
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<Ready> 
     */
    internal func getReadyWithRequestBuilder(zapTraceSpan: String? = nil) -> RequestBuilder<Ready> {
        let path = "/ready"
        let URLString = influxDB2API.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Ready>.Type = influxDB2API.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)
    }

}
}
