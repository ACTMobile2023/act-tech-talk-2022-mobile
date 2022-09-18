//
//  BaseViewModel.swift
//  AscendTechTalkAttender
//
//  Created by Hoang Chi Quan on 16/09/2022.
//

import Foundation
import Combine

class BaseViewModel: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    
    var errorMessage: String = ""
    
    @Published
    var isShowAlert: Bool = false
    
    @Published
    var isLoading: Bool = false
}
