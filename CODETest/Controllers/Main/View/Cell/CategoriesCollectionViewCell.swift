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
        titleLabel.textColor = Constant.lightGreyColor
        titleLabel.font = .systemFont(ofSize: 15, weight: .medium)
    }
    
    func configure(with category: Department, isSelected: Bool) {
        self.category = category
        titleLabel.text = category.tabName
        titleLabel.font = isSelected ? .systemFont(ofSize: 15, weight: .semibold) : .systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = isSelected ? Constant.blackColor : Constant.lightGreyColor
        }
    
    

}
