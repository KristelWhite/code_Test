//
//  ResponseModel.swift
//  CODETest
//
//  Created by Кристина Пастухова on 12.03.2024.
//

import Foundation

enum Department: String, Codable, Equatable {
    case android, ios, design, management, qa, back_office, frontend, hr, pr, backend, support, analytics, all
//    ["Все", "Designers", "Analysts", "Managers", "iOS", "Android", "QA", "Бэк-офис", "Frontend", "HR", "PR", "Backend", "Техподдержка"
    var tabName: String {
        switch self {
        case .all: return "Все"
        case .android: return "Android"
        case .ios: return "iOS"
        case .design: return "Designers"
        case .management: return "Managers"
        case .qa: return "QA"
        case .back_office: return "Бэк-офис"
        case .frontend: return "Frontend"
        case .hr: return "HR"
        case .pr: return "PR"
        case .backend: return "Backend"
        case .support: return "Техподдержка"
        case .analytics: return "Analysts"
        }
    }
}

struct Employee: Codable, Hashable {
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

extension Employee {
    func dataOnScreen() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMM"
        var dateString = formatter.string(from: self.birthday)
        //проверяем чтобы было точное представление даты
        let parts = dateString.split(separator: " ")
        if parts.count == 2, let month = parts.last, month.count > 3 {
            let correctMonth = String(month.prefix(3))
            dateString = "\(parts.first!) \(correctMonth)"
        }
        return dateString
    }
    
    func fullDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM yyyy"
        let formattedDate = dateFormatter.string(from: self.birthday)
        return formattedDate
    }
    
    func calculateAge() -> String {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: self.birthday, to: now)
        guard let age = ageComponents.year else { return "Дата рождения не определена" }
        let word = аgeWord(for: age)
        return "\(age) \(word)"
    }

    private func аgeWord(for age: Int) -> String {
        let lastDigit = age % 10
        let lastTwoDigits = age % 100
        
        if lastTwoDigits >= 11, lastTwoDigits <= 14 {
            return "лет"
        }
        switch lastDigit {
        case 1:
            return "год"
        case 2, 3, 4:
            return "года"
        default:
            return "лет"
        }
    }
    
    func formatedPhone() -> String {
        let parts = self.phone.split(separator: "-").map(String.init)
        guard parts.count == 3 else {
            return "Неверный формат"
        }
        let part1 = parts[0]
        let part2 = parts[1]
        let part3 = parts[2]
        guard part3.count == 4 else {
            return "Неверный формат"
        }
        let end1 = part3.prefix(2)
        let end2 = part3.suffix(2)

        let formatNumber = "+7 (\(part1)) \(part2) \(end1) \(end2)"
        return formatNumber
    }
    
}


struct ResponseBody: Codable {
    let items: [Employee]
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

