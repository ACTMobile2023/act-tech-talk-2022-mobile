//
//  AttenderDetailView.swift
//  AscendTechTalkAttender
//
//  Created by Hoang Chi Quan on 17/09/2022.
//

import SwiftUI

struct AttenderDetailView: View {
    @ObservedObject var viewModel: AttenderDetailViewModel
    
    var body: some View {
        ZStack {
            Color.white
            ScrollView {
                ZStack {
                    GeometryReader { geometry in
                        VStack {
                            Image(uiImage: viewModel.attender.avatarImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.width)
                                .clipped()
                            
                            Text(viewModel.attender.fullName)
                                .font(.title)
                            
                            Text("ID: \(viewModel.attender.id)")
                            
                            Text("DOB: \(viewModel.attender.dobDisplay)")
                            
                            Text("Company: \(viewModel.attender.organization)")
                            
                            Text("Role: \(viewModel.attender.role)")
                            
                            Text("Email: \(viewModel.attender.email)")
                            
                            Text("Experience: \(viewModel.attender.monthsOfExperience) month(s)")
                            
                            Text("Joined experience section: \(viewModel.attender.isJoinExperienceSection ? "Yes" : "No")")
                        }
                    }
                    
                    HStack {
                        Button {
                            viewModel.isBack = true
                        } label: {
                            Image("ic_back")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        
                        Spacer()
                        
                        NavigationLink(isActive: $viewModel.isEdit) {
                            editView(of: viewModel.attender)
                        } label: {
                            Button {
                                viewModel.isEdit = true
                            } label: {
                                Image("ic_edit")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                        }
                    }
                    .frame(height: 128)
                    .padding(.horizontal, 16)
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
    }
    
    func editView(of attender: AttenderDTO) -> EditAttenderView {
        let detailViewModel = EditAttenderViewModel(
            service: AscendService(), attender: attender
        )
        detailViewModel.isBackPublisher
            .dropFirst()
            .sink { isBack in
                viewModel.isEdit = false
            }
            .store(in: &detailViewModel.cancellables)
        
        detailViewModel.didUpdate
            .receive(on: RunLoop.main)
            .sink { attender in
                self.viewModel.attender = attender
                self.viewModel.didUpdate.send(attender)
            }
            .store(in: &detailViewModel.cancellables)
        
        return EditAttenderView(viewModel: detailViewModel)
    }
}

struct AttenderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let attender = Attender(
            id: 1,
            fullName: "Nguyen Van A",
            email: "a.nguyenvan@gmail.com",
            dob: "1999-12-12",
            avatar: "",
            organization: "Ascend",
            role: "Dev",
            monthsOfExperience: 12,
            isJoinExperienceSection: true
        )

        let dto = AttenderDTO(data: attender)
        let viewModel = AttenderDetailViewModel(attender: dto)
        return AttenderDetailView(viewModel: viewModel)
    }
}
