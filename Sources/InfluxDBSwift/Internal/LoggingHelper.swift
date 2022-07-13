//
// Created by Jakub Bednář on 13.07.2022.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension InfluxDBClient {
    /// The logger for logging HTTP request/response.
    public class HTTPLogger {
        /// Enable debugging for HTTP request/response.
        internal let debugging: Bool

        /// Create a new HTTPLogger.
        ///
        /// - Parameters:
        ///   - debugging: optional Enable debugging for HTTP request/response. Default `false`.
        public init(debugging: Bool? = nil) {
            self.debugging = debugging ?? false
        }

        /// Log the HTTP request.
        ///
        /// - Parameter request: to log
        public func log(_ request: URLRequest?) {
            print(">>> Request: '\(request?.httpMethod ?? "") \(request?.url?.absoluteString ?? "")'")
            log_headers(headers: request?.allHTTPHeaderFields, prefix: ">>>")
            log_body(body: request?.httpBody, prefix: ">>>")
        }

        /// Log the HTTP response.
        ///
        /// - Parameters:
        ///   - response: to log
        ///   - data: response data
        public func log(_ response: URLResponse?, _ data: Data?) {
            let httpResponse = response as? HTTPURLResponse
            print("<<< Response: \(httpResponse?.statusCode ?? 0)")
            log_headers(headers: httpResponse?.allHeaderFields, prefix: "<<<")
            log_body(body: data, prefix: "<<<")
        }

        func log_body(body: Data?, prefix: String) {
            if let body = body {
                print("\(prefix) Body: \(String(decoding: body, as: UTF8.self))")
            }
        }

        func log_headers(headers: [AnyHashable: Any]?, prefix: String) {
            headers?.forEach { key, value in
//                var value = v
//                if "authorization" == String(describing: key).lowercased() {
//                    value = "xxx"
//                }
                print("\(prefix) \(key): \(value)")
            }
        }
    }
}
