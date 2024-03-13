//
//  EmployeeTableViewCell.swift
//  CODETest
//
//  Created by Кристина Пастухова on 13.03.2024.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with employee: Employee) {
        print(employee)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


        // Configure the view for the selected state
    }
    
}
