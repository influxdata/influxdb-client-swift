//
// SetupAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

extension InfluxDB2API {


public class SetupAPI {
    private let influxDB2API: InfluxDB2API

    public init(influxDB2API: InfluxDB2API) {
        self.influxDB2API = influxDB2API
    }

    /**
     Check if database has default user, org, bucket
     
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func getSetup(zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping ((_ data: IsOnboarding?,_ error: Error?) -> Void)) {
        getSetupWithRequestBuilder(zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Check if database has default user, org, bucket
     - GET /setup
     - Returns `true` if no default user, organization, or bucket has been created.
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<IsOnboarding> 
     */
    internal func getSetupWithRequestBuilder(zapTraceSpan: String? = nil) -> RequestBuilder<IsOnboarding> {
        let path = "/setup"
        let URLString = influxDB2API.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<IsOnboarding> = influxDB2API.requestBuilderFactory.getRequestDecodableBuilder(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     Set up initial user, org and bucket
     
     - parameter onboardingRequest: (body) Source to create 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func postSetup(onboardingRequest: OnboardingRequest, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping ((_ data: OnboardingResponse?,_ error: Error?) -> Void)) {
        postSetupWithRequestBuilder(onboardingRequest: onboardingRequest, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Set up initial user, org and bucket
     - POST /setup
     - Post an onboarding request to set up initial user, org and bucket.
     - parameter onboardingRequest: (body) Source to create 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<OnboardingResponse> 
     */
    internal func postSetupWithRequestBuilder(onboardingRequest: OnboardingRequest, zapTraceSpan: String? = nil) -> RequestBuilder<OnboardingResponse> {
        let path = "/setup"
        let URLString = influxDB2API.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: onboardingRequest)

        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<OnboardingResponse> = influxDB2API.requestBuilderFactory.getRequestDecodableBuilder(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     Set up a new user, org and bucket
     
     - parameter onboardingRequest: (body) Source to create 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func postSetupUser(onboardingRequest: OnboardingRequest, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping ((_ data: OnboardingResponse?,_ error: Error?) -> Void)) {
        postSetupUserWithRequestBuilder(onboardingRequest: onboardingRequest, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Set up a new user, org and bucket
     - POST /setup/user
     - Post an onboarding request to set up a new user, org and bucket.
     - parameter onboardingRequest: (body) Source to create 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<OnboardingResponse> 
     */
    internal func postSetupUserWithRequestBuilder(onboardingRequest: OnboardingRequest, zapTraceSpan: String? = nil) -> RequestBuilder<OnboardingResponse> {
        let path = "/setup/user"
        let URLString = influxDB2API.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: onboardingRequest)

        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<OnboardingResponse> = influxDB2API.requestBuilderFactory.getRequestDecodableBuilder(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

}
}