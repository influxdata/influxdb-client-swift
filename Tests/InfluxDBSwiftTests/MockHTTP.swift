import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import XCTest

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: MockURLProtocol.url, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: [:])!
    }
}

class MockURLProtocol: URLProtocol {
    static let url = URL(string: InfluxDBClientTests.dbURL())!

    static var handler: ((URLRequest, Data?) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.handler else {
            XCTFail("Missing handler: 'MockURLProtocol.handler = { request in...'")
            return
        }

        do {
            let (response, data) = try handler(request, request.bodyValue)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {
    }
}

private extension URLRequest {
    var bodyValue: Data? {
        guard let httpBody = httpBodyStreamData() else {
            return nil
        }
        return httpBody
    }

    private func httpBodyStreamData() -> Data? {
        guard let bodyStream = self.httpBodyStream else {
            if let httpBody = self.httpBody {
                return httpBody
            }
            return nil
        }

        return Data(reading: bodyStream)
    }
}

private extension Data {
    init(reading bodyStream: InputStream) {
        self.init()

        bodyStream.open()

        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 1024)
        defer {
            buffer.deallocate()
        }

        while bodyStream.hasBytesAvailable {
            self.append(buffer, count: bodyStream.read(buffer, maxLength: 1024))
        }
    }
}
