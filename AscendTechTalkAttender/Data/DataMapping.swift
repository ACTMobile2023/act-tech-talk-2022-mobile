//
//  DataMapping.swift
//  AscendTechTalkAttender
//
//  Created by Hoang Chi Quan on 16/09/2022.
//

import Foundation

extension Data {
    func map<T: Decodable>(_ type: T.Type, at keyPath: String) throws -> T {
        let response = try JSONSerialization.jsonObject(with: self)
        guard let responseJson = (response as? NSDictionary)?.value(forKeyPath: keyPath) else {
            throw AscendError.emptyResponse
        }
        let reponseData = try JSONSerialization.data(withJSONObject: responseJson)
        return try JSONDecoder().decode(T.self, from: reponseData)
    }
}
