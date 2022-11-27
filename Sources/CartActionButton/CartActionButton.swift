//
//  CartActionButton.swift
//  CartActionButton
//
//  Created by Masher Shin on 2022/10/23.
//

import UIKit

// MARK: - CartActionButtonDelegate
public protocol CartActionButtonDelegate: AnyObject {
    func cartActionButton(_ cart: CartActionButton, didChangeQuantity: CartActionButton.QuantityChange)
    func cartActionButton(_ cart: CartActionButton, didPreventChange: CartActionButton.QuantityChange)
    func cartActionButton(_ cart: CartActionButton, didExpandChange isExpanded: Bool)
}

// MARK: -
// MARK: - CartActionButton
public class CartActionButton: UIView {

    // MARK: - QuantityChange
    public enum QuantityChange {
        case up(Int)
        case down(Int)
    }

    // MARK: - Size
    public enum Size {
        /// Small
        case S
        /// Large/Medium
        case M
        /// XLarge
        case L

        init(string: String) {
            switch string.uppercased() {
            case "S": self = .S
            case "M": self = .M
            case "L": self = .L
            default: self = .L
            }
        }

        var font: UIFont {
            switch self {
            case .S: return .systemFont(ofSize: 14)
            case .M: return .systemFont(ofSize: 16)
            case .L: return .systemFont(ofSize: 16)
            }
        }

        var boldFont: UIFont {
            switch self {
            case .S: return .systemFont(ofSize: 14, weight: .regular)
            case .M: return .systemFont(ofSize: 16, weight: .regular)
            case .L: return .systemFont(ofSize: 16, weight: .regular)
            }
        }

        var iconSize: CGSize {
            switch self {
            case .S: return CGSize(width: 22, height: 22)
            case .M: return CGSize(width: 24, height: 24)
            case .L: return CGSize(width: 24, height: 24)
            }
        }

        var height: CGFloat {
            switch self {
            case .S: return 34
            case .M: return 40
            case .L: return 40
            }
        }
    }

    // MARK: - Private Const

    private let animateDuration = CGFloat(0.25)

    // MARK: - Private Subview

