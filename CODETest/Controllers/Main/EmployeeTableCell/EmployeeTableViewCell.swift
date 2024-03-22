//
//  EmployeeTableViewCell.swift
//  CODETest
//
//  Created by Кристина Пастухова on 13.03.2024.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var bdayLabel: UILabel!
    
    enum ConstantsColor {
        static let nameColor = UIColor(red: 5/255, green: 5/255, blue: 16/255, alpha: 1)
        static let tagColor = UIColor(red: 151/255, green: 151/255, blue: 155/255, alpha: 1)
        static let positionColor = UIColor(red: 85/255, green: 85/255, blue: 92/255, alpha: 1)
        static let bdayColor = UIColor(red: 85/255, green: 85/255, blue: 92/255, alpha: 1)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        nameLabel.textColor = ConstantsColor.nameColor
        
        tagLabel.font = .systemFont(ofSize: 14, weight: .medium)
        tagLabel.textColor = ConstantsColor.tagColor
        
        positionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        positionLabel.textColor = ConstantsColor.positionColor
        
        bdayLabel.font = .systemFont(ofSize: 15, weight: .regular)
        bdayLabel.textColor = ConstantsColor.bdayColor
        bdayLabel.textAlignment = .right
        
        avatarImageView.image = UIImage(named: "goose")
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        avatarImageView.clipsToBounds = true
        
    }
    
    func configure(with employee: Employee, sorting: SortOption) {
        nameLabel.text = "\(employee.firstName) \(employee.lastName)"
        tagLabel.text = employee.userTag.lowercased()
        positionLabel.text = employee.position
        bdayLabel.text = employee.dataOnScreen()
        if let url = URL(string: employee.avatarUrl) {
            avatarImageView.loadImage(from: url)
        }
        switch sorting {
        case .byAlphabet:
            bdayLabel.isHidden = true
        case .byBirthday:
            bdayLabel.isHidden = false
        }
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


        // Configure the view for the selected state
    }
    
}
