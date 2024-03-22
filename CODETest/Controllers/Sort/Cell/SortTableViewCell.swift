//
//  FilterTableViewCell.swift
//  CODETest
//
//  Created by Кристина Пастухова on 18.03.2024.
//

import UIKit

class SortTableViewCell: UITableViewCell {
    
    @IBOutlet weak var optionImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         configureAppearance()
    }
    
    private func configureAppearance(){
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(red: 5/255, green: 5/255, blue: 16/255, alpha: 1)
        titleLabel.textAlignment = .left
        
        optionImageView.tintColor = UIColor(red: 101/255, green: 52/255, blue: 255/255, alpha: 1)
        optionImageView.contentMode = .scaleAspectFit
    }
    
    func configure(with option: SortOption, isSelected: Bool) {
        titleLabel.text = option.rawValue
        optionImageView.image = isSelected ? UIImage(named: "full.sort.icon") : UIImage(named: "sort.icon")
    }
}

