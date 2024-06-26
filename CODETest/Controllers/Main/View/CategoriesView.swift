//
//  CategoriesView.swift
//  CODETest
//
//  Created by Кристина Пастухова on 19.03.2024.
//

import UIKit

class CategoriesView: UIView {
    
    var collectionView: UICollectionView!
    var selectedCaregoryLine: UIView = {
        var line = UIView()
        line.backgroundColor = Constant.purpleColor
        return line
    }()
    
    let categories: [Department] = [.all, .design, .analytics, .management, .ios, .android, .qa, .back_office, .frontend, .hr, .pr, .backend, .support]
    var currentCategory: Department
    var selectedCategoryIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    init(frame: CGRect, with сategory: Department) {
        self.currentCategory = сategory
        super.init(frame: frame)
        configureCollectionView()
        setupSelectedCategoryLine()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 100, height: 36)
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: "\(CategoriesCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(CategoriesCollectionViewCell.self)")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        
        
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func setupSelectedCategoryLine(){
        self.addSubview(selectedCaregoryLine)
        selectedCaregoryLine.frame = CGRect(x: 0, y: 36, width: 50, height: 2)
    }
    
    func moveSelectedLine(to indexPath: IndexPath) {
        guard let attributes = collectionView.layoutAttributesForItem(at: indexPath) else { return }
        let convertAttributes = collectionView.convert(attributes.frame, to: collectionView.superview)
        UIView.animate(withDuration: 0.2) {
            self.selectedCaregoryLine.frame.origin.x = convertAttributes.minX
            self.selectedCaregoryLine.frame.size.width = convertAttributes.width
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CategoriesView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CategoriesCollectionViewCell.self)", for: indexPath) as? CategoriesCollectionViewCell
        guard let cell = cell else { return UICollectionViewCell()}
        let category = categories[indexPath.row]
        let isSelected = (category == currentCategory) ? true : false
        cell.configure(with: category, isSelected: isSelected)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CategoriesView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategoryIndexPath = indexPath
        moveSelectedLine(to: indexPath)
        
        currentCategory = categories[indexPath.row]
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoriesCollectionViewCell {
            cell.configure(with: currentCategory, isSelected: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoriesCollectionViewCell {
            cell.configure(with: categories[indexPath.item], isSelected: false)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        moveSelectedLine(to: selectedCategoryIndexPath)
        
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CategoriesView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let category = categories[indexPath.item].tabName
        let font = UIFont.systemFont(ofSize: 15, weight: .medium)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (category as NSString).size(withAttributes: fontAttributes)
        let padding: CGFloat = 24
        return CGSize(width: (size.width) + padding, height: collectionView.frame.height)
    }
}

