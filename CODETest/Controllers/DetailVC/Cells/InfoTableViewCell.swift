//
//  InfoTableViewCell.swift
//  CODETest
//
//  Created by Кристина Пастухова on 21.03.2024.
//

import UIKit

enum Constant {
    static let blackColor = UIColor(red: 5/255, green: 5/255, blue: 16/255, alpha: 1)
    static let ligthGreyColor = UIColor(red: 151/255, green: 151/255, blue: 155/255, alpha: 1)
    static let greyColor = UIColor(red: 85/255, green: 85/255, blue: 92/255, alpha: 1)
}


class InfoTableViewCell: UITableViewCell {
  
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var numberOfYearsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = UIImage(named: "star")?.withTintColor(Constant.blackColor)
        self.starImageView.image = image
        
        dateLabel.font = .systemFont(ofSize: 16, weight: .medium)
        dateLabel.textColor = Constant.blackColor
        dateLabel.textAlignment = .left
        
        numberOfYearsLabel.font = .systemFont(ofSize: 16, weight: .medium)
        numberOfYearsLabel.textColor = Constant.ligthGreyColor
        numberOfYearsLabel.textAlignment = .right
    }
    
    func configure(with date: String, years: String){
        dateLabel.text = date
        numberOfYearsLabel.text = years
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
