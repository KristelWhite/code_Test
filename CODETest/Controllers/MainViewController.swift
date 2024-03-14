//
//  MainViewController.swift
//  CODETest
//
//  Created by Кристина Пастухова on 12.03.2024.
//

import UIKit

class MainViewController: UIViewController {

    enum Constant {
        static let horizontalSpace: CGFloat = 16
        static let topSpace: CGFloat = 156
        static let bottomSpace: CGFloat = 34
        static let betweenLines: CGFloat = 4
        static let sizeOfCell: CGFloat = 80
//        static let horisontalInset: CGFloat = 16
//        static let verticalInset: CGFloat = 0
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    let model: EmployeesListModel = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints(for: tableView)
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
        tableView.separatorStyle = .none
    }
    
    func setupConstraints( for tableView: UITableView) {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constant.topSpace), tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:  -Constant.bottomSpace), tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.horizontalSpace), tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.horizontalSpace)])
        // не понятно, посмотреть позже
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = Constant.sizeOfCell + Constant.betweenLines
        return height
    }
}



//        ["Все", "Designers", "Analysts", "Managers", "iOS", "Android", "QA", "Бэк-офис", "Frontend", "HR", "PR", "Backend", "Техподдержка"]