    private lazy var containerView: UIView! = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var plusBtnContainerView: UIView! = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        return view
    }()
    private lazy var cartButton: UIButton! = {
        let button = UIButton(frame: .zero)
        button.setBackgroundImage(UIImage(named: "ic_cart", in: Bundle.module, compatibleWith: nil), for: .normal)
        button.backgroundColor = .clear
        button.tintColor = UIColor(red: 250/255.0, green: 0, blue: 80.0/255.0, alpha: 1)
        button.titleLabel?.font = size.boldFont
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(cartButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var plusButton: UIButton! = {
        let button = UIButton(frame: .zero)
        button.setBackgroundImage(UIImage(named: "ic_add", in: Bundle.module, compatibleWith: nil), for: .normal)
        button.backgroundColor = .clear
        button.tintColor = UIColor(red: 250/255.0, green: 0, blue: 80.0/255.0, alpha: 1)
        button.addTarget(self, action: #selector(plusButtonAction(_:)), for: .touchUpInside)
        button.alpha = 0
        return button
    }()
    private lazy var minusBtnContainerView: UIView! = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.alpha = 0
        return view
    }()
    private lazy var minusButton: UIButton! = {
        let button = UIButton(frame: .zero)
        button.setBackgroundImage(UIImage(named: "ic_remove", in: Bundle.module, compatibleWith: nil), for: .normal)
        button.backgroundColor = .clear
        button.tintColor = UIColor(red: 250/255.0, green: 0, blue: 80.0/255.0, alpha: 1)
        button.addTarget(self, action: #selector(minusButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var labelContainerView: UIView! = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()
    private lazy var countLabel: UILabel! = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = size.font
        label.text = "0"
        label.backgroundColor = .clear
        return label
    }()

    // MARK: - Public Variable

    @IBInspectable
    public var maximumCount: Int = Int.max

    @IBInspectable
    public var ibSize: String = "L" {
        didSet {
            size = Size(string: ibSize)
        }
    }

    public var size: Size = .L {
        didSet {
            countLabel.font = size.font
            cartButton.titleLabel?.font = size.boldFont
            clearConstraints(without: constraints.filter { $0.firstAttribute == .width || $0.firstAttribute == .height })
            setupConstraints()
        }
    }

    public var quantity: Int { Int(countLabel.text ?? "0") ?? 0 }

    public var isActive: Bool { quantity > 0 }

    public var isUseCartButton: Bool = true {
        didSet {
            setupButtonTransparency(whenExpand: false)
        }
    }

    public weak var delegate: CartActionButtonDelegate?

    // MARK: - Lifecycle

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
        super.draw(rect)
        setupInitialViews(rect)
        setupButtonTransparency(whenExpand: false)
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = tintColor
    }

    public override var tintColor: UIColor! {
        didSet {
            cartButton.tintColor = tintColor
            plusButton.tintColor = tintColor
            minusButton.tintColor = tintColor
        }
    }

    public override var backgroundColor: UIColor? {
        get {
            containerView.backgroundColor
        }
        set {
            containerView.backgroundColor = newValue
            plusBtnContainerView.backgroundColor = newValue
            minusBtnContainerView.backgroundColor = newValue
        }
    }
}

// MARK: - Action
private extension CartActionButton {

    @objc func cartButtonAction(_ sender: UIButton) {
        plusButtonAction(plusButton)
    }

    @objc func plusButtonAction(_ sender: UIButton) {
        expandButton(true)
        guard let count = Int(countLabel.text ?? "1"), count < maximumCount else {
            return
        }

        let plused = Int(count + 1)
        let qc = QuantityChange.up(plused)

        countLabel.excuteRolling(direction: .init(qc: qc)) {
            countLabel.text = "\(min(plused, maximumCount))"
        }
        delegate?.cartActionButton(self, didChangeQuantity: qc)

        if plused == maximumCount {
            plusButton.isEnabled = false
        }
    }

    @objc func minusButtonAction(_ sender: UIButton) {
        guard let count = Int(countLabel.text ?? "1"), count > 1 else {
            countLabel.text = "0"
            expandButton(false)
            return
        }

        let minused = count - 1
        let qc = QuantityChange.down(minused)
        countLabel.excuteRolling(direction: .init(qc: qc)) {
            countLabel.text = "\(max(minused, 1))"
        }
        delegate?.cartActionButton(self, didChangeQuantity: qc)

        if minused < maximumCount {
            plusButton.isEnabled = true
        }
    }
}

// MARK: - Private
private extension CartActionButton {

    var isExpanded: Bool {
        let containerLeft = constraints.first {
            $0.firstItem as? UIView == containerView && $0.firstAttribute == .left }
        return containerLeft?.constant == 0
    }

    func expandButton(_ expand: Bool) {
        adjustContainerLeft(constant: expand ? 0 : bounds.width - bounds.height)
        adjustBackground()
        UIView.animate(withDuration: animateDuration, delay: 0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            self.delegate?.cartActionButton(self, didExpandChange: expand)
        })

        UIView.transition(with: cartButton, duration: animateDuration, options: .transitionCrossDissolve) {
            self.setupButtonTransparency(whenExpand: expand)
        }
    }

    func adjustContainerLeft(constant: CGFloat) {
        let containerLeft = constraints.first {
            $0.firstItem as? UIView == containerView && $0.firstAttribute == .left }
        containerLeft?.constant = constant
    }

    func adjustBackground() {
        if isExpanded == false && isActive {
            cartButton.setBackgroundImage(nil, for: .normal)
            cartButton.setTitle("\(quantity)", for: .normal)
        } else {
            cartButton.setBackgroundImage(UIImage(named: "ic_cart", in: Bundle.module, compatibleWith: nil), for: .normal)
            cartButton.setTitle(nil, for: .normal)
        }
    }
}

// MARK: - Setup
private extension CartActionButton {

    func setupInitialViews(_ rect: CGRect) {
        containerView.layer.cornerRadius = rect.height / 2
        adjustContainerLeft(constant: rect.width - rect.height)
        adjustBackground()
    }

    func setupButtonTransparency(whenExpand expand: Bool) {
        minusBtnContainerView.alpha = expand ? 1 : 0
        if isUseCartButton {
            cartButton.alpha = expand ? 0 : 1
            plusButton.alpha = expand ? 1 : 0
        } else {
            cartButton.alpha = 0
            plusButton.alpha = 1
        }
    }

    func setupView() {
        addSubview(containerView)
        containerView.addSubview(labelContainerView)
        containerView.addSubview(minusBtnContainerView)
        containerView.addSubview(plusBtnContainerView)
        labelContainerView.addSubview(countLabel)
        minusBtnContainerView.addSubview(minusButton)
        plusBtnContainerView.addSubview(plusButton)
        plusBtnContainerView.addSubview(cartButton)
    }

    func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        plusBtnContainerView.translatesAutoresizingMaskIntoConstraints = false
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        minusBtnContainerView.translatesAutoresizingMaskIntoConstraints = false
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        labelContainerView.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false

        constraints.forEach {
            if $0.firstAttribute == .height {
                $0.constant = size.height
            }
        }

