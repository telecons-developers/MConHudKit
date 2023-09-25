//
//  ViewController.swift
//  MConHudKit
//
//  Created by developers@telecons.co.kr on 09/22/2023.
//  Copyright (c) 2023 developers@telecons.co.kr. All rights reserved.
//

import UIKit
import MConHudKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        MConHudKit.shared.test()
        MConHudKit.shared.checkBluetoothPermission()
    }
}
