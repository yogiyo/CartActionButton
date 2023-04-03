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
        large.delegate = self
        large.isInStock = true
        large.maximumCount = 3

        medium.size = .M
        medium.quantity = 3
        medium.isInStock = false
        medium.isSellable = false
        medium.delegate = self

        small.size = .S
        small.maximumCount = 3
        small.delegate = self
        small.quantity = 3
    }

    func cartActionButton(_ cart: CartActionButton, didChange quantity: CartActionButton.QuantityChange) {
        print(#function, quantity)
    }

    func cartActionButtonShouldExpandButton(_ cart: CartActionButton) -> Bool {
        true
    }
}

