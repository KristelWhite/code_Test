//
//  MainViewController.swift
//  CODETest
//
//  Created by Кристина Пастухова on 12.03.2024.
//

import UIKit

class MainViewController: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!

    enum Constant {
        static let horizontalSpace: CGFloat = 16
        static let topSpace: CGFloat = 156
        static let bottomSpace: CGFloat = 34
        static let betweenLines: CGFloat = 4
        static let sizeOfCell: CGFloat = 80
//        static let horisontalInset: CGFloat = 16
//        static let verticalInset: CGFloat = 0
    }
    
    let model: EmployeesListModel = .init()
   
    var sorting : SortOption = .byAlphabet
    var selectedCategory: Department = .all
    var currentSearch: String? = nil
    
 
    let searchController = UISearchController(searchResultsController: nil)
    var categoriesView: CategoriesView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchBar()
        setupCategoriesView()
        
        configureTableView()
        configureModel()
        model.fetchData()
    }
    
    func setupSearchBar() {
        
        // привести в норм вид или вынести
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        
        self.searchController.obscuresBackgroundDuringPresentation = false
        
        self.searchController.searchBar.placeholder = "Введите имя, тег, почту..."
    
        self.searchController.searchBar.searchBarStyle = .default
        
        self.navigationItem.titleView = searchController.searchBar
        
        self.definesPresentationContext = true
        self.searchController.searchBar.searchTextField.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 248/255, alpha: 1)
        self.searchController.searchBar.showsBookmarkButton = true
        self.searchController.searchBar.setImage(UIImage(named: "filter"), for: .bookmark, state: .normal)
        self.searchController.searchBar.setImage(UIImage(named: "clear"), for: .clear, state: .normal)
        
        
        self.searchController.searchBar.setImage(UIImage(named: "search"), for: .search, state: .normal)
        // mode для изменения цвета
        self.searchController.searchBar.image(for: .search, state: .normal)?.withRenderingMode(.alwaysTemplate)
        
        
        // Swift 5 и более поздние версии
        //        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
        //            // Задаем радиус скругления
        //            textField.layer.cornerRadius = 16.0
        //            // Для применения изменений и избежания обрезания
        //            textField.clipsToBounds = true
        ////            textField.backgroundColor = UIColor.lightGray
        //        }
        
        self.searchController.searchBar.searchTextField.layer.cornerRadius = 16
        self.searchController.searchBar.searchTextField.clipsToBounds = true
        self.searchController.searchBar.tintColor = UIColor(red: 101/255, green: 52/255, blue: 255/255, alpha: 1)
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
    
    
    @objc private func dismissSortingVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureModel() {
        model.didUpdateModel = { [weak self] in
            self?.updateDataAndView()
        }
    }
    
    func updateDataAndView() {
        SortAndFilterLogic.updateIfNeeded(employees: model.employees, searchString: currentSearch, department: selectedCategory, sorting: sorting)
        model.filteredItems = SortAndFilterLogic.finalFilteredEmployees
        
        tableView.reloadData()
        }
    
    private func configureTableView() {
        setupConstraints(for: tableView)
        
        tableView.register(UINib(nibName: "\(EmployeeTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "\(EmployeeTableViewCell.self)")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    func setupConstraints( for tableView: UITableView) {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constant.topSpace), tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:  -Constant.bottomSpace), tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.horizontalSpace), tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.horizontalSpace)])
        // может настроить content Insets ?
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = model.filteredItems.count
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
        let employee = model.filteredItems[indexPath.row]
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

extension MainViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        currentSearch = searchController.searchBar.text
        updateDataAndView()
    }
    
}