        NSLayoutConstraint.activate(containerConstraints)
        NSLayoutConstraint.activate(plusBtnContainerConstraints)
        NSLayoutConstraint.activate(cartButtonConstraints)
        NSLayoutConstraint.activate(plusButtonConstraints)
        NSLayoutConstraint.activate(minusBtnContainerConstraints)
        NSLayoutConstraint.activate(minusButtonConstraints)
        NSLayoutConstraint.activate(labelContainerConstraints)
        NSLayoutConstraint.activate(countLabelConstraints)
    }

    var containerConstraints: [NSLayoutConstraint] {
        [
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.rightAnchor.constraint(equalTo: rightAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leftAnchor.constraint(equalTo: leftAnchor),
        ]
    }

    var plusBtnContainerConstraints: [NSLayoutConstraint] {
        [
            plusBtnContainerView.widthAnchor.constraint(equalTo: containerView.heightAnchor),
            plusBtnContainerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            plusBtnContainerView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            plusBtnContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ]
    }

    var cartButtonConstraints: [NSLayoutConstraint] {
        [
            cartButton.widthAnchor.constraint(equalToConstant: size.iconSize.width),
            cartButton.heightAnchor.constraint(equalToConstant: size.iconSize.height),
            cartButton.centerXAnchor.constraint(equalTo: plusBtnContainerView.centerXAnchor),
            cartButton.centerYAnchor.constraint(equalTo: plusBtnContainerView.centerYAnchor),
        ]
    }

    var plusButtonConstraints: [NSLayoutConstraint] {
        [
            plusButton.widthAnchor.constraint(equalToConstant: size.iconSize.width),
            plusButton.heightAnchor.constraint(equalToConstant: size.iconSize.height),
            plusButton.centerXAnchor.constraint(equalTo: plusBtnContainerView.centerXAnchor),
            plusButton.centerYAnchor.constraint(equalTo: plusBtnContainerView.centerYAnchor),
        ]
    }

    var minusBtnContainerConstraints: [NSLayoutConstraint] {
        [
            minusBtnContainerView.widthAnchor.constraint(equalTo: containerView.heightAnchor),
            minusBtnContainerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            minusBtnContainerView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            minusBtnContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ]
    }

    var minusButtonConstraints: [NSLayoutConstraint] {
        [
            minusButton.widthAnchor.constraint(equalToConstant: size.iconSize.width),
            minusButton.heightAnchor.constraint(equalToConstant: size.iconSize.height),
            minusButton.centerXAnchor.constraint(equalTo: minusBtnContainerView.centerXAnchor),
            minusButton.centerYAnchor.constraint(equalTo: minusBtnContainerView.centerYAnchor),
        ]
    }

    var labelContainerConstraints: [NSLayoutConstraint] {
        [
            labelContainerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            labelContainerView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            labelContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            labelContainerView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
        ]
    }

    var countLabelConstraints: [NSLayoutConstraint] {
        let labelLeft = countLabel.leftAnchor.constraint(equalTo: minusBtnContainerView.rightAnchor)
        labelLeft.priority = .defaultHigh
        let labelRight = countLabel.rightAnchor.constraint(equalTo: plusBtnContainerView.leftAnchor)
        labelRight.priority = .defaultHigh
        return [
            countLabel.centerYAnchor.constraint(equalTo: labelContainerView.centerYAnchor),
            countLabel.centerXAnchor.constraint(equalTo: labelContainerView.centerXAnchor),
            labelLeft,
            labelRight
        ]
    }
}

// MARK: -
// MARK: - UILabel extension
private extension UILabel {

    enum RollingDirection: String {
        case up
        case down

        init(qc: CartActionButton.QuantityChange) {
            switch qc {
            case .up: self = .up
            case .down: self = .down
            }
        }

        var transitionSubType: CATransitionSubtype {
            switch self {
            case .up: return .fromTop
            case .down: return .fromBottom
            }
        }

        var transitionKey: String { "CATransitionType.\(self.rawValue)" }
    }

    func excuteRolling(direction: RollingDirection, animation: () -> Void) {
        let transition = CATransition()
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = .push
        transition.subtype = direction.transitionSubType
        transition.duration = 0.25
        animation()
        layer.add(transition, forKey: direction.transitionKey)
    }
}

// MARK: - UIView extension
private extension UIView {
    func clearConstraints(without protected: [NSLayoutConstraint] = []) {
        for subview in subviews {
            subview.clearConstraints()
        }
        let sub = Set(constraints).subtracting(Set(protected))
        removeConstraints(Array(sub))
    }
}

// MARK: - UIImage extension
extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
