//
//  SortViewController.swift
//  CODETest
//
//  Created by Кристина Пастухова on 19.03.2024.
//

import UIKit

protocol SortingDelegate: AnyObject {
    func didSelectSorting(with option: SortOption)
}

class SortViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentOption: SortOption
    weak var delegate: SortingDelegate?
    private let sortingOptions: [SortOption] = [.byAlphabet, .byBirthday]
    
    init(with option: SortOption, delegate: SortingDelegate?) {
        self.currentOption = option
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    private func configureTableView() {
        setupTableViewConstraints()
        tableView.register(UINib(nibName: "\(SortTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "\(SortTableViewCell.self)")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
    }
    private func setupTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16), tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)])
    }
}

//MARK: - UITableViewDataSource
extension SortViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortingOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(SortTableViewCell.self)", for: indexPath) as? SortTableViewCell
        guard let cell = cell else { return UITableViewCell() }
        let option = sortingOptions[indexPath.row]
        let isSelected = (option == currentOption) ? true : false
        cell.configure(with: option, isSelected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = sortingOptions[indexPath.row]
        currentOption = option
        delegate?.didSelectSorting(with: option)
        tableView.reloadData()
        dismiss(animated: true)
    }
}

//MARK: - UITableViewDelegate
extension SortViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Int(tableView.frame.width), height: 44))
        
        let label = UILabel()
        label.text = "Сортировка"
        label.textAlignment = .center
        label.textColor = UIColor(red: 5/255, green: 5/255, blue: 16/255, alpha: 1)
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: view.topAnchor, constant: 4), label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16), label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8), label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)])
        return view
    }
}
