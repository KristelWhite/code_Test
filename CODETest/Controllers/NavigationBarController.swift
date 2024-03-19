//
//  NavigationBarController.swift
//  CODETest
//
//  Created by Кристина Пастухова on 13.03.2024.
//

import UIKit
import XLPagerTabStrip

protocol NavigationBarDelegate: AnyObject {
    func didChangeSearchText(_ searchText: String)
    func didSelectCategory(_ category: String)
}

class NavigationBarController: NSObject {
    
    weak var delegate: NavigationBarDelegate?
    
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    var buttonBarView: ButtonBarView!

    init(delegate: NavigationBarDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    private func setupSearchController(onView view: UIView) {
        searchController.searchResultsUpdater = self
        
    
        
    }
    
    func setupButtonBar(onView view: UIView, belowView targetView: UIView) {
        // Создание и настройка Button Bar
        buttonBarView = ButtonBarView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
        // Настройте стиль Button Bar здесь
        view.addSubview(buttonBarView)
        
        // Задать Auto Layout или фреймы для buttonBarView здесь
        buttonBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: targetView.frame.height),
            buttonBarView.leftAnchor.constraint(equalTo: view.leftAnchor),
            buttonBarView.rightAnchor.constraint(equalTo: view.rightAnchor),
            buttonBarView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func selectCategory(atIndex index: Int) {
        // Вызывается когда пользователь выбирает категорию в Button Bar
        // Уведомить делегата о выборе
        let category = "Категория \(index)" // Настройте это в соответствии с вашими категориями
        delegate?.didSelectCategory(category)
    }
}

// Расширение для обновления результатов поиска
extension NavigationBarController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            delegate?.didChangeSearchText(searchText)
        }
    }
}
