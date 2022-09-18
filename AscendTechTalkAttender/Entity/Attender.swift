//
//  Attender.swift
//  AscendTechTalkAttender
//
//  Created by Hoang Chi Quan on 16/09/2022.
//

import Foundation

struct Attender: Codable {
    let id: Int?
    let fullName: String?
    let email: String?
    let dob: String?
    let avatar: String?
    let organization: String?
    let role: String?
    let monthsOfExperience: Int?
    let isJoinExperienceSection: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email
        case dob = "date_of_birth"
        case avatar
        case organization
        case role
        case monthsOfExperience = "months_of_experience"
        case isJoinExperienceSection = "is_join_experience_section"
    }
}
