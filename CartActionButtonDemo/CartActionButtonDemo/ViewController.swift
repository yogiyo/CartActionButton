//
//  ViewController.swift
//  CartActionButton
//
//  Created by Masher Shin on 2022/10/23.
//

import UIKit
import CartActionButton

class ViewController: UIViewController, CartActionButtonDelegate {

    @IBOutlet var large: CartActionButton!
    @IBOutlet var medium: CartActionButton!
    @IBOutlet var small: CartActionButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        large.size = .L
        medium.size = .M
        small.size = .S
        small.isUseCartButton = false
        small.maximumCount = 10
        small.delegate = self
    }

    func cartActionButton(_ cart: CartActionButton, didChangeQuantity: CartActionButton.QuantityChange) {
        print(#function, didChangeQuantity)
    }

    func cartActionButton(_ cart: CartActionButton, didPreventChange: CartActionButton.QuantityChange) {
        print(#function, didPreventChange)
    }

    func cartActionButton(_ cart: CartActionButton, didExpandChange isExpanded: Bool) {
        print(#function, isExpanded)
    }
}

