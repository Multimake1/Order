//
//  ViewController.swift
//  Order
//
//  Created by Арсений on 16.10.2024.
//

import UIKit

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

final class ViewController: UIViewController {
    
    private let viewModel = ViewModel()
    
    private lazy var emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(TitleCell.self, forCellReuseIdentifier: String(describing: TitleCell.self))
        tableView.register(ApplyPromocodeCell.self, forCellReuseIdentifier: String(describing: ApplyPromocodeCell.self))
        tableView.register(PromoCell.self, forCellReuseIdentifier: String(describing: PromoCell.self))
        tableView.register(HidePromoCell.self, forCellReuseIdentifier: String(describing: HidePromoCell.self))
        tableView.register(TotalPriceCell.self, forCellReuseIdentifier: String(describing: TotalPriceCell.self))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let order: Order = Order(screenTitle: "Оформление заказа",
                                 promocodes: [.init(title: "VESNAddssdsddssddsdsdssdsd20", percent: 5, endDate: formatter.date(from: "2024/10/08"), info: nil, active: true),
                                              .init(title: "KROweqwCS12", percent: 10, endDate: formatter.date(from:"2024/10/01"), info: "kefteme", active: false),
                                              .init(title: "KROCqweqweS12", percent: 10, endDate: formatter.date(from:"2024/10/01"), info: "dfjakdfjaksfjlskadfj", active: false),
                                              .init(title: "KROCS12", percent: 10, endDate: formatter.date(from:"2024/10/01"), info: "", active: false),
                                              .init(title: "KROCS12", percent: 10, endDate: formatter.date(from:"2024/10/01"), info: "dmf msadkfjnsdkjnvjkdsnjkfdsnfjkasdnf", active: false)],
                                 products: [.init(price: 1200, title: "asa"),
                                            .init(price: 1000, title: "asdasd")],
                                 paymentDiscount: 0,
                                 baseDiscount: 0)
        self.configure()
        showOrder(with: order)
    }


}

final class TotalPriceCell: UITableViewCell {
    var viewModel: TableViewModel.ViewModelType.Products? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var grayHexColor = {
        let color = UIColor(hex: "#7A7A7Aff")
        return color
    }()
    
    private lazy var lightGrayHexColor = {
        let color = UIColor(hex: "#F6F6F6ff")
        return color
    }()
    
    private lazy var greenHexColor = {
        let color = UIColor(hex: "#00B775ff")
        return color
    }()
    
    private lazy var orangeHexColor = {
        let color = UIColor(hex: "#ff4611ff")
        return color
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .infoLight)
        let image = UIImage(named: "infoImage")
        button.titleLabel?.numberOfLines = 0
        button.setImage(image, for: .normal)
        button.tintColor = grayHexColor
        button.addTarget(self, action: #selector(getInfoAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var totalView = {
        let view = UIView()
        view.backgroundColor = lightGrayHexColor
        return view
    }()
    
    private lazy var countProductLabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var countProductPriceLabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var baseDiscountsLabel = {
        let label = UILabel()
        label.text = "Скидки"
        return label
    }()
    
    private lazy var baseDiscountsPriceLabel = {
        let label = UILabel()
        label.textColor = orangeHexColor
        return label
    }()
    
    private lazy var promocodesLabel = {
        let label = UILabel()
        label.text = "Промокоды"
        return label
    }()
    
    private lazy var promocodesPriceLabel = {
        let label = UILabel()
        label.textColor = greenHexColor
        return label
    }()
    
    private lazy var paymentDiscountLabel = {
        let label = UILabel()
        label.text = "Способ оплаты"
        return label
    }()
    
    private lazy var paymentDiscountPriceLabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var totalLabel = {
        let label = UILabel()
        label.text = "Итого"
        return label
    }()
    
