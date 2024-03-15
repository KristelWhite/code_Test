//
//  UIImageView+ImageLoader.swift
//  CODETest
//
//  Created by Кристина Пастухова on 12.03.2024.
//

import Foundation
import UIKit


extension UIImageView {
    
    func loadImage(from url: URL){
        ImageLoader().loadImage(from: url) { [weak self] result in
            if case let .success(image) = result {
                DispatchQueue.main.async {
                    self?.image = image
                }
            } else {
//                поставить заглушку
            }
        }
    }
}
