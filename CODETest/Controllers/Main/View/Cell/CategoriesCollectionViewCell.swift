//
//  CategoriesCollectionViewCell.swift
//  CODETest
//
//  Created by Кристина Пастухова on 19.03.2024.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    var category: Department?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(red: 151/255, green: 151/255, blue: 155/255, alpha: 1)
        titleLabel.font = .systemFont(ofSize: 15, weight: .medium)
    }
    
    func configure(with category: Department, isSelected: Bool) {
        self.category = category
        titleLabel.text = category.tabName
//            contentView.backgroundColor = isSelected ? .blue : .clear
        titleLabel.font = isSelected ? .boldSystemFont(ofSize: 15) : .systemFont(ofSize: 15, weight: .medium)
        }
    
    

}
