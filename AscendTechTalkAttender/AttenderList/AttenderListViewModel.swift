//
//  AttenderListViewModel.swift
//  AscendTechTalkAttender
//
//  Created by Hoang Chi Quan on 16/09/2022.
//

import Foundation
import Combine
import SwiftUI

class AttenderListViewModel: BaseViewModel {
    let service: AscendServiceProtocol
    
    @Published
    var attenders: [AttenderDTO] = []
    
    var selectingAttender: AttenderDTO? {
        self.attenders.first { $0.id == showingAttenderId }
    }
    
    @Published
    var showingAttenderId = -1
    
    @Published
    var isShowEdit: Bool = false
    
    init(service: AscendServiceProtocol) {
        self.service = service
        super.init()
    }
    
    func loadData() {
        self.service.getAttenderList()
            .receive(on: RunLoop.main)
            .map { list in list.map { AttenderDTO.init(data: $0) } }
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            }, receiveCancel: {
                self.isLoading = false
            }, receiveRequest: { _ in
                self.isLoading = true
            })
            .catch { [weak self] error -> AnyPublisher<[AttenderDTO], Never> in
                self?.errorMessage = error.description
                self?.isShowAlert = true
                return Empty()
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] data in
                self?.attenders = data
            }
            .store(in: &cancellables)
    }
    
    func deleteAttender(at indexes: IndexSet) {
        guard let index = indexes.first else { return }
        guard self.attenders.count > index else { return }
        let attender = self.attenders[index]
        self.service.delete(attender: attender.id)
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            }, receiveCancel: {
                self.isLoading = false
            }, receiveRequest: { _ in
                self.isLoading = true
            })
            .catch { [weak self] error -> AnyPublisher<Data, Never> in
                self?.errorMessage = error.description
                self?.isShowAlert = true
                return Empty()
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] data in
                self?.attenders.remove(at: index)
            }
            .store(in: &cancellables)
    }
    
    func isShowDetail(attender: Int) -> Binding<Bool> {
        Binding(
            get: { [weak self] in
                self?.showingAttenderId == attender
            },
            set: { [weak self] newValue in
                self?.showingAttenderId = newValue ? attender : -1
            }
        )
    }
}
