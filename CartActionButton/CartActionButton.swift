//
//  CartActionButton.swift
//  CartActionButton
//
//  Created by Masher Shin on 2022/10/23.
//

import UIKit

@IBDesignable
public class CartActionButton: UIView {

    private let animateDuration = CGFloat(0.5)

    private let defaultMinimumSize = CGSize(width: 34, height: 34)

    public lazy var minimumSize: CGSize = defaultMinimumSize

    private lazy var containerView: UIView! = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        return view
    }()

    private lazy var cartBtnContainerView: UIView! = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()

    private lazy var cartButton: UIButton! = {
        let button = UIButton(frame: .zero)
        button.setBackgroundImage(UIImage(named: "ic_cart"), for: .normal)
        button.setBackgroundImage(UIImage(named: "ic_add"), for: .selected)
        button.backgroundColor = .clear
        button.tintColor = UIColor(red: 250/255.0, green: 0, blue: 80.0/255.0, alpha: 1)
        button.addTarget(self, action: #selector(cartButtonAction(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var minusBtnContainerView: UIView! = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.alpha = 0
        return view
    }()

    private lazy var minusButton: UIButton! = {
        let button = UIButton(frame: .zero)
        button.setBackgroundImage(UIImage(named: "ic_remove"), for: .normal)
        button.backgroundColor = .clear
        button.tintColor = UIColor(red: 250/255.0, green: 0, blue: 80.0/255.0, alpha: 1)
        button.addTarget(self, action: #selector(minusButtonAction(_:)), for: .touchUpInside)
        return button
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }

    public override func draw(_ rect: CGRect) {
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = rect.height / 2
        adjustContainerLeft(constant: rect.width - rect.height)
    }
}

// MARK: - Action
private extension CartActionButton {

    @objc func cartButtonAction(_ sender: UIButton) {
        adjustContainerLeft(constant: 0)
        UIView.animate(withDuration: animateDuration, delay: 0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)

        UIView.transition(with: cartButton, duration: animateDuration, options: .transitionCrossDissolve) {
            self.cartButton.isSelected = true
            self.minusBtnContainerView.alpha = 1
        }
    }

    @objc func minusButtonAction(_ sender: UIButton) {
        adjustContainerLeft(constant: bounds.width - bounds.height)
        UIView.animate(withDuration: animateDuration, delay: 0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)

        UIView.transition(with: cartButton, duration: animateDuration, options: .transitionCrossDissolve) {
            self.minusBtnContainerView.alpha = 0
            self.cartButton.isSelected = false
        }
    }
}

// MARK: - Private
private extension CartActionButton {

    func setupView() {
        backgroundColor = .clear
        addSubview(containerView)
        containerView.addSubview(cartBtnContainerView)
        cartBtnContainerView.addSubview(cartButton)
        containerView.addSubview(minusBtnContainerView)
        minusBtnContainerView.addSubview(minusButton)
    }

    func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        cartBtnContainerView.translatesAutoresizingMaskIntoConstraints = false
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        minusBtnContainerView.translatesAutoresizingMaskIntoConstraints = false
        minusButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.rightAnchor.constraint(equalTo: rightAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leftAnchor.constraint(equalTo: leftAnchor),

            cartBtnContainerView.widthAnchor.constraint(equalTo: containerView.heightAnchor),
            cartBtnContainerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            cartBtnContainerView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            cartBtnContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            cartButton.widthAnchor.constraint(equalTo: cartBtnContainerView.heightAnchor, multiplier: 0.6),
            cartButton.heightAnchor.constraint(equalTo: cartBtnContainerView.heightAnchor, multiplier: 0.6),
            cartButton.centerXAnchor.constraint(equalTo: cartBtnContainerView.centerXAnchor),
            cartButton.centerYAnchor.constraint(equalTo: cartBtnContainerView.centerYAnchor),

            minusBtnContainerView.widthAnchor.constraint(equalTo: containerView.heightAnchor),
            minusBtnContainerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            minusBtnContainerView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            minusBtnContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            minusButton.widthAnchor.constraint(equalTo: minusBtnContainerView.heightAnchor, multiplier: 0.6),
            minusButton.heightAnchor.constraint(equalTo: minusBtnContainerView.heightAnchor, multiplier: 0.6),
            minusButton.centerXAnchor.constraint(equalTo: minusBtnContainerView.centerXAnchor),
            minusButton.centerYAnchor.constraint(equalTo: minusBtnContainerView.centerYAnchor),
        ])
    }

    func adjustContainerLeft(constant: CGFloat) {
        let containerLeft = constraints.first {
            $0.firstItem as? UIView == containerView && $0.firstAttribute == .left }
        containerLeft?.constant = constant
    }
}

//extension UIImage {
//    static func from(color: UIColor) -> UIImage {
//        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
//        UIGraphicsBeginImageContext(rect.size)
//        let context = UIGraphicsGetCurrentContext()
//        context!.setFillColor(color.cgColor)
//        context!.fill(rect)
//        let img = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return img!
//    }
//}
