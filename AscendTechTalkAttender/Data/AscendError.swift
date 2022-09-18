//
//  AscendError.swift
//  AscendTechTalkAttender
//
//  Created by Hoang Chi Quan on 16/09/2022.
//

import Foundation

enum AscendError: Error {
    case systemError(error: Error)
    case invalidRequest
    case emptyResponse
    case generalError(message: String)
    
    init(_ error: Error) {
        if let asError = error as? AscendError {
            self = asError
        } else {
            self = AscendError.systemError(error: error)
        }
    }
    
    var description: String {
        switch self {
        case .systemError(let error):
            return error.localizedDescription
        case .invalidRequest:
            return "Yêu cầu không hợp lệ."
        case .emptyResponse:
            return "Phản hồi rỗng"
        case .generalError(let message):
            return message
        }
    }
}
