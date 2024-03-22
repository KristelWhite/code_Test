//
//  MainViewController.swift
//  CODETest
//
//  Created by Кристина Пастухова on 12.03.2024.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    enum ConstantSpace {
        static let horizontalSpace: CGFloat = 16
        static let topSpace: CGFloat = 16
        static let bottomSpace: CGFloat = 34
        static let betweenLines: CGFloat = 4
        static let sizeOfCell: CGFloat = 80
    }
    
    let model: EmployeesListModel = .init()
   
    var sorting : SortOption = .byAlphabet
    var selectedCategory: Department = .all
    var currentSearch: String? = nil
    
    let searchController = UISearchController(searchResultsController: nil)
    var categoriesView: CategoriesView!
    var separatorLine: UIView = {
        var line = UIView()
        line.backgroundColor = Constant.lightGreyColor2
        return line
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupCategoriesView()
        setupRefreshControl()
        setupSeparator()
        
        configureTableView()
        configureModel()
        model.fetchData()
    }
    
    
    func setupSeparator() {
        view.addSubview(separatorLine)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([separatorLine.heightAnchor.constraint(equalToConstant: 0.33), separatorLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor), separatorLine.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            separatorLine.topAnchor.constraint(equalTo: categoriesView.bottomAnchor) ])
    }
                                     
    func setupRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshPeopleList), for: .valueChanged)
    }
    @objc func refreshPeopleList() {
        model.fetchData()
    }
    
    func setupSearchBar() {
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Введите имя, тег, почту...",attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .medium), .foregroundColor: Constant.lightGreyColor2])
        self.searchController.searchBar.searchBarStyle = .default
        self.navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = true
        self.searchController.searchBar.searchTextField.backgroundColor = Constant.lightGreyColor3
        self.searchController.searchBar.showsBookmarkButton = true
        
        var image = UIImage(named: "filter")?.withTintColor(Constant.lightGreyColor2)
        self.searchController.searchBar.setImage(image, for: .bookmark, state: .normal)
        image = UIImage(named: "clear")?.withTintColor(Constant.lightGreyColor2)
        self.searchController.searchBar.setImage(image, for: .clear, state: .normal)
        image = UIImage(named: "search")?.withTintColor(Constant.lightGreyColor2)
        self.searchController.searchBar.setImage(image, for: .search, state: .normal)
        self.searchController.searchBar.image(for: .search, state: .normal)?.withRenderingMode(.alwaysTemplate)
        
        self.searchController.searchBar.searchTextField.layer.cornerRadius = 16
        self.searchController.searchBar.searchTextField.clipsToBounds = true
        self.searchController.searchBar.tintColor = Constant.purpleColor
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let vc = SortViewController(with: sorting, delegate: self)

        if #available(iOS 15.0, *) {
            vc.modalPresentationStyle = .pageSheet
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 24
            }
        } else {
            vc.modalPresentationStyle = .automatic
        }
        self.navigationController?.present(vc, animated: true)
    }
    
    
    func configureModel() {
        model.didUpdateModel = { [weak self] in
            self?.updateDataAndView()
            self?.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func updateDataAndView() {
        SortAndFilterLogic.updateIfNeeded(employees: model.employees, searchString: currentSearch, department: selectedCategory, sorting: sorting)
        model.filteredItems = Array(repeating: [Employee](), count: 2)
        let filteredEmployees = SortAndFilterLogic.finalFilteredEmployees
        if sorting == .byBirthday {
            let index = SortAndFilterLogic.findFirstIndexCurrentDate(inEmployeesList: filteredEmployees)
            model.filteredItems[0].append(contentsOf: Array(filteredEmployees[index...]))
            model.filteredItems[1].append(contentsOf: Array(filteredEmployees[0..<index]))
        } else {
            model.filteredItems[0].append(contentsOf: filteredEmployees)
        }
        
        tableView.reloadData()
        }
    
    
    private func configureTableView() {
        setupConstraints(for: tableView)
        
        tableView.register(UINib(nibName: "\(EmployeeTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "\(EmployeeTableViewCell.self)")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    func setupConstraints( for tableView: UITableView) {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: categoriesView.bottomAnchor,constant: ConstantSpace.topSpace), tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:  -ConstantSpace.bottomSpace), tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConstantSpace.horizontalSpace), tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ConstantSpace.horizontalSpace)])
    }
    
    private func setupCategoriesView() {
        categoriesView = CategoriesView(frame: .zero ,with: selectedCategory)
        categoriesView.collectionView.dataSource = self
        categoriesView.collectionView.delegate = self
        view.addSubview(categoriesView)
        
        categoriesView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoriesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            categoriesView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesView.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
   
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesView.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return categoriesView.collectionView(collectionView, cellForItemAt: indexPath)
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        selectedCategory = categoriesView.categories[indexPath.item]
        updateDataAndView()
        categoriesView.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        categoriesView.collectionView(collectionView, didDeselectItemAt: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        categoriesView.scrollViewDidScroll(scrollView)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        categoriesView.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
    }
}


// MARK: - SortDelegate
extension MainViewController: SortingDelegate {
    func didSelectSorting(with option: SortOption) {
        self.sorting = option
        model.fetchData()
        updateFilterButtonCollor()
    }
    
    func updateFilterButtonCollor(){
        let image = UIImage(named: "filter")
        var newImage : UIImage?
        switch sorting {
        case .byAlphabet :
            newImage = image?.withTintColor(UIColor(red: 195/255, green: 195/255, blue: 198/255, alpha: 1))
        case .byBirthday :
            newImage = image?.withTintColor(UIColor(red: 101/255, green: 52/255, blue: 255/255, alpha: 1))
        }

        self.searchController.searchBar.setImage(newImage, for: .bookmark, state: .normal)
        
    }
    
    
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        model.filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = model.filteredItems[section].count
        tableView.backgroundView = ((count == 0) ? makeEmptyStateView() : nil)
        return count
    }
    
    func makeEmptyStateView() -> UIView {
        let emptyStateView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        
        let imageView = UIImageView(image: UIImage(named: "emptyStateImage"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.addSubview(imageView)
        

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor, constant: 64),
            imageView.widthAnchor.constraint(equalTo: emptyStateView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 118/343)
        ])
        
        return emptyStateView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(EmployeeTableViewCell.self)") as? EmployeeTableViewCell
        guard let cell = cell else { return UITableViewCell()}
        let employee = model.filteredItems[indexPath.section][indexPath.row]
        cell.configure(with: employee, sorting: sorting)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        if let cell = tableView.cellForRow(at: indexPath) as? EmployeeTableViewCell {
            vc.name = cell.nameLabel.text ?? ""
            vc.position = cell.positionLabel.text ?? ""
            vc.tag = cell.tagLabel.text ?? ""
            vc.image = cell.avatarImageView.image ?? UIImage(named: "goose") ?? UIImage()
        }
        let employee = model.filteredItems[indexPath.section][indexPath.row]
        vc.bday = employee.fullDate()
        vc.age = employee.calculateAge()
        vc.phone = employee.formatedPhone()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = ConstantSpace.sizeOfCell + ConstantSpace.betweenLines
        return height
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if sorting == .byBirthday, section == 1 {
            let headerView = HeaderOfYear(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.sectionHeaderHeight))
            
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if sorting == .byBirthday, section == 1 {
            return 70
        }
        return 0
    }
}

extension MainViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        currentSearch = searchController.searchBar.text
        updateDataAndView()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let image = UIImage(named: "search")?.withTintColor(Constant.blackColor)
        self.searchController.searchBar.setImage(image, for: .search, state: .normal)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let image = UIImage(named: "search")?.withTintColor(Constant.lightGreyColor2)
        self.searchController.searchBar.setImage(image, for: .search, state: .normal)
    }
}