    private lazy var totalPriceLabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var placeAnOrderButton = {
        let button = UIButton()
        button.setTitle("Оформить заказ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(16)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = orangeHexColor
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        return button
    }()
    
    @objc func tap() {
        print("Оформить заказ")
    }
    
    private lazy var straightLineView = {
        let view = UIView()
        view.backgroundColor = grayHexColor
        return view
    }()
    
    private lazy var conditionsLabel = {
        let label = UILabel()
        label.font = label.font.withSize(10)
        label.numberOfLines = 0
        label.textColor = grayHexColor
        label.textAlignment = .center
        label.text = "Нажимая кнопку оформить заказ, Вы соглашаетесь с Условиями оферты"
        return label
    }()
    
    @objc func getInfoAction() {
        print("getInfoAction")
    }
    
    private func updateUI() {
        guard let viewModel else {
            return
        }
        
        //placeAnOrderButton.bottomAnchor.constraint(equalTo: conditionsLabel.topAnchor, constant: -16).isActive = true
        countProductLabel.text = viewModel.priceOfProductsString()
        countProductPriceLabel.text = viewModel.productPriceString()
        
        if viewModel.baseDiscount != 0 {
            baseDiscountsPriceLabel.text = viewModel.baseDiscountString()
        } else {
            baseDiscountsLabel.removeFromSuperview()
            baseDiscountsPriceLabel.removeFromSuperview()
            promocodesLabel.topAnchor.constraint(equalTo: countProductLabel.bottomAnchor, constant: 10).isActive = true
            promocodesPriceLabel.topAnchor.constraint(equalTo: countProductPriceLabel.bottomAnchor, constant: 10).isActive = true
        }
        
        if viewModel.promocodesDiscountCount() != 0 {
            totalView.addSubview(promocodesLabel)
            totalView.addSubview(promocodesPriceLabel)
            totalView.addSubview(infoButton)
            if viewModel.baseDiscount != 0 {
                promocodesLabel.translatesAutoresizingMaskIntoConstraints = false
                promocodesLabel.topAnchor.constraint(equalTo: baseDiscountsLabel.bottomAnchor, constant: 10).isActive = true
                promocodesLabel.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 32).isActive = true
                
                promocodesPriceLabel.translatesAutoresizingMaskIntoConstraints = false
                promocodesPriceLabel.topAnchor.constraint(equalTo: baseDiscountsPriceLabel.bottomAnchor, constant: 10).isActive = true
                promocodesPriceLabel.rightAnchor.constraint(equalTo: totalView.rightAnchor, constant: -32).isActive = true
            } else {
                promocodesLabel.translatesAutoresizingMaskIntoConstraints = false
                promocodesLabel.topAnchor.constraint(equalTo: countProductLabel.bottomAnchor, constant: 10).isActive = true
                promocodesLabel.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 32).isActive = true
                
                promocodesPriceLabel.translatesAutoresizingMaskIntoConstraints = false
                promocodesPriceLabel.topAnchor.constraint(equalTo: countProductPriceLabel.bottomAnchor, constant: 10).isActive = true
                promocodesPriceLabel.rightAnchor.constraint(equalTo: totalView.rightAnchor, constant: -32).isActive = true
            }
            
            infoButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                infoButton.centerYAnchor.constraint(equalTo: promocodesLabel.centerYAnchor),
                infoButton.leadingAnchor.constraint(equalTo: promocodesLabel.trailingAnchor, constant: 4),
                infoButton.trailingAnchor.constraint(lessThanOrEqualTo: promocodesPriceLabel.leadingAnchor, constant: -8)
            ])
            
            promocodesPriceLabel.text = viewModel.promocodesDiscountString()
        } else if viewModel.baseDiscount != 0 {
            promocodesLabel.removeFromSuperview()
            promocodesPriceLabel.removeFromSuperview()
            infoButton.removeFromSuperview()
            paymentDiscountLabel.topAnchor.constraint(equalTo: baseDiscountsLabel.bottomAnchor, constant: 10).isActive = true
            paymentDiscountPriceLabel.topAnchor.constraint(equalTo: baseDiscountsPriceLabel.bottomAnchor, constant: 10).isActive = true
        } else {
            promocodesLabel.removeFromSuperview()
            promocodesPriceLabel.removeFromSuperview()
            infoButton.removeFromSuperview()
            paymentDiscountLabel.topAnchor.constraint(equalTo: countProductLabel.bottomAnchor, constant: 10).isActive = true
            paymentDiscountPriceLabel.topAnchor.constraint(equalTo: countProductPriceLabel.bottomAnchor, constant: 10).isActive = true
        }
        
        if viewModel.paymentMethodDiscount != 0 {
            paymentDiscountPriceLabel.text = viewModel.paymentDiscountString()
        } else if viewModel.promocodesDiscountCount() != 0 {
            paymentDiscountLabel.removeFromSuperview()
            paymentDiscountPriceLabel.removeFromSuperview()
            totalLabel.topAnchor.constraint(equalTo: promocodesLabel.bottomAnchor, constant: 10).isActive = true
            totalPriceLabel.topAnchor.constraint(equalTo: promocodesPriceLabel.bottomAnchor, constant: 10).isActive = true
        } else if viewModel.baseDiscount != 0 {
            paymentDiscountLabel.removeFromSuperview()
            paymentDiscountPriceLabel.removeFromSuperview()
            totalLabel.topAnchor.constraint(equalTo: baseDiscountsLabel.bottomAnchor, constant: 10).isActive = true
            totalPriceLabel.topAnchor.constraint(equalTo: baseDiscountsPriceLabel.bottomAnchor, constant: 10).isActive = true
        } else {
            paymentDiscountLabel.removeFromSuperview()
            paymentDiscountPriceLabel.removeFromSuperview()
            totalLabel.topAnchor.constraint(equalTo: countProductLabel.bottomAnchor, constant: 10).isActive = true
            totalPriceLabel.topAnchor.constraint(equalTo: countProductPriceLabel.bottomAnchor, constant: 10).isActive = true
        }
        
        totalPriceLabel.text = viewModel.totalPriceString()
    }

    private func setupUI() {
        self.contentView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        self.contentView.addSubview(totalView)
        totalView.translatesAutoresizingMaskIntoConstraints = false
        totalView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        totalView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        totalView.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor).isActive = true
        totalView.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        self.totalView.addSubview(countProductLabel)
        countProductLabel.translatesAutoresizingMaskIntoConstraints = false
        countProductLabel.topAnchor.constraint(equalTo: totalView.topAnchor, constant: 24).isActive = true
        countProductLabel.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 32).isActive = true
        
        self.totalView.addSubview(countProductPriceLabel)
        countProductPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        countProductPriceLabel.topAnchor.constraint(equalTo: totalView.topAnchor, constant: 24).isActive = true
        countProductPriceLabel.rightAnchor.constraint(equalTo: totalView.rightAnchor, constant: -32).isActive = true
        
        self.totalView.addSubview(baseDiscountsLabel)
        baseDiscountsLabel.translatesAutoresizingMaskIntoConstraints = false
        baseDiscountsLabel.topAnchor.constraint(equalTo: countProductLabel.bottomAnchor, constant: 10).isActive = true
        baseDiscountsLabel.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 32).isActive = true
        
        self.totalView.addSubview(baseDiscountsPriceLabel)
        baseDiscountsPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        baseDiscountsPriceLabel.topAnchor.constraint(equalTo: countProductPriceLabel.bottomAnchor, constant: 10).isActive = true
        baseDiscountsPriceLabel.rightAnchor.constraint(equalTo: totalView.rightAnchor, constant: -32).isActive = true
        
        self.totalView.addSubview(promocodesLabel)
        promocodesLabel.translatesAutoresizingMaskIntoConstraints = false
        promocodesLabel.topAnchor.constraint(equalTo: baseDiscountsLabel.bottomAnchor, constant: 10).isActive = true
        promocodesLabel.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 32).isActive = true
        
        self.totalView.addSubview(promocodesPriceLabel)
        promocodesPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        promocodesPriceLabel.topAnchor.constraint(equalTo: baseDiscountsPriceLabel.bottomAnchor, constant: 10).isActive = true
        promocodesPriceLabel.rightAnchor.constraint(equalTo: totalView.rightAnchor, constant: -32).isActive = true
        
        self.totalView.addSubview(paymentDiscountLabel)
        paymentDiscountLabel.translatesAutoresizingMaskIntoConstraints = false
        paymentDiscountLabel.topAnchor.constraint(equalTo: promocodesLabel.bottomAnchor, constant: 10).isActive = true
        paymentDiscountLabel.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 32).isActive = true
        
        self.totalView.addSubview(paymentDiscountPriceLabel)
        paymentDiscountPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        paymentDiscountPriceLabel.topAnchor.constraint(equalTo: promocodesPriceLabel.bottomAnchor, constant: 10).isActive = true
        paymentDiscountPriceLabel.rightAnchor.constraint(equalTo: totalView.rightAnchor, constant: -32).isActive = true
        
        /*self.totalView.addSubview(straightLineView)
        straightLineView.translatesAutoresizingMaskIntoConstraints = false
        //straightLineView.frame.size.width = 311
        straightLineView.frame.size.height = 5
        straightLineView.topAnchor.constraint(equalTo: paymentDiscountLabel.bottomAnchor, constant: 16).isActive = true
        straightLineView.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 32).isActive = true
        straightLineView.rightAnchor.constraint(equalTo: totalView.leftAnchor, constant: -32).isActive = true*/
        
        self.totalView.addSubview(totalLabel)
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.topAnchor.constraint(equalTo: paymentDiscountLabel.bottomAnchor, constant: 32).isActive = true
        totalLabel.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 32).isActive = true
        
        self.totalView.addSubview(totalPriceLabel)
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPriceLabel.topAnchor.constraint(equalTo: paymentDiscountLabel.bottomAnchor, constant: 32).isActive = true
        totalPriceLabel.rightAnchor.constraint(equalTo: totalView.rightAnchor, constant: -32).isActive = true
        
        self.totalView.addSubview(placeAnOrderButton)
        placeAnOrderButton.translatesAutoresizingMaskIntoConstraints = false
        //placeAnOrderButton.frame.size.height = 54
        placeAnOrderButton.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 16).isActive = true
        placeAnOrderButton.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 32).isActive = true
        //placeAnOrderButton.bottomAnchor.constraint(equalTo: totalView.bottomAnchor, constant: -88).isActive = true
        placeAnOrderButton.rightAnchor.constraint(equalTo: totalView.rightAnchor, constant: -32).isActive = true
        
        self.totalView.addSubview(conditionsLabel)
        conditionsLabel.translatesAutoresizingMaskIntoConstraints = false
        conditionsLabel.topAnchor.constraint(equalTo: placeAnOrderButton.bottomAnchor, constant: 16).isActive = true
        conditionsLabel.leftAnchor.constraint(equalTo: totalView.leftAnchor, constant: 32).isActive = true
        conditionsLabel.trailingAnchor.constraint(equalTo: totalView.trailingAnchor, constant: -32).isActive = true
        //conditionsLabel.bottomAnchor.constraint(equalTo: totalView.bottomAnchor, constant: -40).isActive = true
        contentView.addSubview(infoButton)
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoButton.centerYAnchor.constraint(equalTo: promocodesLabel.centerYAnchor),
            infoButton.leadingAnchor.constraint(equalTo: promocodesLabel.trailingAnchor, constant: 4),
            infoButton.trailingAnchor.constraint(lessThanOrEqualTo: promocodesPriceLabel.leadingAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
}

