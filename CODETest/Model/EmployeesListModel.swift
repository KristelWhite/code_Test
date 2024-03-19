//
//  EmployeesListModel.swift
//  CODETest
//
//  Created by Кристина Пастухова on 13.03.2024.
//

import Foundation

class EmployeesListModel {
    
    var didUpdateModel : (()->Void)?
    
    let service : Networking = .init()
    var employees: [Employee] = []
    var sortedItems : [Employee] = []
    var filteredItems: [Employee] = []
    
    func fetchData() {
        service.loadData(isSuccess: true) { [weak self] result in
            switch result {
            case .success(let success):
                self?.employees = success.items
                self?.didUpdateModel?()
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
