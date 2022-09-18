//
//  EditAttenderView.swift
//  AscendTechTalkAttender
//
//  Created by Hoang Chi Quan on 17/09/2022.
//

import SwiftUI

struct EditAttenderView: View {
    @ObservedObject var viewModel: EditAttenderViewModel
    
    @FocusState var isTextFieldFocus: Bool
    
    @State var showsDatePicker = false
    @State var showImageCapture = false

    let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateStyle = .medium
            return df
        }()
    
    var body: some View {
        ZStack {
            Color.white
            ScrollView {
                ZStack {
                    LazyVStack {
                        ZStack {
                            Image(uiImage: viewModel.attender.avatar)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 160, height: 160)
                                .cornerRadius(80)
                            
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Button {
                                        self.isTextFieldFocus = false
                                        self.showImageCapture = true
                                    } label: {
                                        Image("ic_capture")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .background(
                                                Color.white
                                                    .cornerRadius(15)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(.white, lineWidth: 5)
                                            )
                                            .padding(12)
                                    }
                                }
                            }
                            .frame(width: 160, height: 160)
                        }
                        
                        editView(title: "Full name", text: $viewModel.attender.fullName)
                        
                        dobView
                        
                        editView(title: "Company/School", text: $viewModel.attender.organization)
                        
                        editView(title: "Role", text: $viewModel.attender.role)
                        
                        editView(title: "Email", text: $viewModel.attender.email, keyboardType: .emailAddress)
                        
                        editView(title: "Month of experience", text: $viewModel.attender.monthsOfExperience, keyboardType: .numberPad)
                        
                        Toggle("Joined experience section", isOn: $viewModel.attender.isJoinExperienceSection)
                            .padding(.vertical, 8)
                            .font(Font.system(size: 16, weight: .bold))
                        
                        Button("Submit") {
                            self.isTextFieldFocus = false
                            self.viewModel.submitProfile()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.horizontal, 16)
                }
            }
            
            VStack {
                HStack {
                    Button {
                        viewModel.isBack = true
                    } label: {
                        Image("ic_back")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    Spacer()
                }
                .frame(height: 64)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            if viewModel.isLoading {
                LoadingView(text: "Submitting...")
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showImageCapture) {
            #if targetEnvironment(simulator)
            let sourceType = UIImagePickerController.SourceType.photoLibrary
            #else
            let sourceType = UIImagePickerController.SourceType.camera
            #endif
            ImagePicker(sourceType: sourceType, selectedImage: $viewModel.attender.avatar)
        }
        .alert(isPresented: $viewModel.isShowAlert) {
            Alert(
                title: Text("Lỗi"),
                message: Text(viewModel.errorMessage)
            )
        }
    }
    
    func editView(title: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(Font.system(size: 16, weight: .bold))
            TextField(title, text: text)
                .padding(8)
                .border(.gray, width: 1)
                .cornerRadius(4)
                .keyboardType(keyboardType)
                .focused($isTextFieldFocus)
                .onChange(of: isTextFieldFocus) { newValue in
                    if isTextFieldFocus {
                        self.showsDatePicker = false
                    }
                }
        }
    }
    
    var dobView: some View {
        VStack(alignment: .leading) {
            Text("Date of birth")
                .font(Font.system(size: 16, weight: .bold))
            
            Text(dateFormatter.string(from: viewModel.attender.dob))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
                .border(.gray, width: 1)
                .cornerRadius(4)
                .onTapGesture {
                    self.isTextFieldFocus = false
                    self.showsDatePicker.toggle()
                }
            
            if showsDatePicker {
                DatePicker(
                    "",
                    selection: $viewModel.attender.dob,
                    in: ...Date(timeIntervalSinceNow: -86400),
                    displayedComponents: .date
                )
                    .datePickerStyle(.graphical)
            }
        }
    }
}

struct EditAttenderView_Previews: PreviewProvider {
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
        let viewModel = EditAttenderViewModel(service: MockAscendService(), attender: dto)
        return EditAttenderView(viewModel: viewModel)
    }
}
