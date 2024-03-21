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
        filteredByDepartmentEmployees = filterByPosition(employees: sortedEmployees, department: department)
        finalFilteredEmployees = filterByName(employees: filteredByDepartmentEmployees, searchString: searchString)
    }
    
    static func performOptimizedSortingAndFiltering(employees: [Employee], searchString: String?, department: Department, sorting: SortOption) {
        if currentSortBy != sorting {
            currentSortBy = sorting
            sortedEmployees = sortEmployees(employees: employees, sorting: sorting)
        }
        if currentDepartment != department {
            currentDepartment = department
            filteredByDepartmentEmployees = filterByPosition(employees: sortedEmployees, department: department)
        }
        if  currentSearchString != searchString {
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
            return employees.sorted { $0.birthday < $1.birthday }
        }
    }
    
    private static func filterByPosition(employees: [Employee], department: Department) -> [Employee] {
        return employees.filter { $0.department == department }
    }
    
    private static func filterByName(employees: [Employee], searchString: String?) -> [Employee] {
        guard let searchText = searchString, !searchText.isEmpty else {
            return employees
        }
        return employees.filter {
            return $0.firstName.lowercased().hasPrefix(searchText) ||
            $0.lastName.lowercased().hasPrefix(searchText) ||
            $0.userTag.lowercased().hasPrefix(searchText)
        }
    }
}

