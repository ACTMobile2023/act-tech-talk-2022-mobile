//
//  AscendNetworking.swift
//  AscendTechTalkAttender
//
//  Created by Hoang Chi Quan on 16/09/2022.
//

import Foundation
import Combine

class AscendNetworking {
    static func perform(request: AscendRequest) -> AnyPublisher<Data, AscendError> {
        guard let url = request.url else {
            return Fail(error: AscendError.invalidRequest)
                .eraseToAnyPublisher()
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method
        if let data = request.body {
            urlRequest.httpBody = data
            urlRequest.setValue("application/json; charse=UTF-8", forHTTPHeaderField: "Content-Type")
        }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { response -> (data: Data, response: URLResponse) in
                let status = try response.data.map(AscendStatus.self, at: "status")
                if status.code == "success" {
                    return response
                } else {
                    throw AscendError.generalError(message: status.message ?? "Unknown")
                }
            }
            .map { $0.data }
            .handleEvents(receiveOutput: { data in
                guard let json = try? JSONSerialization.jsonObject(with: data) else { return }
                print("=========RESPONSE:==========")
                print(json)
                print("============================")
            })
            .mapError { AscendError.systemError(error: $0) }
            .eraseToAnyPublisher()
    }
}

extension URLRequest {
    func cURL(pretty: Bool = false) -> String {
        let newLine = pretty ? "\\\n" : ""
        let method = (pretty ? "--request " : "-X ") + "\(self.httpMethod ?? "GET") \(newLine)"
        let url: String = (pretty ? "--url " : "") + "\'\(self.url?.absoluteString ?? "")\' \(newLine)"
        
        var cURL = "curl "
        var header = ""
        var data: String = ""
        
        if let httpHeaders = self.allHTTPHeaderFields, !httpHeaders.keys.isEmpty {
            for (key, value) in httpHeaders {
                header += (pretty ? "--header " : "-H ") + "\'\(key): \(value)\' \(newLine)"
            }
        }
        
        if let bodyData = self.httpBody, let bodyString = String(data: bodyData, encoding: .utf8), !bodyString.isEmpty {
            data = "--data '\(bodyString)'"
        }
        
        cURL += method + url + header + data
        
        return cURL
    }
}
