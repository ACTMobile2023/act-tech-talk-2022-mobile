//
//  AscendService.swift
//  AscendTechTalkAttender
//
//  Created by Hoang Chi Quan on 16/09/2022.
//

import Foundation
import Combine

protocol AscendServiceProtocol {
    func getAttenderList() -> AnyPublisher<[Attender], AscendError>
    func create(attender: Attender) -> AnyPublisher<Attender, AscendError>
    func update(attender: Attender) -> AnyPublisher<Data, AscendError>
    func delete(attender: Int) -> AnyPublisher<Data, AscendError>
}

class AscendService: AscendServiceProtocol {
    func getAttenderList() -> AnyPublisher<[Attender], AscendError> {
        AscendNetworking.perform(request: .getAttenderList)
            .tryMap { try $0.map([Attender].self, at: "data.attenders") }
            .mapError(AscendError.init)
            .eraseToAnyPublisher()
    }
    
    func create(attender: Attender) -> AnyPublisher<Attender, AscendError> {
        AscendNetworking.perform(request: .create(attender: attender))
            .tryMap { try $0.map(Attender.self, at: "data") }
            .mapError(AscendError.init)
            .eraseToAnyPublisher()
    }
    
    func update(attender: Attender) -> AnyPublisher<Data, AscendError> {
        guard let id = attender.id else {
            return Fail(error: AscendError.generalError(message: "Invalid attender id"))
                .eraseToAnyPublisher()
        }
        return AscendNetworking.perform(request: .update(attender: attender, id: id))
            .mapError(AscendError.init)
            .eraseToAnyPublisher()
    }
    
    func delete(attender: Int) -> AnyPublisher<Data, AscendError> {
        AscendNetworking.perform(request: .delete(attender: attender))
            .mapError(AscendError.init)
            .eraseToAnyPublisher()
    }
}