final class HidePromoCell: UITableViewCell {
    var viewModel: TableViewModel.ViewModelType.HidePromo? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var orangeHexColor = {
        let color = UIColor(hex: "#ff4611ff")
        return color
    }()
    
    private lazy var hidePromoButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = .clear
        button.setTitleColor(orangeHexColor, for: .normal)
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        return button
    }()
    
    private func updateUI() {
        guard let viewModel else {
            return
        }
        
        hidePromoButton.setTitle(viewModel.titleHide, for: .normal)
    }

    private func setupUI() {
        contentView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        contentView.addSubview(hidePromoButton)
        hidePromoButton.translatesAutoresizingMaskIntoConstraints = false
        hidePromoButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        hidePromoButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        hidePromoButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        //hidePromoButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30).isActive = true
        hidePromoButton.titleLabel?.leftAnchor.constraint(equalTo: hidePromoButton.leftAnchor, constant: 16).isActive = true
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @objc func tap() {
        print("Скрыть промокоды")
    }
}

final class ApplyPromocodeCell: UITableViewCell {
    var viewModel: TableViewModel.ViewModelType.ApplyPromocode? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var orangeHexColor = {
        let color = UIColor(hex: "#ff4611ff")
        return color
    }()
    
    private lazy var orangeHexColorAlpha = {
        let color = UIColor(hex: "#ff4611ff")?.withAlphaComponent(0.1)
        return color
    }()
    
