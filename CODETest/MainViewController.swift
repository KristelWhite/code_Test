//
//  MainViewController.swift
//  CODETest
//
//  Created by Кристина Пастухова on 12.03.2024.
//

import UIKit

class MainViewController: UIViewController {

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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
