//
//  MainViewController.swift
//  CODETest
//
//  Created by Кристина Пастухова on 12.03.2024.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let model: EmployeesListModel = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureModel()
        model.fetchData()
    }
    
    func configureModel() {
        model.didUpdateModel = {
            self.tableView.reloadData()
        }
    }
    private func configureAppearance() {
//        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UINib(nibName: "\(EmployeeTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "\(EmployeeTableViewCell.self)")
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(EmployeeTableViewCell.self)") as? EmployeeTableViewCell
        guard let cell = cell else { return UITableViewCell()}
        let employee = model.employees[indexPath.row]
        cell.configure(with: employee)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {

}



//        ["Все", "Designers", "Analysts", "Managers", "iOS", "Android", "QA", "Бэк-офис", "Frontend", "HR", "PR", "Backend", "Техподдержка"]
