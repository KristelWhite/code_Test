//
//  CustomSearchController.swift
//  CODETest
//
//  Created by Кристина Пастухова on 15.03.2024.
//

import UIKit

import UIKit

class CustomSearchController: UISearchController, UISearchBarDelegate {
    // Инициализатор, который позволяет настраивать search controller при его создании
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        setupSearchBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSearchBar() {
        // Настройка внешнего вида и поведения searchBar
//        obscuresBackgroundDuringPresentation = false
        searchBar.delegate = self
        searchBar.placeholder = "Введите имя, тег, почту..."
        searchBar.searchBarStyle = .prominent
        // Дополнительные настройки (цвет, фон и т.д.)
        //настроить кнопку фильтра
    }
    
    func configureApperance(on view: UIView){
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // Методы делегата UISearchBar, если нужно обрабатывать события searchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Логика поиска
    }
}

        
        
