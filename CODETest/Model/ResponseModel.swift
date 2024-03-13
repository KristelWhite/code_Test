//
//  ResponseModel.swift
//  CODETest
//
//  Created by Кристина Пастухова on 12.03.2024.
//

import Foundation

enum Department: String, Codable {
    case android, ios, design, management, qa, back_office, frontend, hr, pr, backend, support, analytics
    
    var tabName: String {
        switch self {
        case .android: return "Android"
        case .ios: return "iOS"
        case .design: return "Дизайн"
        case .management: return "Менеджмент"
        case .qa: return "QA"
        case .back_office: return "Бэк-офис"
        case .frontend: return "Frontend"
        case .hr: return "HR"
        case .pr: return "PR"
        case .backend: return "Backend"
        case .support: return "Техподдержка"
        case .analytics: return "Аналитика"
        }
    }
}

struct Employee: Codable {
    let id: String
    let avatarUrl: String
    let firstName: String
    let lastName: String
    let userTag: String
    let department: Department
    let position: String
    let birthday: Date
    let phone: String
}


struct ResponseBody: Codable {
    let list: [Employee]
}


extension ResponseBody {
    static func decode(from jsonData: Data) throws -> ResponseBody {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return try decoder.decode(ResponseBody.self, from: jsonData)
    }
}

