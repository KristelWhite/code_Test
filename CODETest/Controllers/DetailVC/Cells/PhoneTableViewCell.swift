//
//  PhoneTableViewCell.swift
//  CODETest
//
//  Created by Кристина Пастухова on 21.03.2024.
//

import UIKit

class PhoneTableViewCell: UITableViewCell {

    @IBOutlet weak var phoneImageView: UIImageView!
    @IBOutlet weak var phoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = UIImage(named: "phone")?.withTintColor(Constant.blackColor)
        self.phoneImageView.image = image
        
        phoneLabel.font = .systemFont(ofSize: 16, weight: .medium)
        phoneLabel.textColor = Constant.blackColor
        phoneLabel.textAlignment = .left
    }
    
    func configure(with phone: String){
        phoneLabel.text = phone
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