    private lazy var applyPromocodeButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = orangeHexColorAlpha
        button.setTitleColor(orangeHexColor, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        return button
    }()
    
    private lazy var applyPromocodeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "percentImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        //imageView.tintColor = orangeHexColor
        return imageView
    }()
    
    private func updateUI() {
        guard let viewModel else {
            return
        }
        
        applyPromocodeButton.setTitle(viewModel.titleApply, for: .normal)
    }

    private func setupUI() {
        contentView.heightAnchor.constraint(equalToConstant: 86).isActive = true
        contentView.addSubview(applyPromocodeButton)
        applyPromocodeButton.translatesAutoresizingMaskIntoConstraints = false
        applyPromocodeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        applyPromocodeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        applyPromocodeButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        applyPromocodeButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        
        applyPromocodeButton.addSubview(applyPromocodeImage)
        applyPromocodeImage.translatesAutoresizingMaskIntoConstraints = false
        applyPromocodeImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        applyPromocodeImage.trailingAnchor.constraint(equalTo: applyPromocodeButton.titleLabel?.leadingAnchor ?? applyPromocodeButton.leftAnchor, constant: -10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @objc func tap() {
        print("тап")
    }
}

final class TitleCell: UITableViewCell {
    var viewModel: TableViewModel.ViewModelType.TitleInfo? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var titlePromoLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(24)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private lazy var titleInfoLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    
    private func updateUI() {
        guard let viewModel else {
            return
        }
        
        titlePromoLabel.text = viewModel.title
        titleInfoLabel.text = viewModel.info
    }

    private func setupUI() {
        contentView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24).isActive = true
        titleView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        titleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        titleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        titleView.addSubview(titlePromoLabel)
        titlePromoLabel.translatesAutoresizingMaskIntoConstraints = false
        titlePromoLabel.topAnchor.constraint(equalTo: titleView.topAnchor).isActive = true
        titlePromoLabel.leftAnchor.constraint(equalTo: titleView.leftAnchor).isActive = true
        titlePromoLabel.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
        
        titleView.addSubview(titleInfoLabel)
        titleInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        titleInfoLabel.topAnchor.constraint(equalTo: titlePromoLabel.bottomAnchor, constant: 10).isActive = true
        titleInfoLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        titleInfoLabel.leftAnchor.constraint(equalTo: titleView.leftAnchor).isActive = true
        titleInfoLabel.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
}

final class PromoCell: UITableViewCell {
    var viewModel: TableViewModel.ViewModelType.Promo? {
        didSet {
            updateUI()
        }
    }

    private lazy var grayHexColor = {
        let color = UIColor(hex: "#7A7A7Aff")
        return color
    }()
    
    private lazy var lightGrayHexColor = {
        let color = UIColor(hex: "#F6F6F6ff")
        return color
    }()
    
    private lazy var greenHexColor = {
        let color = UIColor(hex: "#00B775ff")
        return color
    }()
    
    private lazy var orangeHexColor = {
        let color = UIColor(hex: "#ff4611ff")
        return color
    }()
    
    private lazy var promoView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = lightGrayHexColor
        return view
    }()
    
    private lazy var subPromoView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var circleLeftView: UIView = {
        let view = UIView()
        //view.frame.size.width = 20
        //view.frame.size.height = 20
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var circleRightView: UIView = {
        let view = UIView()
        //view.frame.size.width = 20
        //view.frame.size.height = 20
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var titlePromoLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(16)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private lazy var datePromoLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = grayHexColor
        return label
    }()
    
    private lazy var percentLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(10)
        label.textColor = .white
        label.numberOfLines = 0
        label.backgroundColor = greenHexColor
        label.layer.masksToBounds = true
        //label.layer.cornerRadius = 10
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = label.font.withSize(12)
        label.textColor = grayHexColor
        return label
    }()
    
    lazy var switchButton: UISwitch = {
        let button = UISwitch()
        button.onTintColor = orangeHexColor
        button.tintColor = grayHexColor
        button.isOn = false
        button.addTarget(self, action: #selector(toggle), for: .valueChanged)
        return button
    }()
    
    /*private lazy var infoImage: UIImage = {
        var image = UIImage()
        image = UIImage(named: "infoImage") ??
        //imageView.tintColor = orangeHexColor
        return image
    }()*/
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .infoLight)
        let image = UIImage(named: "infoImage")
        button.titleLabel?.numberOfLines = 0
        button.setImage(image, for: .normal)
        button.tintColor = grayHexColor
        button.addTarget(self, action: #selector(getInfoAction), for: .touchUpInside)
        return button
    }()
    
    @objc func toggle() {
        guard let viewModel else { return }
        viewModel.toggle?(switchButton.isOn, viewModel.id)
    }
    
    @objc func getInfoAction() {
        guard let viewModel else { return }
        print("getInfoAction")
    }
    
    private func updateUI() {
        guard let viewModel else {
            return
        }
        
        
        
        switchButton.setOn(viewModel.isActive, animated: true)
        titlePromoLabel.text = viewModel.title
        datePromoLabel.text = "По " + viewModel.getDate(endDate: viewModel.endDate ?? Date.now)
        datePromoLabel.topAnchor.constraint(equalTo: titlePromoLabel.bottomAnchor).isActive = true
        if viewModel.info != "" {
            promoView.addSubview(infoLabel)
            infoLabel.translatesAutoresizingMaskIntoConstraints = false
            infoLabel.topAnchor.constraint(equalTo: subPromoView.bottomAnchor, constant: 8).isActive = true
            infoLabel.leadingAnchor.constraint(equalTo: promoView.leadingAnchor, constant: 20).isActive = true
            infoLabel.bottomAnchor.constraint(equalTo: promoView.bottomAnchor, constant: -12).isActive = true
            infoLabel.trailingAnchor.constraint(equalTo: promoView.trailingAnchor, constant: -12).isActive = true
            infoLabel.text = viewModel.info
        }
        percentLabel.text = "-" + String(viewModel.percent) + "%"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func setupUI() {
        contentView.addSubview(promoView)
        promoView.translatesAutoresizingMaskIntoConstraints = false
        promoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        promoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        promoView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        promoView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        //promoView.heightAnchor.constraint(equalToConstant: 66).isActive = true
        
        promoView.addSubview(subPromoView)
        subPromoView.translatesAutoresizingMaskIntoConstraints = false
        subPromoView.topAnchor.constraint(equalTo: promoView.topAnchor, constant: 18).isActive = true
        subPromoView.leftAnchor.constraint(equalTo: promoView.leftAnchor, constant: 20).isActive = true
        subPromoView.rightAnchor.constraint(equalTo: promoView.rightAnchor, constant: -20).isActive = true
        //subPromoView.bottomAnchor.constraint(equalTo: promoView.bottomAnchor, constant: -12).isActive = true
        
        subPromoView.addSubview(switchButton)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                    switchButton.trailingAnchor.constraint(equalTo: promoView.trailingAnchor, constant: -20),
                    switchButton.centerYAnchor.constraint(equalTo: subPromoView.centerYAnchor)
                ])
        
        
        
        /*
        NSLayoutConstraint.activate([
                   switchButton.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
                   switchButton.centerYAnchor.constraint(equalTo: mainView.centerYAnchor)
               ])
               
               NSLayoutConstraint.activate([
                   infoButton.centerYAnchor.constraint(equalTo: percentLabel.centerYAnchor),
                   infoButton.leadingAnchor.constraint(equalTo: percentLabel.trailingAnchor, constant: 4),
                   infoButton.trailingAnchor.constraint(lessThanOrEqualTo: switchButton.leadingAnchor, constant: -4)
               ])

               // percentLabel constraints
               NSLayoutConstraint.activate([
                   percentLabel.leadingAnchor.constraint(equalTo: promoLabel.trailingAnchor, constant: 4),
                   percentLabel.topAnchor.constraint(equalTo: mainView.topAnchor)
               ])

               // promoLabel constraints
         
               NSLayoutConstraint.activate([
                   promoLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
                   promoLabel.trailingAnchor.constraint(equalTo: percentLabel.leadingAnchor, constant: -8),
                   promoLabel.topAnchor.constraint(equalTo: mainView.topAnchor)
               ])
        */
        
        
        subPromoView.addSubview(titlePromoLabel)
        contentView.addSubview(percentLabel)
        titlePromoLabel.translatesAutoresizingMaskIntoConstraints = false
        //titlePromoLabel.topAnchor.constraint(equalTo: subPromoView.topAnchor).isActive = true
        //titlePromoLabel.leadingAnchor.constraint(equalTo: subPromoView.leadingAnchor).isActive = true
        //titlePromoLabel.bottomAnchor.constraint(equalTo: subPromoView.bottomAnchor, constant: -20).isActive = true
        NSLayoutConstraint.activate([
            titlePromoLabel.leadingAnchor.constraint(equalTo: subPromoView.leadingAnchor),
            titlePromoLabel.trailingAnchor.constraint(equalTo: percentLabel.leadingAnchor, constant: -8),
            titlePromoLabel.topAnchor.constraint(equalTo: subPromoView.topAnchor)
        ])
        
        subPromoView.addSubview(datePromoLabel)
        datePromoLabel.translatesAutoresizingMaskIntoConstraints = false
        datePromoLabel.topAnchor.constraint(equalTo: titlePromoLabel.bottomAnchor).isActive = true
        datePromoLabel.leftAnchor.constraint(equalTo: subPromoView.leftAnchor).isActive = true
        //datePromoLabel.rightAnchor.constraint(equalTo: subPromoView.rightAnchor, constant: -54).isActive = true
        datePromoLabel.bottomAnchor.constraint(equalTo: subPromoView.bottomAnchor).isActive = true
        
        
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.frame.size.width = 35
        percentLabel.frame.size.height = 25
        //percentLabel.layer.cornerRadius = percentLabel.frame.size.width / 2
        NSLayoutConstraint.activate([
            percentLabel.leadingAnchor.constraint(equalTo: titlePromoLabel.trailingAnchor, constant: 8),
            percentLabel.centerYAnchor.constraint(equalTo: titlePromoLabel.centerYAnchor),
            //percentLabel.topAnchor.constraint(equalTo: titlePromoLabel.topAnchor),
            //percentLabel.bottomAnchor.constraint(equalTo: titlePromoLabel.bottomAnchor)
        ])
        
        contentView.addSubview(infoButton)
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoButton.centerYAnchor.constraint(equalTo: percentLabel.centerYAnchor),
            infoButton.leadingAnchor.constraint(equalTo: percentLabel.trailingAnchor, constant: 8),
            infoButton.trailingAnchor.constraint(lessThanOrEqualTo: switchButton.leadingAnchor, constant: -8)
        ])
        
        promoView.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.topAnchor.constraint(equalTo: subPromoView.bottomAnchor, constant: 8).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: promoView.leadingAnchor, constant: 20).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: promoView.bottomAnchor, constant: -12).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: promoView.trailingAnchor, constant: -12).isActive = true
        
        promoView.addSubview(circleLeftView)
        circleLeftView.translatesAutoresizingMaskIntoConstraints = false
        circleLeftView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        circleLeftView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        circleLeftView.centerYAnchor.constraint(equalTo: promoView.centerYAnchor).isActive = true
        circleLeftView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        
        promoView.addSubview(circleRightView)
        circleRightView.translatesAutoresizingMaskIntoConstraints = false
        circleRightView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        circleRightView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        circleRightView.centerYAnchor.constraint(equalTo: promoView.centerYAnchor).isActive = true
        circleRightView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        
        /*promoView.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.topAnchor.constraint(equalTo: subPromoView.bottomAnchor, constant: 8).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: promoView.leadingAnchor, constant: 20).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: promoView.bottomAnchor, constant: -12).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: promoView.trailingAnchor, constant: -12).isActive = true*/
        
        
        
        
        /*percentLabel.topAnchor.constraint(equalTo: titlePromoLabel.topAnchor, constant: 1).isActive = true
        percentLabel.bottomAnchor.constraint(equalTo: titlePromoLabel.bottomAnchor, constant: -1).isActive = true
        NSLayoutConstraint(item: percentLabel, 
                           attribute: .leading,
                           relatedBy: .greaterThanOrEqual,
                           toItem: titlePromoLabel,
                           attribute: .trailing,
                           multiplier: 1,
                           constant: 8).isActive = true
        NSLayoutConstraint(item: percentLabel, 
                           attribute: .trailing,
                           relatedBy: .lessThanOrEqual,
                           toItem: switchButton,
                           attribute: .leading,
                           multiplier: 1, constant: 8).isActive = true*/
        
        
        
        titlePromoLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titlePromoLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        //itlePromoLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        percentLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        infoButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        switchButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        //promoLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        //percentLabel.centerYAnchor.constraint(equalTo: titlePromoLabel.centerYAnchor).isActive = true
        //percentLabel.leadingAnchor.constraint(equalTo: titlePromoLabel.trailingAnchor).isActive = true
        //percentLabel.leadingAnchor.constraint(equalTo: titlePromoLabel.).isActive = true
        
        /*applyPromocodeButton.addSubview(applyPromocodeImage)
        applyPromocodeImage.translatesAutoresizingMaskIntoConstraints = false
        applyPromocodeImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        applyPromocodeImage.trailingAnchor.constraint(equalTo: applyPromocodeButton.titleLabel?.leadingAnchor ?? applyPromocodeButton.leftAnchor, constant: -10).isActive = true*/
        
        //circleView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        //circleView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        //circleView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
        
            
        
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = self.viewModel.cellViewModels[indexPath.row]
        
        switch viewModel.type {
        case .applyPromo(let applyPromo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ApplyPromocodeCell.self)) as? ApplyPromocodeCell else {
                return UITableViewCell()
            }
            
            cell.viewModel = applyPromo
            
            return cell
        case .info(let info):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TitleCell.self)) as? TitleCell else {
                return UITableViewCell()
            }
            
            cell.viewModel = info
            
            return cell
        case .promo(let promo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PromoCell.self)) as? PromoCell else {
                return UITableViewCell()
            }
            
            cell.viewModel = promo
            return cell
        case .hidePromo(let hidePromo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HidePromoCell.self)) as? HidePromoCell else {
                return UITableViewCell()
            }
            
            cell.viewModel = hidePromo
            return cell
        case .totalPrice(let totalPrice):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TotalPriceCell.self)) as? TotalPriceCell else {
                return UITableViewCell()
            }
            
            cell.viewModel = totalPrice
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("select on = \(indexPath)")
    }
}

private extension ViewController {
    
    func errorAlert(message: String) {
        let alertVC = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(action)
        DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        }
        return
    }
    
    func showOrder(with order: Order) {
        
        do {
            try order.checkOrderData()
        } catch CheckOrderDataErrors.outOfProducts {
            errorAlert(message: "Products are empty")
        } catch CheckOrderDataErrors.priceLessThenZero {
            errorAlert(message: "Price less then zero")
        } catch CheckOrderDataErrors.totalPriceLessThenBaseDiscount {
            errorAlert(message: "Total price less then discount")
        } catch CheckOrderDataErrors.totalPriceLessThenActivePromos {
            errorAlert(message: "Activated promos is more then total price")
        } catch {
            errorAlert(message: "Oooups, something goes wrong...")
        }
        
        self.title = order.screenTitle
        
        viewModel.insertOrder(with: order)
    }
    
    func configure() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(emptyView)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        emptyView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        emptyView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: emptyView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
    }
}

