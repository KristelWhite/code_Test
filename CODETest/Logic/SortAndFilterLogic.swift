//
//  SortAndFilterLogic.swift
//  CODETest
//
//  Created by Кристина Пастухова on 21.03.2024.
//

import Foundation

enum SortOption: String {
    case byAlphabet = "По алфавиту"
    case byBirthday = "По дню рождения"
}

class SortAndFilterLogic {
    static var currentSearchString: String? = nil
    static var currentDepartment: Department = .all
    static var currentSortBy: SortOption = .byAlphabet
    static var currentEmployeesHash: Int?
    
    static var sortedEmployees: [Employee] = []
    static var filteredByDepartmentEmployees: [Employee] = []
    static var finalFilteredEmployees: [Employee] = []
    
    static func updateIfNeeded(employees: [Employee], searchString: String?, department: Department, sorting: SortOption) {
        let newHash = employees.hashValue
        if newHash != currentEmployeesHash {
            currentEmployeesHash = newHash
            return performFullSortingAndFiltering(employees: employees, searchString: searchString, department: department, sorting: sorting)
        } else {
            return performOptimizedSortingAndFiltering(employees: employees, searchString: searchString, department: department, sorting: sorting)
        }
    }
    
    static func performFullSortingAndFiltering(employees: [Employee], searchString: String?, department: Department, sorting: SortOption) {
        sortedEmployees = sortEmployees(employees: employees, sorting: sorting)
        filteredByDepartmentEmployees = filterByDepartment(employees: sortedEmployees, department: department)
        finalFilteredEmployees = filterByName(employees: filteredByDepartmentEmployees, searchString: searchString)
    }
    
    static func performOptimizedSortingAndFiltering(employees: [Employee], searchString: String?, department: Department, sorting: SortOption) {
        if currentSortBy != sorting {
            currentSortBy = sorting
            sortedEmployees = sortEmployees(employees: employees, sorting: sorting)
            
            currentDepartment = department
            filteredByDepartmentEmployees = filterByDepartment(employees: sortedEmployees, department: department)
            
            currentSearchString = searchString
            finalFilteredEmployees = filterByName(employees: filteredByDepartmentEmployees, searchString: searchString)
        } else if currentDepartment != department {
            currentDepartment = department
            filteredByDepartmentEmployees = filterByDepartment(employees: sortedEmployees, department: department)
            
            currentSearchString = searchString
            finalFilteredEmployees = filterByName(employees: filteredByDepartmentEmployees, searchString: searchString)
        } else if  currentSearchString != searchString {
            currentSearchString = searchString
            finalFilteredEmployees = filterByName(employees: filteredByDepartmentEmployees, searchString: searchString)
        }
    }
    
    private static func sortEmployees(employees: [Employee], sorting: SortOption) -> [Employee] {
        switch sorting {
        case .byAlphabet:
            return employees.sorted {
                ($0.firstName + $0.lastName) < ($1.firstName + $1.lastName)
            }
        case .byBirthday:
            return employees.sorted {
                let calendar = Calendar.current
                let firstDayMonth = calendar.dateComponents([.month, .day], from: $0.birthday)
                let secondDayMonth = calendar.dateComponents([.month, .day], from: $1.birthday)

                if firstDayMonth.month! == secondDayMonth.month! {
                    return firstDayMonth.day! < secondDayMonth.day!
                }
                return firstDayMonth.month! < secondDayMonth.month!
            }
        }
    }
    
    private static func filterByDepartment(employees: [Employee], department: Department) -> [Employee] {
        if department == .all {
            return employees
        }
        return employees.filter { $0.department == department }
    }
    
    private static func filterByName(employees: [Employee], searchString: String?) -> [Employee] {
        guard let searchText = searchString?.lowercased(), !searchText.isEmpty else {
            return employees
        }
        return employees.filter {
            return $0.firstName.lowercased().hasPrefix(searchText) ||
            $0.lastName.lowercased().hasPrefix(searchText) ||
            $0.userTag.lowercased().hasPrefix(searchText)
        }
    }
    
    static func findFirstIndexCurrentDate(inEmployeesList list: [Employee]) -> Int {
        let now = Date()
        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.month, .day], from: now)
        let currentDate = calendar.date(from: DateComponents(year: 2000, month: currentComponents.month, day: currentComponents.day))!
        
        var left = 0
        var right = list.count - 1
        var result: Int? = nil
        
        while left <= right {
            let mid = left + (right - left) / 2
            let midComponents = calendar.dateComponents([.month, .day], from: list[mid].birthday)
            let midDate = calendar.date(from: DateComponents(year: 2000, month: midComponents.month, day: midComponents.day))!
            
            if midDate < currentDate {
                left = mid + 1
            } else if midDate > currentDate {
                right = mid - 1
            } else {
                result = mid
                right = mid - 1
            }
        }
        
        return result ?? left
    }
    
    static func nextYear(of date: Date) -> Int {
        let year = Calendar.current.component(.year , from: date)
        return Int(year) + 1
    }
}

