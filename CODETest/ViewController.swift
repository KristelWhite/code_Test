//
//  ViewController.swift
//  CODETest
//
//  Created by Кристина Пастухова on 12.03.2024.
//

import UIKit

class ViewController: UIViewController {
    let network: Networking = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        network.loadData(isSuccess: true) { result in
            switch result {
            case .success(let success):
                for item in success.items {
                    print(item.birthday)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }


}

