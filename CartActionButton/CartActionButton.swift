//
//  CartActionButton.swift
//  CartActionButton
//
//  Created by Masher Shin on 2022/10/23.
//

import UIKit

@IBDesignable
public class CartActionButton: UIView {

    public enum Size {
        /// Small
        case S
        /// Large/Medium
        case M
        /// XLarge
        case L

        var font: UIFont {
            switch self {
            case .S: return .systemFont(ofSize: 14)
            case .M: return .systemFont(ofSize: 16)
            case .L: return .systemFont(ofSize: 18)
            }
        }

        var iconSize: CGSize {
            switch self {
            case .S: return CGSize(width: 22, height: 22)
            case .M: return CGSize(width: 24, height: 24)
            case .L: return CGSize(width: 28, height: 28)
            }
        }
    }

    private let animateDuration = CGFloat(0.25)

    private let defaultMinimumSize = CGSize(width: 34, height: 34)

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
        button.backgroundColor = .clear
        button.tintColor = UIColor(red: 250/255.0, green: 0, blue: 80.0/255.0, alpha: 1)
        button.addTarget(self, action: #selector(cartButtonAction(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var plusButton: UIButton! = {
        let button = UIButton(frame: .zero)
        button.setBackgroundImage(UIImage(named: "ic_add"), for: .normal)
        button.backgroundColor = .clear
        button.tintColor = UIColor(red: 250/255.0, green: 0, blue: 80.0/255.0, alpha: 1)
        button.addTarget(self, action: #selector(plusButtonAction(_:)), for: .touchUpInside)
        button.alpha = 0
        return button
    }()

    private lazy var minusBtnContainerView: UIView! = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.alpha = 0
        return view
    }()

    /// 빼기 버튼
    private lazy var minusButton: UIButton! = {
        let button = UIButton(frame: .zero)
        button.setBackgroundImage(UIImage(named: "ic_remove"), for: .normal)
        button.backgroundColor = .clear
        button.tintColor = UIColor(red: 250/255.0, green: 0, blue: 80.0/255.0, alpha: 1)
        button.addTarget(self, action: #selector(minusButtonAction(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var countLabel: UILabel! = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = size.font
        label.text = "1"
        return label
    }()


    public lazy var minimumSize: CGSize = defaultMinimumSize

    public var size: Size = .L

    public var maximumCount = UInt(9)

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
        expandButton(true)
    }

    @objc func plusButtonAction(_ sender: UIButton) {
        guard let count = Int(countLabel.text ?? "1"), count < maximumCount else {
            return
        }

        let plused = UInt(count + 1)
        countLabel.text = "\(min(plused, maximumCount))"

        if plused == maximumCount {
            plusButton.isEnabled = false
        }
    }

    @objc func minusButtonAction(_ sender: UIButton) {
        guard let count = Int(countLabel.text ?? "1"), count > 1 else {
            expandButton(false)
            return
        }
        let minused = count - 1
        countLabel.text = "\(max(minused, 1))"

        if minused < maximumCount {
            plusButton.isEnabled = true
        }
    }
}

// MARK: - Private
private extension CartActionButton {

    func adjustContainerLeft(constant: CGFloat) {
        let containerLeft = constraints.first {
            $0.firstItem as? UIView == containerView && $0.firstAttribute == .left }
        containerLeft?.constant = constant
    }

    func expandButton(_ expand: Bool) {
        adjustContainerLeft(constant: expand ? 0 : bounds.width - bounds.height)
        UIView.animate(withDuration: animateDuration, delay: 0, options: .curveEaseInOut) {
            self.layoutIfNeeded()
        }

        UIView.transition(with: cartButton, duration: animateDuration, options: .transitionCrossDissolve) {
            self.minusBtnContainerView.alpha = expand ? 1 : 0
            self.cartButton.alpha = expand ? 0 : 1
            self.plusButton.alpha = expand ? 1 : 0
        }
    }
}

// MARK: - Setup
private extension CartActionButton {
    func setupView() {
        backgroundColor = .clear
        addSubview(containerView)
        containerView.addSubview(cartBtnContainerView)
        cartBtnContainerView.addSubview(plusButton)
        cartBtnContainerView.addSubview(cartButton)
        containerView.addSubview(minusBtnContainerView)
        minusBtnContainerView.addSubview(minusButton)
        containerView.addSubview(countLabel)
    }

    func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        cartBtnContainerView.translatesAutoresizingMaskIntoConstraints = false
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        minusBtnContainerView.translatesAutoresizingMaskIntoConstraints = false
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.rightAnchor.constraint(equalTo: rightAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leftAnchor.constraint(equalTo: leftAnchor),

            cartBtnContainerView.widthAnchor.constraint(equalTo: containerView.heightAnchor),
            cartBtnContainerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            cartBtnContainerView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            cartBtnContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            cartButton.widthAnchor.constraint(equalToConstant: size.iconSize.width),
            cartButton.heightAnchor.constraint(equalToConstant: size.iconSize.height),
            cartButton.centerXAnchor.constraint(equalTo: cartBtnContainerView.centerXAnchor),
            cartButton.centerYAnchor.constraint(equalTo: cartBtnContainerView.centerYAnchor),

            plusButton.widthAnchor.constraint(equalToConstant: size.iconSize.width),
            plusButton.heightAnchor.constraint(equalToConstant: size.iconSize.height),
            plusButton.centerXAnchor.constraint(equalTo: cartBtnContainerView.centerXAnchor),
            plusButton.centerYAnchor.constraint(equalTo: cartBtnContainerView.centerYAnchor),

            minusBtnContainerView.widthAnchor.constraint(equalTo: containerView.heightAnchor),
            minusBtnContainerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            minusBtnContainerView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            minusBtnContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            minusButton.widthAnchor.constraint(equalToConstant: size.iconSize.width),
            minusButton.heightAnchor.constraint(equalToConstant: size.iconSize.height),
            minusButton.centerXAnchor.constraint(equalTo: minusBtnContainerView.centerXAnchor),
            minusButton.centerYAnchor.constraint(equalTo: minusBtnContainerView.centerYAnchor),

            countLabel.rightAnchor.constraint(equalTo: cartBtnContainerView.leftAnchor),
            countLabel.leftAnchor.constraint(equalTo: minusBtnContainerView.rightAnchor),
            countLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
    }
}
