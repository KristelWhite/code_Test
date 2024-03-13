//
//  MainViewController.swift
//  CODETest
//
//  Created by Кристина Пастухова on 12.03.2024.
//

import UIKit

class MainViewController: UIViewController {
    
    let model: EmployeesListModel = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureModel()
    }
    
    func configureModel() {
        model.didUpdateModel = {
            
        }
    }
}


//        ["Все", "Designers", "Analysts", "Managers", "iOS", "Android", "QA", "Бэк-офис", "Frontend", "HR", "PR", "Backend", "Техподдержка"]
