//
//  AttenderListView.swift
//  AscendTechTalkAttender
//
//  Created by Hoang Chi Quan on 16/09/2022.
//

import SwiftUI
import Combine

struct AttenderListView: View {
    
    @ObservedObject var viewModel: AttenderListViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.attenders) { attender in
                        NavigationLink(isActive: viewModel.isShowDetail(attender: attender.id)) {
                            self.detailView(of: attender)
                        } label: {
                            AttenderView(attender: attender)
                        }
                        .isDetailLink(false)
                    }
                    .onDelete { indexSet in
                        viewModel.deleteAttender(at: indexSet)
                    }
                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        NavigationLink(isActive: $viewModel.isShowEdit) {
                            editView(of: viewModel.selectingAttender)
                        } label: {
                            Button {
                                viewModel.isShowEdit = true
                            } label: {
                                Image("ic_add")
                            }
                            .padding(16)
                        }
                    }
                }
                
                if viewModel.isLoading {
                    LoadingView(text: "Loading data...")
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            viewModel.loadData()
        }
        .alert(isPresented: $viewModel.isShowAlert) {
            Alert(
                title: Text("Lỗi"),
                message: Text(viewModel.errorMessage)
            )
        }
    }
    
    func detailView(of attender: AttenderDTO) -> AttenderDetailView {
        let detailViewModel = AttenderDetailViewModel(
            attender: attender
        )
        detailViewModel.isBackPublisher
            .dropFirst()
            .sink { isBack in
                viewModel.showingAttenderId = -1
            }
            .store(in: &detailViewModel.cancellables)
        
        detailViewModel.didUpdate
            .sink { attender in
                if let index = self.viewModel.attenders.firstIndex(where: { $0.id == self.viewModel.showingAttenderId }) {
                    self.viewModel.attenders[index] = attender
                }
            }
            .store(in: &detailViewModel.cancellables)
        
        return AttenderDetailView(viewModel: detailViewModel)
    }
    
    func editView(of attender: AttenderDTO?) -> EditAttenderView {
        let editViewModel = EditAttenderViewModel(
            service: viewModel.service, attender: attender
        )
        editViewModel.isBackPublisher
            .dropFirst()
            .sink { isBack in
                viewModel.isShowEdit = false
            }
            .store(in: &editViewModel.cancellables)
        
        editViewModel.didAdd
            .sink { attender in
                viewModel.loadData()
            }
            .store(in: &editViewModel.cancellables)
        
        return EditAttenderView(viewModel: editViewModel)
    }
}

struct AttenderListView_Previews: PreviewProvider {
    static var previews: some View {
        let service = MockAscendService()
        let viewModel = AttenderListViewModel(service: service)
        return AttenderListView(viewModel: viewModel)
    }
}

class MockAscendService: AscendServiceProtocol {
    func getAttenderList() -> AnyPublisher<[Attender], AscendError> {
        let data = [
            Attender(
                id: 1,
                fullName: "Nguyen Van A",
                email: "a.nguyenvan@gmail.com",
                dob: "1999-12-12",
                avatar: "",
                organization: "Ascend",
                role: "Dev",
                monthsOfExperience: 12,
                isJoinExperienceSection: true
            ),
            Attender(
                id: 1,
                fullName: "Nguyen Van B",
                email: "a.nguyenvan@gmail.com",
                dob: "1999-12-12",
                avatar: "",
                organization: "Ascend",
                role: "QA",
                monthsOfExperience: 12,
                isJoinExperienceSection: true
            )
        ]
        return Just(data)
            .setFailureType(to: AscendError.self)
            .eraseToAnyPublisher()
    }
    
    func create(attender: Attender) -> AnyPublisher<Attender, AscendError> {
        Fail(error: AscendError.generalError(message: ""))
            .eraseToAnyPublisher()
    }
    
    func update(attender: Attender) -> AnyPublisher<Data, AscendError> {
        Fail(error: AscendError.generalError(message: ""))
            .eraseToAnyPublisher()
    }
    
    func delete(attender: Int) -> AnyPublisher<Data, AscendError> {
        Just(Data())
            .setFailureType(to: AscendError.self)
            .eraseToAnyPublisher()
    }
}

struct LoadingView: View {
    let text: String
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .frame(width: 200, height: 100)
                .cornerRadius(8)
            ProgressView(text)
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .foregroundColor(.white)
        }
    }
}

