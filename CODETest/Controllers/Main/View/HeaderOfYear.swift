//
//  HeaderOfYear.swift
//  CODETest
//
//  Created by Кристина Пастухова on 22.03.2024.
//

import UIKit

class HeaderOfYear: UIView {
    
    private let label = UILabel()
    private let lineLeft = UIView()
    private let lineRight = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = UIColor.clear
        
        let nextYear = SortAndFilterLogic.nextYear(of: Date())
        label.text = String(nextYear)
        label.textAlignment = .center
        label.textColor = Constant.lightGreyColor2
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        lineLeft.backgroundColor = Constant.lightGreyColor2
        lineLeft.translatesAutoresizingMaskIntoConstraints = false
        
        lineRight.backgroundColor = Constant.lightGreyColor2
        lineRight.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        addSubview(lineLeft)
        addSubview(lineRight)

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.widthAnchor.constraint(equalToConstant: 160),
            
            lineLeft.heightAnchor.constraint(equalToConstant: 1),
            lineLeft.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            lineLeft.rightAnchor.constraint(equalTo: label.leftAnchor, constant: -12),
            lineLeft.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24),
            
            lineRight.heightAnchor.constraint(equalToConstant: 1),
            lineRight.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            lineRight.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 12),
            lineRight.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24)
        ])
    }
    

}
