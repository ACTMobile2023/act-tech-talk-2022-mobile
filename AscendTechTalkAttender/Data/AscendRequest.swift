//
//  AscendRequest.swift
//  AscendTechTalkAttender
//
//  Created by Hoang Chi Quan on 16/09/2022.
//

import Foundation

enum AscendRequest {
    case getAttenderList
    case create(attender: Attender)
    case update(attender: Attender, id: Int)
    case delete(attender: Int)
    
    var url: URL? {
        URL(string: urlString)
    }
    
    var path: String {
        switch self {
        case .getAttenderList, .create:
            return "attenders"
        case let .update(_, id):
            return "attenders/\(id)"
        case .delete(let attender):
            return "attenders/\(attender)"
        }
    }
    
    var method: String {
        switch self {
        case .getAttenderList:
            return "GET"
        case .create:
            return "POST"
        case .update:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
    
    var body: Data? {
        switch self {
        case .getAttenderList:
            return nil
        case .create(let attender):
            return try? JSONEncoder().encode(attender)
        case .update(let attender, _):
            return try? JSONEncoder().encode(attender)
        case .delete:
            return nil
        }
    }
    
    var urlString: String {
        "http://149.28.141.129:8765/tech-talk/\(path)"
    }
}
