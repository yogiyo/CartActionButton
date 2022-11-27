//
//  ViewController.swift
//  CartActionButton
//
//  Created by Masher Shin on 2022/10/23.
//

import UIKit
import CartActionButton

class ViewController: UIViewController {

    @IBOutlet var large: CartActionButton!
    @IBOutlet var medium: CartActionButton!
    @IBOutlet var small: CartActionButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        large.size = .L
        medium.size = .M
        small.size = .S
    }


}

