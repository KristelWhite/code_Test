//
//  DetailViewController.swift
//  CODETest
//
//  Created by Кристина Пастухова on 13.03.2024.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var name: String = ""
    var position: String = ""
    var tag: String = ""
    var bday: String = ""
    var age: String = ""
    var phone: String = ""
    var image: UIImage = UIImage(named: "goose") ?? UIImage()
    
    var headerView: DetailHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHeader()
        configureTableView()
        configureBackButton()
    }
    
    
    private func configureBackButton(){
        let image = UIImage(named: "back.button")?.withRenderingMode(.alwaysOriginal)
        let backImage = image?.withTintColor(Constant.blackColor)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonPressed))
    }
    
    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    private func configureHeader(){
        headerView = DetailHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 280), profileImage: image, name: name, tag: tag, jobTitle: position)
        view.addSubview(headerView)
        setupConstraints(for: headerView)
    }
    
    private func setupConstraints(for headerView: DetailHeaderView) {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([headerView.topAnchor.constraint(equalTo: view.topAnchor), headerView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 280), headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor), headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }
    
    private func configureTableView(){
        setupConstraints(for: tableView)
        tableView.register(UINib(nibName: "\(InfoTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "\(InfoTableViewCell.self)")
        tableView.register(UINib(nibName: "\(PhoneTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "\(PhoneTableViewCell.self)")
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: CGFloat.leastNonzeroMagnitude))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: CGFloat.leastNonzeroMagnitude))
    }
    
    private func setupConstraints( for tableView: UITableView) {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16), tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)])
    }

}

//MARK: - CellDelegate
extension DetailViewController: CellDelegate {
    func didTapButtonInCell() {
        showCallConfirmation()
    }
    
    func showCallConfirmation() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let callAction = UIAlertAction(title: "\(phone)", style: .default) { (action) in
            self.makeCall(to: self.phone)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        callAction.setValue(Constant.blackColor, forKey: "titleTextColor")
        cancelAction.setValue(Constant.blackColor, forKey: "titleTextColor")
        
        actionSheet.addAction(callAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    func makeCall(to phone: String) {
        if let phoneURL = URL(string: "tel://\(phone)") {
            if UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(InfoTableViewCell.self)", for: indexPath) as? InfoTableViewCell
            guard let cell = cell else { break }
            cell.configure(with: bday, years: age)
            
            return cell
        case 1 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(PhoneTableViewCell.self)", for: indexPath) as? PhoneTableViewCell
            guard let cell = cell else { break }
            cell.delegate = self
            cell.configure(with: phone)
            return cell
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
}

//MARK: - UITableViewDelegate
extension DetailViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        66
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
    }
}
