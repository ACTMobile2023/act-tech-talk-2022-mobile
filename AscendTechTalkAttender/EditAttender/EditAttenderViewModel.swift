//
//  EditAttenderViewModel.swift
//  AscendTechTalkAttender
//
//  Created by Hoang Chi Quan on 17/09/2022.
//

import Foundation
import SwiftUI
import Combine

class EditAttenderViewModel: BaseViewModel {
    
    let service: AscendServiceProtocol
    let isEdit: Bool
    
    @Published
    var attender = AttenderBinding()
    
    @Published
    var isBack = false
    
    let didUpdate = PassthroughSubject<AttenderDTO, Never>()
    let didAdd = PassthroughSubject<Void, Never>()
    
    var isBackPublisher: AnyPublisher<Bool, Never> {
        self.$isBack
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    init(service: AscendServiceProtocol, attender: AttenderDTO?) {
        self.service = service
        self.isEdit = attender != nil
        if let attender = attender {
            self.attender = AttenderBinding(data: attender)
        }
    }
    
    func submitProfile() {
        request()
            .receive(on: RunLoop.main)
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            }, receiveCancel: {
                self.isLoading = false
            }, receiveRequest: { _ in
                self.isLoading = true
            })
            .catch { [weak self] error -> AnyPublisher<Any, Never> in
                self?.errorMessage = error.description
                self?.isShowAlert = true
                return Empty()
                    .eraseToAnyPublisher()
            }
            .sink { _ in
                self.isBack = true
            }
            .store(in: &cancellables)
    }
    
    func request() -> AnyPublisher<Any, AscendError> {
        let data = attender.dataToSubmit()
        if self.isEdit {
            return self.service.update(attender: data)
                .handleEvents(receiveOutput: { [weak self] data in
                    guard let self = self else { return }
                    self.didUpdate.send(AttenderDTO(data: self.attender.dataToSubmit()))
                })
                .map { $0 as Any }
                .eraseToAnyPublisher()
        } else {
            return self.service.create(attender: data)
                .handleEvents(receiveOutput: { [didAdd] _ in
                    didAdd.send()
                })
                .map { $0 as Any }
                .eraseToAnyPublisher()
        }
    }
}
