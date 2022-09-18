//
//  AttenderDetailViewModel.swift
//  AscendTechTalkAttender
//
//  Created by Hoang Chi Quan on 17/09/2022.
//

import Foundation
import Combine
import SwiftUI

class AttenderDetailViewModel: BaseViewModel {
    
    @Published
    var attender: AttenderDTO
    
    @Published
    var isBack: Bool = false
    
    @Published
    var isEdit = false
    
    let didUpdate = PassthroughSubject<AttenderDTO, Never>()
    
    var isBackPublisher: AnyPublisher<Bool, Never> {
        self.$isBack
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    init(attender: AttenderDTO) {
        self.attender = attender
    }
}
