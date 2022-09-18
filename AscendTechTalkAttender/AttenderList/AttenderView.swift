//
//  AttenderView.swift
//  AscendTechTalkAttender
//
//  Created by Hoang Chi Quan on 16/09/2022.
//

import SwiftUI

struct AttenderView: View {
    let attender: AttenderDTO
    
    var body: some View {
        HStack {
            Image(uiImage: attender.avatarImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .cornerRadius(30)
            VStack(alignment: .leading) {
                Text(attender.fullName)
                    .font(.title)
                Text("\(attender.organization) \(attender.role) \(attender.id)")
            }
            Spacer()
        }
    }
}

struct AttenderView_Previews: PreviewProvider {
    static var previews: some View {
        AttenderView(
            attender: AttenderDTO(
                data: Attender(
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
            )
        )
    }
}
