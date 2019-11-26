//
//  ViewController2.swift
//  TestApp
//
//  Created by Igor Danich on 07.07.2018.
//  Copyright © 2018 Igor Danich. All rights reserved.
//

import DCUI

class ViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        connectKeyboard(action: .willShow) { (info) in
            print(info)
        }
    }

}
