//
//  AscendTechTalkAttenderApp.swift
//  AscendTechTalkAttender
//
//  Created by Hoang Chi Quan on 16/09/2022.
//

import SwiftUI

@main
struct AscendTechTalkAttenderApp: App {
    let service = AscendService()
    var body: some Scene {
        WindowGroup {
            let viewModel = AttenderListViewModel(service: service)
            AttenderListView(viewModel: viewModel)
        }
    }
}
