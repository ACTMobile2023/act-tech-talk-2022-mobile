//
//  AttenderDTO.swift
//  AscendTechTalkAttender
//
//  Created by Hoang Chi Quan on 16/09/2022.
//

import Foundation
import UIKit

struct AttenderDTO: Identifiable {
    private let dateFormatter = DateFormatter()
    
    let id: Int
    let fullName: String
    let email: String
    let dob: Date
    let avatar: String
    let organization: String
    let role: String
    let monthsOfExperience: Int
    let isJoinExperienceSection: Bool
    
    var avatarImage: UIImage {
        let defaultImage = UIImage(named: "default-profile-avatar") ?? UIImage()
        guard let base64String = self.avatar.components(separatedBy: "base64,").last,
              let imageData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) else {
            return defaultImage
        }
        return UIImage(data: imageData) ?? defaultImage
    }
    
    var dobDisplay: String {
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: dob)
    }
    
    init(data: Attender) {
        self.id = data.id ?? -1
        self.fullName = data.fullName ?? "No name"
        self.email = data.email ?? "No email"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dob = dateFormatter.date(from: data.dob ?? "") ?? Date(timeIntervalSinceNow: -86400)
        self.avatar = data.avatar ?? ""
        self.organization = data.organization ?? ""
        self.role = data.role ?? ""
        self.monthsOfExperience = data.monthsOfExperience ?? 0
        self.isJoinExperienceSection = data.isJoinExperienceSection ?? false
    }
}

class AttenderBinding: ObservableObject {
    private let dateFormatter = DateFormatter()

    var id: Int?
    
    @Published
    var avatar: UIImage
    
    @Published
    var fullName: String
    
    @Published
    var dob: Date
    
    @Published
    var organization: String
    
    @Published
    var role: String
    
    @Published
    var email: String
    
    @Published
    var monthsOfExperience: String
    
    @Published
    var isJoinExperienceSection: Bool
    
    init() {
        self.avatar = UIImage(named: "default-profile-avatar") ?? UIImage()
        self.fullName = ""
        self.email = ""
        self.dob = Date(timeIntervalSinceNow: -86400)
        self.organization = ""
        self.role = ""
        self.monthsOfExperience = ""
        self.isJoinExperienceSection = false
    }
    
    init(data: AttenderDTO) {
        self.id = data.id
        self.fullName = data.fullName
        self.email = data.email
        self.dob = data.dob
        self.avatar = data.avatarImage
        self.organization = data.organization
        self.role = data.role
        self.monthsOfExperience = "\(data.monthsOfExperience)"
        self.isJoinExperienceSection = data.isJoinExperienceSection
    }
    
    func dataToSubmit() -> Attender {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return Attender(
            id: id,
            fullName: fullName,
            email: email,
            dob: dateFormatter.string(from: dob),
            avatar: avatar.resize(toWidth: 400, toHeight: 400)?.jpegData(compressionQuality: 0.5)?.base64EncodedString(),
            organization: organization,
            role: role,
            monthsOfExperience: Int(monthsOfExperience),
            isJoinExperienceSection: isJoinExperienceSection
        )
    }
}

extension UIImage {
    func resize(toWidth tw: CGFloat = 0, toHeight th: CGFloat = 0) -> UIImage? {
        var w: CGFloat?
        var h: CGFloat?
        
        if 0 < tw {
            h = size.height * tw / size.width
        } else if 0 < th {
            w = size.width * th / size.height
        }
        
        let g: UIImage?
        let t: CGRect = CGRect(x: 0, y: 0, width: w ?? tw, height: h ?? th)
        UIGraphicsBeginImageContextWithOptions(t.size, false, UIScreen.main.scale)
        draw(in: t, blendMode: .normal, alpha: 1)
        g = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return g
    }
}

