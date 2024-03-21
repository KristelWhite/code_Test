//
//  PhoneTableViewCell.swift
//  CODETest
//
//  Created by Кристина Пастухова on 21.03.2024.
//

import UIKit

protocol CellDelegate: AnyObject {
    func didTapButtonInCell()
}

class PhoneTableViewCell: UITableViewCell {

    @IBOutlet weak var phoneImageView: UIImageView!
    @IBOutlet weak var phoneButton: UIButton!
    
    weak var delegate: CellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = UIImage(named: "phone")?.withTintColor(Constant.blackColor)
        self.phoneImageView.image = image
        
        phoneButton.setTitleColor(Constant.blackColor, for: .normal)
        phoneButton.setTitleColor(Constant.blackColor, for: .highlighted)
        phoneButton.setTitleColor(Constant.blackColor, for: .disabled)
        phoneButton.setTitleColor(Constant.blackColor, for: .selected)
        phoneButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        phoneButton.contentHorizontalAlignment = .left
        
    }
    
    @IBAction func tapOnPhone(_ sender: Any) {
        delegate?.didTapButtonInCell()

    }
    
    func configure(with phone: String){
        phoneButton.setTitle(phone, for: .normal)
        phoneButton.setTitle(phone, for: .highlighted)
        phoneButton.setTitle(phone, for: .disabled)
        phoneButton.setTitle(phone, for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
